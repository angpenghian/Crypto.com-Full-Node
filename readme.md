# Blockchain DevOps Challenge - Crypto.org Blockchain Installation using Terraform

This repository contains the Terraform configurations for setting up and hosting a Crypto.org blockchain installation on AWS, with the primary objective of setting up an observer node to access the mainnet and exposing the necessary API endpoints.

## Table of Contents

- [Objective](#objective)
- [Requirements](#requirements)
- [Deliverables](#deliverables)
- [Queries](#queries)
- [Design Choices](#design-choices)
- [Getting Started](#getting-started)
- [Resources](#resources)

## Objective

The primary goal is to host an installation of Crypto.org blockchain, implement a simple Infrastructure as Code (IAC) using Terraform to host the installation, set up an observer node for the network, and expose both Tendermint and Cosmos RPC for applications in the same network.

## Requirements

- Setup an observer node for the network, accessing the mainnet
- Expose both Tendermint rpc and Cosmos rpc for applications in the same network (1317/26657)
- Ensure deployment is reproducible with appropriate automation tools
- Ensure blockchain data is persistent across upgrades and can be backed up
- Do not use the one-click deployment offered by crypto.com
- Ensure the node is `synced` and you are able to query the latest data

## Deliverables

- Terraform Configurations: `terraform/`
    - Main Configuration: `main.tf`
    - Variable Definitions: `variables.tf`
    - Output Definitions: `outputs.tf`

## Queries

- Balance of address `cro1hsr2z6lr7k2szjktzjst46rr9cfavprqas20gc`
- Query to retrieve balance information
- Block hash for `13947398` and query to retrieve the information

## Design Choices

Discuss the design choices made during the implementation, any trade-offs, and the rationale behind the decisions.

## Getting Started

Provide instructions on how to setup and run the installation using the provided Terraform configurations.

1. Install [Terraform](https://www.terraform.io/downloads.html) and [AWS CLI](https://aws.amazon.com/cli/).
2. Configure your AWS credentials using the command `aws configure`.
3. Navigate to the `terraform/` directory.
4. Update the `variables.tf` file with your specific values.
5. Initialize the Terraform configuration using the command `terraform init`.
6. Apply the Terraform configuration using the command `terraform apply`.

## Resources

- [Crypto.org Chain Getting Started](link-to-documentation)
- [Chain GitHub Repository](link-to-repository)




## Docker Setup

### Overview

The provided Dockerfile sets up a containerized environment for running a Crypto.org blockchain node. It utilizes Amazon Linux 2 as the base image, and performs the following operations:

- Installs necessary dependencies like curl, sudo, tar, and hostname.
- Sets a working directory (`/app`).
- Downloads and extracts the `chain-main` binary from the specified release.
- Copies a script `update-configs.sh` for updating node configurations into the container.
- Exposes ports 26657 and 1317 for Tendermint and Cosmos RPC respectively.
- Sets the entrypoint to run the node using the `update-configs.sh` script and the `chain-maind` binary.

### Building the Docker Image

To build the Docker image, navigate to the directory containing the Dockerfile and run the following command:

This command builds a Docker image with the tag crypto-org-node.
```bash
docker build -t crypto-org-node .
```

Running the Docker Container
To run a container from the image, use the following command:

```bash
docker run -d \
  -v /path/to/efs-data:/efs-data \
  -p 26657:26657 \
  -p 1317:1317 \
  --name crypto-org-node \
  crypto-org-node
```

Make sure to replace `/path/to/efs-data` with the actual path to your EFS data directory. The instructions are clear and straightforward, allowing others to understand how to use your Docker setup to run a Crypto.org blockchain node.


## Kubernetes Setup

### Overview

The provided Kubernetes manifest contains the necessary resources for deploying a Crypto.org blockchain node within a Kubernetes cluster. It defines a StorageClass, PersistentVolume, and PersistentVolumeClaim for EFS storage, a Deployment for the blockchain node, and a LoadBalancer Service for exposing the RPC ports.

### Components

- **StorageClass (efs-sc)**: Defines the provisioner for AWS EFS.
- **PersistentVolume (crypto-node-pv-volume)**: Specifies a persistent volume with a size of 50Gi, using the `efs-sc` StorageClass.
- **PersistentVolumeClaim (crypto-node-pvc)**: Claims the defined persistent volume for use.
- **Deployment (crypto-node-deployment)**: Defines a deployment with a single replica of the blockchain node, using a custom Docker image.
- **Service (crypto-node-service)**: A LoadBalancer service for exposing the Tendermint and Cosmos RPC ports to the internet.

### Deployment

1. Ensure you have a Kubernetes cluster up and running, and your kubectl is configured to interact with it.
2. Navigate to the directory containing the Kubernetes manifest.
3. Apply the manifest to your cluster using the following command:

```bash
kubectl apply -f crypto-deployment.yaml
```