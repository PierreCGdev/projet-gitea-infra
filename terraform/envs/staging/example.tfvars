aws_region = "eu-west-3"
project    = "gitea"
env        = "staging"

# Swarm cluster — moins de nodes, instances plus petites qu'en prod
manager_count         = 1
worker_count          = 1
instance_type_manager = "t3.micro"
instance_type_worker  = "t3.micro"
instance_type_small   = "t3.micro"  # bastion, Traefik, monitoring

# db_password = "à définir dans terraform.tfvars (non commité)"
