# Clé SSH pour accéder aux instances
resource "aws_key_pair" "main" {
  key_name   = "${var.project}-${var.env}-key"
  public_key = file("~/.ssh/gitea-project.pub")

  tags = {
    Name = "${var.project}-${var.env}-key"
  }
}

# AMI Ubuntu 24.04 LTS (récupérée dynamiquement)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Bastion (subnet public)
resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_small
  subnet_id              = var.subnet_public_id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "${var.project}-${var.env}-bastion"
  }
}

# Traefik / reverse proxy (subnet public)
resource "aws_instance" "traefik" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_small
  subnet_id              = var.subnet_public_id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.traefik.id]

  tags = {
    Name = "${var.project}-${var.env}-traefik"
  }
}


# Swarm managers (subnet privé)
resource "aws_instance" "manager" {
  count                  = var.manager_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_manager
  subnet_id              = var.subnet_private_id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.swarm.id]

  tags = {
    Name = "${var.project}-${var.env}-manager-${count.index + 1}"
  }
}

# Swarm workers (subnet privé)
resource "aws_instance" "worker" {
  count                  = var.worker_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_worker
  subnet_id              = var.subnet_private_id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.swarm.id]

  tags = {
    Name = "${var.project}-${var.env}-worker-${count.index + 1}"
  }
}

# Monitoring (subnet privé)
resource "aws_instance" "monitoring" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_small
  subnet_id              = var.subnet_private_id
  key_name               = aws_key_pair.main.key_name
  vpc_security_group_ids = [aws_security_group.monitoring.id]

  tags = {
    Name = "${var.project}-${var.env}-monitoring"
  }
}
