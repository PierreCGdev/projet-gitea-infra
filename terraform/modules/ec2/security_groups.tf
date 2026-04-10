# SG Bastion — SSH depuis ton IP uniquement
resource "aws_security_group" "bastion" {
  name        = "${var.project}-${var.env}-sg-bastion"
  description = "SSH access to bastion from admin IP only"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-sg-bastion"
  }
}

# SG Traefik — HTTP/HTTPS depuis internet + SSH depuis bastion
resource "aws_security_group" "traefik" {
  name        = "${var.project}-${var.env}-sg-traefik"
  description = "HTTP/HTTPS from internet, SSH from bastion"
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH Gitea (TCP routing)"
    from_port   = 222
    to_port     = 222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-sg-traefik"
  }
}

# SG Swarm nodes — ports internes Swarm + SSH depuis bastion + trafic depuis Traefik
resource "aws_security_group" "swarm" {
  name        = "${var.project}-${var.env}-sg-swarm"
  description = "Swarm internal ports, SSH from bastion, traffic from Traefik"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "HTTP from Traefik"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description     = "HTTPS from Traefik"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description     = "Gitea HTTP from Traefik"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description     = "Gitea SSH from Traefik"
    from_port       = 222
    to_port         = 222
    protocol        = "tcp"
    security_groups = [aws_security_group.traefik.id]
  }

  ingress {
    description = "Swarm management"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Swarm node communication TCP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Swarm node communication UDP"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "Swarm overlay network"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-sg-swarm"
  }
}

# SG Monitoring — accès depuis bastion uniquement
resource "aws_security_group" "monitoring" {
  name        = "${var.project}-${var.env}-sg-monitoring"
  description = "Prometheus and Grafana access from bastion only"
  vpc_id      = var.vpc_id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "Grafana from bastion"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "Prometheus from bastion"
    from_port       = 9090
    to_port         = 9090
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  ingress {
    description     = "Scrape exporters from swarm nodes"
    from_port       = 9100
    to_port         = 9100
    protocol        = "tcp"
    security_groups = [aws_security_group.swarm.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-${var.env}-sg-monitoring"
  }
}
