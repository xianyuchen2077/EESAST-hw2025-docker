# Add your commands here
IMAGE_NAME="hw_vol_image"
TAG="latest"

# 构建镜像
echo "构建镜像..."
docker build -t ${IMAGE_NAME}:${TAG} -f hw_vol/Dockerfile .

# 创建共享目录（如果不存在）
mkdir -p ./shared

echo "---使用 volume 挂载编译并运行 add.cpp---"
docker run --rm -v "$(pwd)/src:/src" -v "$(pwd)/shared:/shared" ${IMAGE_NAME}:${TAG} add.cpp 15 8

echo ""

echo "---使用 volume 挂载编译并运行 mul.cpp---"
docker run --rm -v "$(pwd)/src:/src" -v "$(pwd)/shared:/shared" ${IMAGE_NAME}:${TAG} mul.cpp 15 8

echo ""
echo "编译生成的可执行文件："
ls -la ./shared/