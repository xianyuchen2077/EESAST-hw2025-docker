# Add your commands here
IMAGE_NAME="hw_copy_image"
TAG="latest"

echo "正在构建镜像..."
docker build -t ${IMAGE_NAME}:${TAG} -f hw_copy/Dockerfile .

echo "---运行 add.cpp 生成的 add 程序---"
docker run --rm --name hw_copy_container ${IMAGE_NAME}:${TAG} ./add 10 5

echo ""

echo "---运行 mul.cpp 生成的 mul 程序---"
docker run --rm --name hw_copy_container ${IMAGE_NAME}:${TAG} ./mul 10 5