# Crypto.org Blockchain Node Deployment

This repository contains the necessary configurations to deploy a Crypto.org blockchain node using Terraform, Docker, and Kubernetes on AWS.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Terraform Setup](#terraform-setup)
- [Docker Setup](#docker-setup)
- [Kubernetes Setup](#kubernetes-setup)
- [Deployment Steps](#deployment-steps)

## Prerequisites

Ensure you have the following prerequisites before proceeding:

- An AWS account with necessary permissions.
- Terraform installed on your local machine.
- Docker installed on your local machine.
- kubectl installed on your local machine.

## Terraform Setup

The provided Terraform configurations will set up the necessary AWS resources including a VPC, subnets, an EKS cluster, and associated networking and IAM resources.

Navigate to the directory containing the Terraform files and run the following commands:

```bash
terraform init
terraform apply
```

## Docker Setup
The provided Dockerfile sets up a containerized environment for running a Crypto.org blockchain node.

## Building the Docker Image
```bash
docker build -t crypto-org-node .
```

## Running the Docker Container
```bash
docker run -d \
  -v /path/to/efs-data:/efs-data \
  -p 26657:26657 \
  -p 1317:1317 \
  --name crypto-org-node \
  crypto-org-node
```

## Kubernetes Setup
The provided Kubernetes manifest contains the necessary resources for deploying a Crypto.org blockchain node within a Kubernetes cluster.

## Deployment
```bash
kubectl apply -f crypto-deployment.yaml
```

## Deployment Steps
Deploy the AWS infrastructure using Terraform. <br/>
Build the Docker image for the blockchain node. <br/>
After the Terraform deployment is complete, run the following commands to update your local kubeconfig file and install the EFS CSI driver to the cluster:
```bash
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)
```

```bash
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.3"
```

Deploy the Kubernetes resources using the provided manifest.
Once the deployment is running, retrieve the external IP address of your service using the following command:
```bash
kubectl get svc crypto-node-service
```

You can now use the external IP address to connect to your blockchain node using the Tendermint and Cosmos RPC ports.

Tendermint RPC port:
```bash
curl http://<external-ip>:26657/status
```

Cosmos RPC port:
```bash
curl http://<external-ip>:1317/node_info
```