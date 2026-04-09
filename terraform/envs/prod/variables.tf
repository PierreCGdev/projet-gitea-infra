variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "project" {
  description = "Project name, used for tagging"
  type        = string
}

variable "env" {
  description = "Environment name (prod, staging)"
  type        = string
}

variable "manager_count" {
  description = "Number of Swarm manager nodes"
  type        = number
}

variable "worker_count" {
  description = "Number of Swarm worker nodes"
  type        = number
}

variable "instance_type_manager" {
  description = "EC2 instance type for Swarm managers"
  type        = string
}

variable "instance_type_worker" {
  description = "EC2 instance type for Swarm workers"
  type        = string
}

variable "instance_type_small" {
  description = "EC2 instance type for bastion, Traefik, monitoring"
  type        = string
}

variable "admin_ip" {
  description = "Admin public IP for SSH access to bastion (x.x.x.x/32)"
  type        = string
}

variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
  sensitive   = true
}