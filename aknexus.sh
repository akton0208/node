#!/bin/bash

NEXUS_HOME=$HOME/.nexus

# 定義功能函數
function setup_environment {
  # 更新並升級所有包
  sudo apt update && sudo apt upgrade -y

  # 定義需要安裝的軟件包
  packages=(
    curl
    iptables
    build-essential
    git
    wget
    lz4
    jq
    make
    gcc
    nano
    automake
    autoconf
    tmux
    htop
    nvme-cli
    pkg-config
    libssl-dev
    libleveldb-dev
    tar
    clang
    bsdmainutils
    ncdu
    unzip
    libleveldb-dev
  )

  # 檢查並安裝未安裝的軟件包
  for package in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $package "; then
      echo "Installing $package..."
      sudo apt install -y $package
    else
      echo "$package is already installed."
    fi
  done

  # 安裝 Rust
  if ! command -v rustup &> /dev/null; then
    sudo curl https://sh.rustup.rs -sSf | sh
    source $HOME/.cargo/env
    export PATH="$HOME/.cargo/bin:$PATH"
  else
    echo "Rust is already installed."
  fi

  rustc --version || curl https://sh.rustup.rs -sSf | sh
  NEXUS_HOME=$HOME/.nexus

  while [ -z "$NONINTERACTIVE" ]; do
      read -p "Do you agree to the Nexus Beta Terms of Use (https://nexus.xyz/terms-of-use)? (Y/n) " yn </dev/tty
      case $yn in
          [Nn]* ) exit;;
          [Yy]* ) break;;
          "" ) break;;
          * ) echo "Please answer yes or no.";;
      esac
  done

  git --version 2>&1 >/dev/null
  GIT_IS_AVAILABLE=$?
  if [ $GIT_IS_AVAILABLE != 0 ]; then
    echo Unable to find git. Please install it and try again.
    exit 1;
  fi

  if [ -d "$NEXUS_HOME/network-api" ]; then
    echo "$NEXUS_HOME/network-api exists. Updating.";
    (cd $NEXUS_HOME/network-api && git pull)
  else
    mkdir -p $NEXUS_HOME
    (cd $NEXUS_HOME && git clone https://github.com/nexus-xyz/network-api)
  fi
  
  cd $NEXUS_HOME/network-api/clients/cli && cargo build --release
}

function view_prover_id {
  cat $HOME/.nexus/prover-id
}

function run_prover {
  sudo systemctl start nexus-prover.service
}

function view_service_output {
  sudo journalctl -u nexus-prover.service -f
}

function stop_and_delete_service {
  sudo systemctl stop nexus-prover.service
  sudo systemctl disable nexus-prover.service
  sudo rm /etc/systemd/system/nexus-prover.service
  sudo systemctl daemon-reload
  sudo systemctl reset-failed
}

# 創建 systemd 服務單元文件
function create_service {
  sudo bash -c 'cat <<EOF > /etc/systemd/system/nexus-prover.service
[Unit]
Description=Nexus Prover Service
After=network.target

[Service]
Type=simple
User='$USER'
WorkingDirectory='$NEXUS_HOME'/network-api/clients/cli/target/release
ExecStart='$NEXUS_HOME'/network-api/clients/cli/target/release/prover -- beta.orchestrator.nexus.xyz
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF'
  sudo systemctl daemon-reload
  sudo systemctl enable nexus-prover.service
}

# 顯示選單
while true; do
  echo "選單："
  echo "1. 設置環境"
  echo "2. 創建並啟動 Nexus Prover 服務"
  echo "3. 查看 Prover Id"
  echo "4. 查看 Nexus Prover 服務輸出"
  echo "5. 停止並刪除 Nexus Prover 服務"
  echo "6. 離開"
  read -p "請選擇一個選項: " choice

  case $choice in
    1)
      setup_environment
      ;;
    2)
      create_service
      run_prover
      ;;
    3)
      view_prover_id
      ;;
    4)
      view_service_output
      ;;
    5)
      stop_and_delete_service
      ;;
    6)
      echo "退出選單。"
      break
      ;;
    *)
      echo "無效的選項，請重新選擇。"
      ;;
  esac
done
