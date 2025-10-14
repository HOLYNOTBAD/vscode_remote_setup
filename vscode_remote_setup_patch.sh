#!/bin/bash

set -e

# ========== 0. 配置 ==========
GLIBC_DIR=$HOME/tools/glibc/lib
VSCODE_COMMIT_ID=385651c938df8a906869babee516bffd0ddb9829
NODE_BIN_DIR=$HOME/.vscode-server/cli/servers/Stable-${VSCODE_COMMIT_ID}/server

# 系统标准库路径（确保 libstdc++、libgcc_s 可访问）
SYS_LIB_PATH1=/usr/lib/x86_64-linux-gnu
SYS_LIB_PATH2=/lib/x86_64-linux-gnu

# ========== 1. 安装 patchelf ==========
echo "🔧 安装 patchelf..."
sudo apt update
sudo apt install -y patchelf

# ========== 2. 使用 patchelf 修补 node ==========
echo "🔧 进入 node 目录并修补 ELF..."
cd $NODE_BIN_DIR

echo "👉 设置动态链接器为: $GLIBC_DIR/ld-2.28.so"
patchelf --set-interpreter $GLIBC_DIR/ld-2.28.so node

echo "👉 设置 rpath 为: $GLIBC_DIR:$SYS_LIB_PATH1:$SYS_LIB_PATH2"
patchelf --set-rpath "$GLIBC_DIR:$SYS_LIB_PATH1:$SYS_LIB_PATH2" node

# ========== 3. 显示当前目录并停留 ==========
echo "✅ 修补完成！"
echo "📂 当前所在目录为："
pwd

echo "创建临时文档以欺骗vscode从而通过版本检查"
touch /tmp/vscode-skip-server-requirements-check

echo "可以输入一下两个命令来检查环境配置结果："
echo "ldd ./node"
echo "./node -v"

echo "我将重启bash"
exec bash


