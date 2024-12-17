#!/bin/bash

# 提示用戶輸入VANA_PRIVATE_KEY
read -p "請輸入你的VANA_PRIVATE_KEY: " VANA_PRIVATE_KEY

# 設置環境變量
export VANA_PRIVATE_KEY=$VANA_PRIVATE_KEY
export VANA_NETWORK=moksha
export OLLAMA_API_URL=http://ollama:11434/api

# 更新包列表
sudo apt update

# 安裝必要的包
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# 添加Docker的GPG密鑰
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# 添加Docker的APT源
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

# 再次更新包列表
sudo apt update

# 安裝Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# 啟動並啟用Docker服務
sudo systemctl start docker
sudo systemctl enable docker

# 克隆GitHub倉庫
git clone https://github.com/sixgpt/miner.git

# 進入克隆的倉庫目錄
cd miner

# 啟動Docker Compose
docker compose up -d

echo "Docker安裝完成，倉庫已克隆並進入miner目錄，環境變量已設置，Docker Compose已啟動！"
