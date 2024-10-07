#!/bin/bash

# 顯示選單
echo "請選擇一個選項:"
echo "1) 安裝 Docker 並設置 BrinxAI Worker Nodes"
echo "2) 運行 Stable Diffusion 容器"
echo "3) 運行 Text UI 容器"
echo "4) 運行 Rembg 容器"
echo "5) 運行 Upscaler 容器"
echo "6) 運行 Relay 容器"
echo "7) 查看 BrinxAI Worker Nodes 日誌"
echo "8) 退出"

# 讀取用戶輸入
read -p "輸入選項號碼: " option

case $option in
    1)
        # 選項 1: 安裝 Docker 並設置 BrinxAI Worker Nodes
        echo "正在安裝 Docker 並設置 BrinxAI Worker Nodes..."
        
        # 更新包列表並安裝必要的包
        sudo apt update
        sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

        # 添加 Docker 的官方 GPG 密鑰
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        # 添加 Docker 的 APT 存儲庫
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

        # 更新包列表並安裝 Docker
        sudo apt update
        sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

        # 拉取 Docker 映像
        docker pull admier/brinxai_nodes-worker:latest

        # 克隆 GitHub 存儲庫
        git clone https://github.com/admier1/BrinxAI-Worker-Nodes

        # 進入存儲庫目錄
        cd BrinxAI-Worker-Nodes

        # 賦予安裝腳本執行權限並運行
        chmod +x install_ubuntu.sh
        ./install_ubuntu.sh

        # 顯示 Docker 版本以確認安裝成功
        docker --version

        echo "安裝完成！"
        ;;
    2)
        # 選項 2: 運行 Stable Diffusion 容器
        echo "正在運行 Stable Diffusion 容器..."
        docker run -d --name stable-diffusion --network brinxai-network --cpus=8 --memory=8192m -p 127.0.0.1:5050:5050 admier/brinxai_nodes-stabled:latest
        echo "Stable Diffusion 容器已啟動！"
        ;;
    3)
        # 選項 3: 運行 Text UI 容器
        echo "正在運行 Text UI 容器..."
        docker run -d --name text-ui --network brinxai-network --cpus=4 --memory=4096m -p 127.0.0.1:5000:5000 admier/brinxai_nodes-text-ui:latest
        echo "Text UI 容器已啟動！"
        ;;
    4)
        # 選項 4: 運行 Rembg 容器
        echo "正在運行 Rembg 容器..."
        docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:7000:7000 admier/brinxai_nodes-rembg:latest
        echo "Rembg 容器已啟動！"
        ;;
    5)
        # 選項 5: 運行 Upscaler 容器
        echo "正在運行 Upscaler 容器..."
        docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
        echo "Upscaler 容器已啟動！"
        ;;
    6)
        # 選項 6: 運行 Relay 容器
        echo "正在運行 Relay 容器..."
        docker pull admier/brinxai_nodes-relay:latest
        sudo docker run -d --name brinxai_relay --cap-add=NET_ADMIN admier/brinxai_nodes-relay:latest
        echo "Relay 容器已啟動！"
        ;;
    7)
        # 選項 7: 查看 BrinxAI Worker Nodes 日誌
        echo "正在查看 BrinxAI Worker Nodes 日誌..."
        sudo docker logs brinxai-worker-nodes-worker-1
        ;;
    8)
        # 選項 8: 退出
        echo "退出腳本。"
        exit 0
        ;;
    *)
        # 無效選項
        echo "無效選項，請重新運行腳本並選擇有效選項。"
        ;;
esac
