#!/bin/bash

# 定義函數來顯示選單
show_menu() {
    echo "請選擇一個選項:"
    echo "1) 安裝 Docker 並設置 BrinxAI Worker Nodes"
    echo "2) 運行 Stable Diffusion 容器 (要求8C8G)"
    echo "3) 運行 Text UI 容器(要求4C4G)"
    echo "4) 運行 Rembg 容器(要求2C2G)"
    echo "5) 運行 Upscaler 容器(要求2C2G)"
    echo "6) 運行 Relay 容器(要求極低, 分數也低)"
    echo "7) 查看 BrinxAI Worker Nodes 日誌"
    echo "8) 退出"
}

# 定義函數來處理選項
handle_option() {
    case $1 in
        1)
            echo "正在安裝 Docker 並設置 BrinxAI Worker Nodes..."
            sudo apt update
            sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
            sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
            sudo apt update
            sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            docker pull admier/brinxai_nodes-worker:latest
            git clone https://github.com/admier1/BrinxAI-Worker-Nodes
            cd BrinxAI-Worker-Nodes
            chmod +x install_ubuntu.sh
            ./install_ubuntu.sh
            docker --version
            echo "安裝完成！"
            ;;
        2)
            echo "正在運行 Stable Diffusion 容器..."
            docker run -d --name stable-diffusion --network brinxai-network --cpus=8 --memory=8192m -p 127.0.0.1:5050:5050 admier/brinxai_nodes-stabled:latest
            echo "Stable Diffusion 容器已啟動！"
            ;;
        3)
            echo "正在運行 Text UI 容器..."
            docker run -d --name text-ui --network brinxai-network --cpus=4 --memory=4096m -p 127.0.0.1:5000:5000 admier/brinxai_nodes-text-ui:latest
            echo "Text UI 容器已啟動！"
            ;;
        4)
            echo "正在運行 Rembg 容器..."
            docker run -d --name rembg --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:7000:7000 admier/brinxai_nodes-rembg:latest
            echo "Rembg 容器已啟動！"
            ;;
        5)
            echo "正在運行 Upscaler 容器..."
            docker run -d --name upscaler --network brinxai-network --cpus=2 --memory=2048m -p 127.0.0.1:3000:3000 admier/brinxai_nodes-upscaler:latest
            echo "Upscaler 容器已啟動！"
            ;;
        6)
            echo "正在運行 Relay 容器..."
            docker pull admier/brinxai_nodes-relay:latest
            sudo docker run -d --name brinxai_relay --cap-add=NET_ADMIN admier/brinxai_nodes-relay:latest
            echo "Relay 容器已啟動！"
            ;;
        7)
            echo "正在查看 BrinxAI Worker Nodes 日誌..."
            sudo docker logs brinxai-worker-nodes-worker-1
            ;;
        8)
            echo "退出腳本。"
            exit 0
            ;;
        *)
            echo "無效選項，請重新選擇。"
            ;;
    esac
}

# 主循環
while true; do
    show_menu
    read -p "輸入選項號碼: " option
    handle_option $option
done
