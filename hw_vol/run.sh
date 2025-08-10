# # Add your commands here
# IMAGE_NAME="hw_vol_image"
# TAG="latest"

# # 构建镜像
# echo "构建镜像..."
# docker build -t ${IMAGE_NAME}:${TAG} -f hw_vol/Dockerfile .

# # 创建共享目录（如果不存在）
# mkdir -p ./shared

# echo "---使用 volume 挂载编译并运行 add.cpp---"
# docker run --rm -v "$(pwd)/src:/src" -v "$(pwd)/shared:/shared" ${IMAGE_NAME}:${TAG} add.cpp 15 8

# echo ""

# echo "---使用 volume 挂载编译并运行 mul.cpp---"
# docker run --rm -v "$(pwd)/src:/src" -v "$(pwd)/shared:/shared" ${IMAGE_NAME}:${TAG} mul.cpp 15 8

# echo ""
# echo "编译生成的可执行文件："
# ls -la ./shared/

#!/bin/bash

# Add your commands here
IMAGE_NAME="hw_vol_image"
TAG="latest"

echo "🔨 构建镜像 ${IMAGE_NAME}:${TAG}..."
docker build -t ${IMAGE_NAME}:${TAG} -f hw_vol/Dockerfile .

if [ $? -ne 0 ]; then
    echo "❌ 镜像构建失败"
    exit 1
fi

echo "✅ 镜像构建成功"
echo ""

# 创建共享目录（如果不存在）
echo "📁 创建共享目录..."
mkdir -p ./shared

# 清理旧的可执行文件
rm -f ./shared/add ./shared/mul

echo "🔍 调试信息:"
echo "当前目录: $(pwd)"
echo "操作系统: $OSTYPE"
echo "检查文件结构:"
echo "- src 目录: $(ls src/ 2>/dev/null || echo '不存在')"
echo "- shared 目录: $(ls shared/ 2>/dev/null || echo '空目录')"
echo ""

echo "==================== 开始测试 ===================="
echo ""

# 方法1：使用绝对路径（推荐）
echo "📋 测试 1: 编译并运行 add.cpp"
echo "使用挂载命令: -v \"$PWD/src:/src:ro\" -v \"$PWD/shared:/shared\""
docker run --rm \
    -v "$PWD/src:/src:ro" \
    -v "$PWD/shared:/shared" \
    ${IMAGE_NAME}:${TAG} \
    add.cpp 15 8

echo ""

echo "📋 测试 2: 编译并运行 mul.cpp"
echo "使用挂载命令: -v \"$PWD/src:/src:ro\" -v \"$PWD/shared:/shared\""
docker run --rm \
    -v "$PWD/src:/src:ro" \
    -v "$PWD/shared:/shared" \
    ${IMAGE_NAME}:${TAG} \
    mul.cpp 15 8

echo ""
echo "==================== 测试完成 ===================="
echo ""

echo "📂 编译生成的可执行文件："
if [ -d "./shared" ]; then
    ls -la ./shared/
    echo ""
    echo "🎯 文件大小统计："
    du -h ./shared/* 2>/dev/null || echo "没有生成可执行文件"
else
    echo "❌ shared 目录不存在"
fi

echo ""
echo "🧪 额外测试: 直接在主机上运行编译好的程序"
if [ -f "./shared/add" ]; then
    echo "测试 add 程序: ./shared/add 100 200"
    ./shared/add 100 200 2>/dev/null || echo "无法在 Windows 上直接运行 Linux 可执行文件（这是正常的）"
fi

if [ -f "./shared/mul" ]; then
    echo "测试 mul 程序: ./shared/mul 100 200"
    ./shared/mul 100 200 2>/dev/null || echo "无法在 Windows 上直接运行 Linux 可执行文件（这是正常的）"
fi

echo ""
echo "💡 提示: 生成的是 Linux 可执行文件，无法在 Windows 上直接运行，但已成功保存到 shared 目录"