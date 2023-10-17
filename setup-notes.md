#!/bin/bash

# run this after terraform apply is finish to enable kubectl (edit local kube config)
aws eks --region $(terraform output -raw region) update-kubeconfig \
    --name $(terraform output -raw cluster_name)

# kubectl apply this to install the EFS CSI driver to the cluster
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.3"