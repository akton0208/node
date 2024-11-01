#!/bin/bash

# Define the update function
update_version() {
  read -p "Please enter version (e.g., v0.39.4): " quai_version
  stop_and_remove_services
  rm -rf ~/.local/share/go-quai/0xba33a6807db85d5de6f51ff95c4805feaa9b81951a57e43254117d489031e96f
  cd /root/go-quai || { echo "Failed to enter directory /root/go-quai"; return 1; }
  git fetch --tags
  git checkout "$quai_version" || { echo "Failed to checkout version $quai_version"; return 1; }
  make go-quai || { echo "Build failed"; return 1; }
  cd ~ || { echo "Failed to return to home directory"; return 1; }

  echo "Update completed."
}

# Define the function to create and start go-quai and go-quai-stratum services
create_and_start_services() {
  rm -rf ~/.local/share/go-quai/0xba33a6807db85d5de6f51ff95c4805feaa9b81951a57e43254117d489031e96f
  read -p "Please enter quai-coinbases address: " quai_coinbases
  read -p "Please enter qi-coinbases address: " qi_coinbases
  read -p "請輸入0.5或0或1, 0.5是一半QUAI一半QI, 0是全QUAI, 1是全QI: " node_miner
  read -p "質押加乘選項, 請輸入0或1或2或3, 0是0%, 1是+4.17%, 2是+10%, 3是+25%, 注意0要等7200區塊, 1要等30240, 2要等60480, 3要等120960: " node_coinbase

  if [[ -z "$quai_coinbases" || -z "$qi_coinbases" || -z "$node_miner" || -z "$node_coinbase" ]]; then
    echo "All input fields must be filled."
    return 1
  fi

  # Create go-quai service file
  SERVICE_FILE="/etc/systemd/system/go-quai.service"
  sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Go-Quai Node
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/go-quai
ExecStart=/bin/bash -c 'taskset -c 0-5 /root/go-quai/build/bin/go-quai start \\
  --node.slices "[0 0]" \\
  --node.genesis-nonce 6224362036655375007 \\
  --node.quai-coinbases "$quai_coinbases" \\
  --node.qi-coinbases "$qi_coinbases" \\
  --node.miner-preference "$node_miner" \\
  --node.coinbase-lockup "$node_coinbase"'
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal
Environment=GO_QUAI_LOG_DIR=/root/go-quai/build/bin/nodelogs

[Install]
WantedBy=multi-user.target
EOL

  # Create go-quai-stratum service file
  SERVICE_FILE="/etc/systemd/system/go-quai-stratum.service"
  sudo bash -c "cat > $SERVICE_FILE" <<EOL
[Unit]
Description=Go-Quai Stratum
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/root/go-quai-stratum
ExecStart=/bin/bash -c 'cd /root/go-quai-stratum && ./build/bin/go-quai-stratum --region=cyprus --zone=cyprus1'
Restart=always
RestartSec=10
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOL

  echo "Reloading systemd configuration..."
  sudo systemctl daemon-reload

  echo "Starting and enabling go-quai and go-quai-stratum services..."
  sudo systemctl start go-quai
  sudo systemctl enable go-quai
  sudo systemctl start go-quai-stratum
  sudo systemctl enable go-quai-stratum

  echo "Go-Quai and Go-Quai Stratum services have been started and enabled to start on boot."
}

# Define the function to stop and remove go-quai and go-quai-stratum services
stop_and_remove_services() {
  echo "Stopping go-quai and go-quai-stratum services..."
  sudo systemctl stop go-quai
  sudo systemctl stop go-quai-stratum

  echo "Disabling go-quai and go-quai-stratum services..."
  sudo systemctl disable go-quai
  sudo systemctl disable go-quai-stratum

  echo "Removing go-quai and go-quai-stratum service files..."
  sudo rm /etc/systemd/system/go-quai.service
  sudo rm /etc/systemd/system/go-quai-stratum.service

  echo "Reloading systemd configuration..."
  sudo systemctl daemon-reload

  echo "Go-Quai and Go-Quai Stratum services have been stopped and removed."
}

# Define the function to view go-quai service logs
view_go_quai_logs() {
  echo "Viewing go-quai service logs..."
  sudo journalctl -u go-quai -f
}

# Define the function to view go-quai-stratum service logs
view_go_quai_stratum_logs() {
  echo "Viewing go-quai-stratum service logs..."
  sudo journalctl -u go-quai-stratum -f
}

view_block() {
  echo "Viewing block..."
  sudo journalctl -u go-quai-stratum | grep "Miner submitted a block"
}

check_sync() {
  echo "Checking Sync Status..."
  tail -f ~/go-quai/nodelogs/* | grep Appended
}

restart_service() {
  echo "restart service..."
  stop_and_remove_services
  create_and_start_services
}

install_snapshot() {
  echo "downloading snapshot..."
  stop_and_remove_services
  wget -O quai-goldenage-backup.tgz https://storage.googleapis.com/colosseum-db/goldenage_backups/quai-goldenage-backup.tgz
  rm -rf ~/.local/share/go-quai
  tar -xvf quai-goldenage-backup.tgz
  cp -r quai-goldenage-backup ~/.local/share/go-quai
}

auto_start() {
  echo "downloading snapshot..."
  update_version
  install_snapshot
  create_and_start_services
}

# Display menu
while true; do
  echo "Showing AK logo..."
  wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh && chmod +x loader.sh && ./loader.sh
  curl -s https://raw.githubusercontent.com/akton0208/node/main/ak.sh | bash
  echo "Menu:"
  echo "1) 更新版本"
  echo "2) 開始"
  echo "3) 停止"
  echo "4) 查看節點"
  echo "5) 查看橋"
  echo "6) 查看挖到的塊"
  echo "7) 查看同步狀態"
  echo "8) 重啟節點及橋"
  echo "9) 下載官方快照"
  echo "111) 懶人用"  
  echo "520) Exit" 
  read -p "Please choose an option: " choice

  case $choice in
    1)
      update_version
      ;;
    2)
      create_and_start_services
      ;;
    3)
      stop_and_remove_services
      ;;
    4)
      view_go_quai_logs
      ;;
    5)
      view_go_quai_stratum_logs
      ;;
    6)
      view_block
      ;;
    7)
      check_sync
      ;;
    8)
      restart_service
      ;;
    9)
      install_snapshot
      ;;
    111)
      auto_start
      ;;
    520)
      echo "Exiting program."
      break
      ;;
    *)
      echo "Invalid option, please choose again."
      ;;
  esac
done
