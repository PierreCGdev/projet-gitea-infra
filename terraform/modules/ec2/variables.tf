variable "project" {
  description = "Project name, used for tagging"
  type        = string
}

variable "env" {
  description = "Environment name (prod, staging)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_public_id" {
  description = "Public subnet ID"
  type        = string
}

variable "subnet_private_id" {
  description = "Private subnet ID"
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
  description = "Your public IP for SSH access to bastion (x.x.x.x/32)"
  type        = string
}
