# Security group RDS — port 5432 depuis les nodes Swarm uniquement
resource "aws_security_group" "rds" {
  name        = "${var.project}-${var.env}-sg-rds"
  description = "PostgreSQL access from Swarm nodes only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "PostgreSQL from Swarm"
    from_port       = 5432
    to_port         = 5432
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
    Name = "${var.project}-${var.env}-sg-rds"
  }
}

# Subnet group RDS — 2 AZs minimum requis par AWS
resource "aws_db_subnet_group" "main" {
  name       = "${var.project}-${var.env}-db-subnet-group"
  subnet_ids = [var.subnet_private_id, var.subnet_private_b_id]

  tags = {
    Name = "${var.project}-${var.env}-db-subnet-group"
  }
}

# Instance RDS PostgreSQL
resource "aws_db_instance" "main" {
  identifier        = "${var.project}-${var.env}-db"
  engine            = "postgres"
  engine_version    = "16"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  db_name  = "gitea"
  username = "gitea"
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Single-AZ (pas de Multi-AZ pour réduire les coûts)
  multi_az = false

  # Pas de snapshot à la suppression (projet étudiant)
  skip_final_snapshot = true

  # Permet le stop/start manuel
  deletion_protection = false

  lifecycle {
    ignore_changes = [password]
  }

  tags = {
    Name = "${var.project}-${var.env}-db"
  }
}
