FROM ubuntu:20.04

# Add your commands here
WORKDIR /app

RUN apt-get update && apt-get install -y g++

COPY src/add.cpp /app/add.cpp
COPY src/mul.cpp /app/mul.cpp

RUN g++ add.cpp -o add && g++ mul.cpp -o mul

# 允许通过参数运行 add 或 mul 程序
ENTRYPOINT []
CMD []