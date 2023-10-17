# Use Amazon Linux 2 as the base image
FROM amazonlinux:2

# Install necessary dependencies and update
RUN yum update -y && \
    yum install -y curl sudo tar hostname

# Set working directory
WORKDIR /app

# Download and extract chain-main
RUN curl -LOJ https://github.com/crypto-org-chain/chain-main/releases/download/v1.2.1/chain-main_1.2.1_Linux_x86_64.tar.gz && \
    tar -zxvf chain-main_1.2.1_Linux_x86_64.tar.gz

# Copy configuration update script to container
COPY update-configs.sh /app/update-configs.sh
RUN chmod +x /app/update-configs.sh

# Expose necessary ports (Tendermint and Cosmos RPC)
EXPOSE 26657 1317

# Set the entrypoint to run your node
CMD ["/app/update-configs.sh", "/app/bin/chain-maind", "start", "--home", "/efs-data/.chain-maind"]