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

variable "subnet_private_id" {
  description = "Private subnet A ID (eu-west-3a)"
  type        = string
}

variable "subnet_private_b_id" {
  description = "Private subnet B ID (eu-west-3b) — required for RDS subnet group (min 2 AZs)"
  type        = string
}

variable "sg_swarm_id" {
  description = "Swarm security group ID (allowed to connect to RDS)"
  type        = string
}

variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
  sensitive   = true
}
