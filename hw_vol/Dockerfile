FROM ubuntu:20.04

# Add your commands here
WORKDIR /app

# 设置非交互模式，避免安装过程中的提示
ENV DEBIAN_FRONTEND=noninteractive

# 安装 g++ 编译器并清理缓存
RUN apt-get update && \
    apt-get install -y g++ && \
    rm -rf /var/lib/apt/lists/*

# 创建编译脚本
RUN echo '#!/bin/bash' > /app/compile_and_run.sh && \
    echo 'set -e  # 遇到错误立即退出' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 检查参数数量' >> /app/compile_and_run.sh && \
    echo 'if [ "$#" -lt 3 ]; then' >> /app/compile_and_run.sh && \
    echo '    echo "Usage: $0 <source_file> <arg1> <arg2>"' >> /app/compile_and_run.sh && \
    echo '    echo "Example: $0 add.cpp 10 5"' >> /app/compile_and_run.sh && \
    echo '    exit 1' >> /app/compile_and_run.sh && \
    echo 'fi' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 获取参数' >> /app/compile_and_run.sh && \
    echo 'SOURCE_FILE=$1' >> /app/compile_and_run.sh && \
    echo 'ARG1=$2' >> /app/compile_and_run.sh && \
    echo 'ARG2=$3' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 生成可执行文件名（去掉.cpp扩展名）' >> /app/compile_and_run.sh && \
    echo 'EXECUTABLE=$(basename "$SOURCE_FILE" .cpp)' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 检查源文件是否存在' >> /app/compile_and_run.sh && \
    echo 'if [ ! -f "/src/$SOURCE_FILE" ]; then' >> /app/compile_and_run.sh && \
    echo '    echo "错误: 源文件 /src/$SOURCE_FILE 不存在"' >> /app/compile_and_run.sh && \
    echo '    echo "可用文件:"' >> /app/compile_and_run.sh && \
    echo '    ls -la /src/' >> /app/compile_and_run.sh && \
    echo '    exit 1' >> /app/compile_and_run.sh && \
    echo 'fi' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 编译源文件' >> /app/compile_and_run.sh && \
    echo 'echo "=== 编译 $SOURCE_FILE ==="' >> /app/compile_and_run.sh && \
    echo 'g++ "/src/$SOURCE_FILE" -o "/shared/$EXECUTABLE"' >> /app/compile_and_run.sh && \
    echo '' >> /app/compile_and_run.sh && \
    echo '# 检查编译结果并运行' >> /app/compile_and_run.sh && \
    echo 'if [ $? -eq 0 ]; then' >> /app/compile_and_run.sh && \
    echo '    echo "编译成功！"' >> /app/compile_and_run.sh && \
    echo '    echo "=== 运行程序: $EXECUTABLE $ARG1 $ARG2 ==="' >> /app/compile_and_run.sh && \
    echo '    "/shared/$EXECUTABLE" "$ARG1" "$ARG2"' >> /app/compile_and_run.sh && \
    echo '    echo ""' >> /app/compile_and_run.sh && \
    echo '    echo "可执行文件 $EXECUTABLE 已保存到主机的 shared 目录中"' >> /app/compile_and_run.sh && \
    echo 'else' >> /app/compile_and_run.sh && \
    echo '    echo "编译失败"' >> /app/compile_and_run.sh && \
    echo '    exit 1' >> /app/compile_and_run.sh && \
    echo 'fi' >> /app/compile_and_run.sh && \
    chmod +x /app/compile_and_run.sh

ENTRYPOINT ["/app/compile_and_run.sh"]