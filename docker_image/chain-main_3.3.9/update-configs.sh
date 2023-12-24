#!/bin/bash

# Initialize the node
MONIKER=$(hostname)
/app/bin/chain-maind init $MONIKER --chain-id crypto-org-chain-mainnet-1 --home /efs-data/.chain-maind

# Fetch and verify genesis.json
GENESIS_PATH="/efs-data/.chain-maind/config/genesis.json"
curl https://raw.githubusercontent.com/crypto-org-chain/mainnet/main/crypto-org-chain-mainnet-1/genesis.json > $GENESIS_PATH
GENESIS_CHECKSUM=$(sha256sum $GENESIS_PATH | awk '{print $1}')
if [ "$GENESIS_CHECKSUM" != "d299dcfee6ae29ca280006eaa065799552b88b978e423f9ec3d8ab531873d882" ]; then
    echo "Genesis checksum mismatch!"
    exit 1
fi

# Update configurations
CONFIG_PATH="/efs-data/.chain-maind/config/config.toml"
sed -i 's/laddr = "tcp:\/\/127.0.0.1:26657"/laddr = "tcp:\/\/0.0.0.0:26657"/g' $CONFIG_PATH
sed -i 's/cors_allowed_origins = \[\]/cors_allowed_origins = ["*"]/g' $CONFIG_PATH
sed -i 's/db_dir = "data"/db_dir = "\/efs-data"/g' $CONFIG_PATH
sed -i 's/unsafe = false/unsafe = true/g' $CONFIG_PATH
sed -i 's/fast_sync = true/fast_sync = false/g' $CONFIG_PATH
sed -i.bak -E 's#^(seeds[[:space:]]+=[[:space:]]+).*$#\1"87c3adb7d8f649c51eebe0d3335d8f9e28c362f2@seed-0.crypto.org:26656,e1d7ff02b78044795371beb1cd5fb803f9389256@seed-1.crypto.org:26656,2c55809558a4e491e9995962e10c026eb9014655@seed-2.crypto.org:26656"#' $CONFIG_PATH
sed -i.bak -E 's#^(create_empty_blocks_interval[[:space:]]+=[[:space:]]+).*$#\1"5s"#' $CONFIG_PATH
sed -i.bak -E 's#^(timeout_commit[[:space:]]+=[[:space:]]+).*$#\1"5s"#' $CONFIG_PATH

APP_CONFIG_PATH="/efs-data/.chain-maind/config/app.toml"
sed -i 's/enable = false/enable = true/g' $APP_CONFIG_PATH
sed -i 's/swagger = false/swagger = true/g' $APP_CONFIG_PATH
sed -i 's/pruning = "everything"/pruning = "nothing"/g' $APP_CONFIG_PATH
sed -i.bak -E 's#^(minimum-gas-prices[[:space:]]+=[[:space:]]+)""$#\1"0.025basecro"#' $APP_CONFIG_PATH

# Execute the passed in command
exec "$@"