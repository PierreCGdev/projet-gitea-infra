# Security group EFS — port 2049 (NFS) depuis les nodes Swarm uniquement
resource "aws_security_group" "efs" {
  name        = "${var.project}-${var.env}-sg-efs"
  description = "NFS access from Swarm nodes only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "NFS from Swarm"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [var.sg_swarm_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-sg-efs"
  }
}

# Système de fichiers EFS
resource "aws_efs_file_system" "main" {
  encrypted = true

  tags = {
    Name = "${var.project}-${var.env}-efs"
  }
}

# Mount target — point de montage dans le subnet privé
resource "aws_efs_mount_target" "main" {
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = var.subnet_private_id
  security_groups = [aws_security_group.efs.id]
}
