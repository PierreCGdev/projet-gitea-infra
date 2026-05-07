terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source  = "../../modules/vpc"
  project = var.project
  env     = var.env
}

module "ec2" {
  source  = "../../modules/ec2"
  project = var.project
  env     = var.env

  vpc_id            = module.vpc.vpc_id
  subnet_public_id  = module.vpc.subnet_public_id
  subnet_private_id = module.vpc.subnet_private_id

  manager_count         = var.manager_count
  worker_count          = var.worker_count
  instance_type_manager = var.instance_type_manager
  instance_type_worker  = var.instance_type_worker
  instance_type_small   = var.instance_type_small

  admin_ip = var.admin_ip
}

module "rds" {
  source  = "../../modules/rds"
  project = var.project
  env     = var.env

  vpc_id              = module.vpc.vpc_id
  subnet_private_id   = module.vpc.subnet_private_id
  subnet_private_b_id = module.vpc.subnet_private_b_id
  sg_swarm_id         = module.ec2.sg_swarm_id

  db_password = var.db_password
}

module "efs" {
  source  = "../../modules/efs"
  project = var.project
  env     = var.env

  vpc_id            = module.vpc.vpc_id
  subnet_private_id = module.vpc.subnet_private_id
  sg_swarm_id       = module.ec2.sg_swarm_id
}
