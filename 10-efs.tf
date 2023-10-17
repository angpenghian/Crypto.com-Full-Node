resource "aws_efs_file_system" "demo_efs" {
    encrypted = true

    tags = {
        Name = var.environment
    }
}

resource "aws_efs_mount_target" "efs_mount_1" {
    file_system_id = aws_efs_file_system.demo_efs.id
    subnet_id      = aws_subnet.private-ap-southeast-1a.id
    security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "efs_mount_2" {
    file_system_id = aws_efs_file_system.demo_efs.id
    subnet_id      = aws_subnet.private-ap-southeast-1b.id
    security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name_prefix   = "efs-sg-"
  description   = "EFS Security Group"
  vpc_id        = aws_vpc.main.id
}

resource "aws_security_group_rule" "allow_nfs_from_eks" {
  type        = "ingress"
  from_port   = 2049
  to_port     = 2049
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.efs_sg.id
}
