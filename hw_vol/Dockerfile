FROM ubuntu:20.04

# Add your commands here
WORKDIR /app

# 安装 g++ 编译器
RUN apt-get update && apt-get install -y g++ && rm -rf /var/lib/apt/lists/*

# 创建编译脚本
RUN echo '#!/bin/bash' > /app/compile_and_run.sh && \
    echo 'if [ "$#" -lt 3 ]; then' >> /app/compile_and_run.sh && \
    echo '    echo "Usage: $0 <source_file> <arg1> <arg2>"' >> /app/compile_and_run.sh && \
    echo '    exit 1' >> /app/compile_and_run.sh && \
    echo 'fi' >> /app/compile_and_run.sh && \
    echo 'SOURCE_FILE=$1' >> /app/compile_and_run.sh && \
    echo 'ARG1=$2' >> /app/compile_and_run.sh && \
    echo 'ARG2=$3' >> /app/compile_and_run.sh && \
    echo 'EXECUTABLE=$(basename "$SOURCE_FILE" .cpp)' >> /app/compile_and_run.sh && \
    echo 'echo "编译 $SOURCE_FILE..."' >> /app/compile_and_run.sh && \
    echo 'g++ "/src/$SOURCE_FILE" -o "/shared/$EXECUTABLE"' >> /app/compile_and_run.sh && \
    echo 'if [ $? -eq 0 ]; then' >> /app/compile_and_run.sh && \
    echo '    echo "编译成功，运行程序..."' >> /app/compile_and_run.sh && \
    echo '    "/shared/$EXECUTABLE" "$ARG1" "$ARG2"' >> /app/compile_and_run.sh && \
    echo '    echo "可执行文件已保存到主机的挂载目录中: $EXECUTABLE"' >> /app/compile_and_run.sh && \
    echo 'else' >> /app/compile_and_run.sh && \
    echo '    echo "编译失败"' >> /app/compile_and_run.sh && \
    echo '    exit 1' >> /app/compile_and_run.sh && \
    echo 'fi' >> /app/compile_and_run.sh && \
    chmod +x /app/compile_and_run.sh

ENTRYPOINT ["/app/compile_and_run.sh"]