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
  description = "Private subnet ID"
  type        = string
}

variable "sg_swarm_id" {
  description = "Swarm security group ID (allowed to mount EFS)"
  type        = string
}
