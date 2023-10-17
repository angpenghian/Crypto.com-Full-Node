output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = aws_eks_cluster.demo.name
}

output "efs_ip1" {
  description = "EFS1 IP"
  value       = aws_efs_mount_target.efs_mount_1.ip_address
}

output "efs_ip2" {
  description = "EFS2 IP"
  value       = aws_efs_mount_target.efs_mount_2.ip_address
}