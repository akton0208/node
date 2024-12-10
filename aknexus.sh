#!/bin/bash

# 更新包列表
apt update

# 安装必要的软件包
apt install -y build-essential pkg-config libssl-dev git cargo curl screen unzip

# 下载并解压 protoc
wget https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protoc-21.9-linux-x86_64.zip
unzip protoc-21.9-linux-x86_64.zip -d $HOME/.local

# 设置环境变量
export PATH="$HOME/.local/bin:$PATH"

# 安装 rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 加载 cargo 环境变量
source $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"

# 重新加载 bash 配置
source ~/.bashrc

# 创建 .nexus 目录（如果不存在）
mkdir -p ~/.nexus

# 将 PROVER_ID 写入文件
echo "WG9GN3g5goVW3QCQMM16sV4eQq62" > ~/.nexus/prover-id

# 执行 Nexus CLI 安装脚本
curl https://cli.nexus.xyz/ | sh

echo "所有操作已完成！"
