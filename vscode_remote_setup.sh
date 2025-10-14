#!/bin/bash

set -e

# ========== 0. 基础设置 ==========
WORK_DIR=~/vscode_remote_setup
GLIBC_VER=2.28
GLIBC_TAR=glibc-${GLIBC_VER}.tar.gz
GLIBC_SRC=glibc-${GLIBC_VER}
GLIBC_BUILD_DIR=${WORK_DIR}/glibc-build
GLIBC_INSTALL_DIR=~/tools/glibc
VSCODE_COMMIT_ID=385651c938df8a906869babee516bffd0ddb9829

# 安裝ssh客戶端
sudo apt update
sudo apt install openssh-server -y
sudo systemctl start ssh
 
# 开机自启动
sudo systemctl enable ssh

echo "👉 清理旧的 glibc 编译缓存..."
rm -rf $GLIBC_BUILD_DIR
rm -rf $WORK_DIR/$GLIBC_SRC
rm -rf $GLIBC_INSTALL_DIR

echo "👉 清理旧的 .vscode-server 文件..."
rm -rf ~/.vscode-server

# ========== 1. 安装依赖 ==========
echo "👉 安装 glibc 所需的依赖..."
sudo apt update
sudo apt install -y build-essential gawk bison

# ========== 2. 安装 glibc ==========
mkdir -p $GLIBC_INSTALL_DIR
cd $WORK_DIR

echo "📦 解压 glibc..."
tar -xzf $GLIBC_TAR

mkdir -p $GLIBC_BUILD_DIR
cd $GLIBC_BUILD_DIR

echo "⚙️ 配置 glibc 编译..."
../$GLIBC_SRC/configure --prefix=$GLIBC_INSTALL_DIR --disable-werror

echo "🔨 编译 glibc 中..."
make -j$(nproc)
make install

# ========== 3. 配置 VSCode Server ==========
echo "🧩 配置 .vscode-server 本地部署..."

mkdir -p ~/.vscode-server/bin
mkdir -p ~/.vscode-server/cli/servers/Stable-${VSCODE_COMMIT_ID}

cd $WORK_DIR

echo "📦 解压 vscode-server..."
tar -xzf vscode-server-linux-x64.tar.gz
mv vscode-server-linux-x64 server
mv server ~/.vscode-server/cli/servers/Stable-${VSCODE_COMMIT_ID}/

echo "📦 解压 vscode-cli..."
tar -xzf vscode_cli_alpine_x64_cli.tar.gz
mv code ~/.vscode-server/code-${VSCODE_COMMIT_ID}

# ========== 4. 创建 iru.json ==========
echo "📝 创建 iru.json..."
echo "[\"Stable-${VSCODE_COMMIT_ID}\"]" > ~/.vscode-server/cli/iru.json

# ========== 5. 环境变量建议提示 ==========
echo ""
echo "✅ 完成！你可以将以下内容添加到你的 ~/.bashrc："
echo ""
cat <<EOF
***********************************************************************************************************************************************************************
# ========== VSCode Remote Custom GLIBC ==========
export VSCODE_SERVER_CUSTOM_GLIBC_LINKER=\$HOME/tools/glibc/lib/ld-2.28.so
export VSCODE_SERVER_CUSTOM_GLIBC_PATH=\$HOME/tools/glibc/lib:\$HOME/tools/glibc/lib64
export VSCODE_SERVER_PATCHELF_PATH=\$(which patchelf)
# "创建临时文档以欺骗vscode从而通过版本检查"
touch /tmp/vscode-skip-server-requirements-check
***********************************************************************************************************************************************************************
EOF

echo ""
echo "✅ 最后一步：请运行以下命令启用上述配置（或重启终端）"
echo "source ~/.bashrc"

