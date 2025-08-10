# Add your commands here
IMAGE_NAME="hw_vol_image"
TAG="latest"

echo "构建镜像 ${IMAGE_NAME}:${TAG}..."
docker build -t ${IMAGE_NAME}:${TAG} -f hw_vol/Dockerfile .

echo "镜像构建成功"
echo ""

# 创建共享目录
mkdir -p shared

echo "==================== 使用挂载编译运行 ===================="
echo ""

# 获取Windows路径
CURRENT_PATH=$(cygpath -aw .)
echo "当前路径: $CURRENT_PATH"

echo "编译并运行 add.cpp"
docker run --rm \
    -v "${CURRENT_PATH}:/workspace" \
    ${IMAGE_NAME}:${TAG} \
    "cd /workspace && g++ src/add.cpp -o shared/add && echo '编译add.cpp成功' && ./shared/add 15 8"

echo ""

echo "编译并运行 mul.cpp"
docker run --rm \
    -v "${CURRENT_PATH}:/workspace" \
    ${IMAGE_NAME}:${TAG} \
    "cd /workspace && g++ src/mul.cpp -o shared/mul && echo '编译mul.cpp成功' && ./shared/mul 15 8"

echo ""
echo "==================== 检查结果 ===================="

echo "编译生成的可执行文件："
ls -la shared/

if [ -f "shared/add" ] && [ -f "shared/mul" ]; then
    echo ""
    echo "任务完成！"
    echo "通过挂载本地目录的方式编译了源文件"
    echo "传入了程序运行所需的参数 (15 8)"
    echo "将编译好的文件返回给了宿主机"
else
    echo "编译失败"
fi