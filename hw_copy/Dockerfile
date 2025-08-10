FROM ubuntu:20.04

# Add your commands here
### 构建镜像时请在项目根目录（包含 src 文件夹）下执行 docker build -t hw_copy_image:latest hw_copy/
### 这样 COPY src/add.cpp /app/add.cpp 才能找到 src 目录
WORKDIR /app

RUN apt-get update && apt-get install -y g++

COPY src/add.cpp /app/add.cpp
COPY src/mul.cpp /app/mul.cpp

RUN g++ add.cpp -o add && g++ mul.cpp -o mul

# 允许通过参数运行 add 或 mul 程序
ENTRYPOINT []