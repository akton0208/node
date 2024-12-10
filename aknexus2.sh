#!/bin/bash

# Update package list
apt update

# Install necessary packages if not already installed
packages=("build-essential" "pkg-config" "libssl-dev" "git" "cargo" "curl" "screen" "unzip")
for package in "${packages[@]}"; do
    if ! dpkg -l | grep -q "^ii  $package"; then
        apt install -y $package
    fi
done

# Download and unzip protoc if not already downloaded
if [ ! -f "$HOME/.local/bin/protoc" ]; then
    wget https://github.com/protocolbuffers/protobuf/releases/download/v21.9/protoc-21.9-linux-x86_64.zip
    unzip protoc-21.9-linux-x86_64.zip -d $HOME/.local
fi

# Set environment variables
export PATH="$HOME/.local/bin:$PATH"

# Install rustup if not already installed
if [ ! -f "$HOME/.cargo/bin/rustup" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Load cargo environment variables
source $HOME/.cargo/env
export PATH="$HOME/.cargo/bin:$PATH"

# Reload bash configuration
source ~/.bashrc

# Create .nexus directory (if it doesn't exist)
mkdir -p ~/.nexus

# Write PROVER_ID to file
echo "WG9GN3g5goVW3QCQMM16sV4eQq62" > ~/.nexus/prover-id

# Read CPU thread information
threads_per_core=$(lscpu | grep "^Thread(s) per core:" | awk '{print $4}')
cores=$(lscpu | grep "^Core(s) per socket:" | awk '{print $4}')
sockets=$(lscpu | grep "^Socket(s):" | awk '{print $2}')
total_threads=$((threads_per_core * cores * sockets))

# Calculate the number of programs to run, each using 4 threads
num_programs=$((total_threads / 4))

# Clone and compile the repository
REPO_PATH=$HOME/.nexus/network-api
if [ -d "$REPO_PATH" ]; then
  echo "$REPO_PATH exists. Updating."
  (cd $REPO_PATH && git stash save && git fetch --tags)
else
  mkdir -p $HOME/.nexus
  (cd $HOME/.nexus && git clone https://github.com/nexus-xyz/network-api)
fi
(cd $REPO_PATH && git -c advice.detachedHead=false checkout $(git rev-list --tags --max-count=1))
(cd $REPO_PATH/clients/cli && cargo build --release --bin prover)

# Use screen and taskset to run multiple curl commands
for i in $(seq 0 $((num_programs - 1))); do
    start_thread=$((i * 4))
    end_thread=$((start_thread + 3))
    screen -dmS n$i bash -c "taskset -c $start_thread-$end_thread curl https://cli.nexus.xyz/ | sh"
done

echo "All operations completed!"