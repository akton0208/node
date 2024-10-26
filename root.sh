#!/bin/bash

# 取消註釋 PermitRootLogin yes
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/' /etc/ssh/sshd_config

# 設置 root 密碼
echo "請輸入新的 root 密碼："
sudo passwd root

# 重啟 SSH 服務
sudo systemctl restart ssh

echo "配置已完成，您現在可以使用 root 用戶登入。"
