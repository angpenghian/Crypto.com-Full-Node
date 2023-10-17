#!/bin/bash

# Set the hostname
sudo hostnamectl set-hostname crypto-mainnet

# Update the installed packages and package cache on your instance.
sudo yum update -y

# switch to home directory
sudo cd /home/ec2-user/

# Download and extract chain-main
sudo curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/v1.2.1/chain-main_1.2.1_Linux_x86_64.tar.gz
sudo tar -zxvf chain-main_1.2.1_Linux_x86_64.tar.gz

# Get the hostname of the machine
MONIKER=$(hostname)

# Initialize with the hostname as moniker using the specified data directory
sudo cd bin
sudo chain-maind init $MONIKER --chain-id crypto-org-chain-mainnet-1 --home /home/ec2-user/.chain-maind

# Fetch and verify genesis.json
GENESIS_PATH="/home/ec2-user/.chain-maind/config/genesis.json"
sudo curl https://raw.githubusercontent.com/crypto-org-chain/mainnet/main/crypto-org-chain-mainnet-1/genesis.json > $GENESIS_PATH
GENESIS_CHECKSUM=$(sha256sum $GENESIS_PATH | awk '{print $1}')
if [ "$GENESIS_CHECKSUM" == "d299dcfee6ae29ca280006eaa065799552b88b978e423f9ec3d8ab531873d882" ]; then
    echo "Genesis checksum is OK"
else
    echo "Genesis checksum MISMATCHED"
    exit 1
fi

# Edit the config.toml file
CONFIG_PATH="/home/ec2-user/.chain-maind/config/config.toml"

# Change laddr from "tcp://127.0.0.1:26657" to "tcp://0.0.0.0:26657"
sudo sed -i 's/laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/g' $CONFIG_PATH

# Change cors_allowed_origins from [] to ["*"]
sudo sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = ["*"]/g' $CONFIG_PATH

# Change unsafe from false to true
sudo sed -i 's/unsafe = false/unsafe = true/g' $CONFIG_PATH

# Edit the app.toml file
APP_CONFIG_PATH="/home/ec2-user/.chain-maind/config/app.toml"

# Change enable from false to true
sudo sed -i 's/enable = false/enable = true/g' $APP_CONFIG_PATH

# Change swagger from false to true
sudo sed -i 's/swagger = false/swagger = true/g' $APP_CONFIG_PATH

# Start the chain
cd /home/ec2-user/.chain-maind/bin/
sudo chain-maind start --home /home/ec2-user/.chain-maind