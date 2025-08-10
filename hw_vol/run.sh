# Add your commands here
IMAGE_NAME="hw_vol_image"
TAG="latest"

echo "构建镜像 ${IMAGE_NAME}:${TAG}..."
docker build -t ${IMAGE_NAME}:${TAG} -f hw_vol/Dockerfile .

if [ $? -ne 0 ]; then
    echo "镜像构建失败"
    exit 1
fi

echo "镜像构建成功"
echo ""

# 获取当前目录的Windows路径格式
if command -v cygpath >/dev/null 2>&1; then
    # 在Git Bash中，使用cygpath转换路径
    CURRENT_PATH=$(cygpath -aw .)
    echo "当前路径: $CURRENT_PATH"
else
    # 如果没有cygpath，尝试其他方法
    CURRENT_PATH=$(pwd | sed 's|^/c/|C:/|' | sed 's|^/\([a-z]\)/|\U\1:/|')
    echo "当前路径: $CURRENT_PATH"
fi

echo "创建共享目录..."
mkdir -p shared

echo ""
echo "==================== 开始编译和运行 ===================="
echo ""

echo "编译并运行 add.cpp"
echo "使用挂载路径: ${CURRENT_PATH}:/workspace"
docker run --rm \
    -v "${CURRENT_PATH}:/workspace" \
    -w "/workspace" \
    ubuntu:20.04 \
    bash -c "
        echo '=== 容器内环境 ==='
        echo '工作目录:' \$(pwd)
        echo '检查文件:'
        ls -la src/ 2>/dev/null || echo 'src目录不存在'
        echo ''

        echo '=== 安装编译工具 ==='
        export DEBIAN_FRONTEND=noninteractive
        apt-get update > /dev/null 2>&1 && apt-get install -y g++ > /dev/null 2>&1

        echo '=== 编译 add.cpp ==='
        if [ -f 'src/add.cpp' ]; then
            g++ src/add.cpp -o shared/add
            if [ \$? -eq 0 ]; then
                echo '编译成功'
                echo '=== 运行程序 ==='
                chmod +x shared/add
                ./shared/add 15 8
            else
                echo '编译失败'
                exit 1
            fi
        else
            echo '源文件 src/add.cpp 不存在'
            exit 1
        fi
    "

echo ""

echo "编译并运行 mul.cpp"
docker run --rm \
    -v "${CURRENT_PATH}:/workspace" \
    -w "/workspace" \
    ubuntu:20.04 \
    bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt-get update > /dev/null 2>&1 && apt-get install -y g++ > /dev/null 2>&1
        
        echo '=== 编译 mul.cpp ==='
        if [ -f 'src/mul.cpp' ]; then
            g++ src/mul.cpp -o shared/mul
            if [ \$? -eq 0 ]; then
                echo '编译成功'
                echo '=== 运行程序 ==='
                chmod +x shared/mul
                ./shared/mul 15 8
            else
                echo '编译失败'
                exit 1
            fi
        else
            echo '源文件 src/mul.cpp 不存在'
            exit 1
        fi
    "

echo ""
echo "==================== 任务完成 ===================="
echo ""

echo "编译生成的可执行文件："
if [ -d "shared" ]; then
    ls -la shared/
    echo ""

    if [ -f "shared/add" ] && [ -f "shared/mul" ]; then
        echo "🎉 恭喜！任务完成！"
        echo "✅ add 和 mul 程序都编译成功"
        echo "✅ 可执行文件已保存到 shared 目录"
        echo "✅ 程序运行结果已显示在上面"
        echo ""
        echo "📊 文件信息："
        ls -lh shared/add shared/mul 2>/dev/null
        echo ""
        echo "💡 说明：生成的是 Linux 可执行文件，无法在 Windows 上直接运行"
        echo "    但它们可以在任何 Linux 容器或系统中运行"
    else
        echo "❌ 部分文件编译失败"
        echo "请检查错误信息"
    fi
else
    echo "❌ shared 目录不存在"
fi