FROM ubuntu:20.04

# Add your commands here
WORKDIR /app

# 设置非交互模式，避免安装过程中的提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 g++ 编译器并清理缓存
RUN apt-get update && \
    apt-get install -y g++ && \
    rm -rf /var/lib/apt/lists/*

# 不需要复杂的脚本，直接使用bash作为入口点
ENTRYPOINT ["/bin/bash", "-c"]