aws_region = "eu-west-3"
project    = "gitea"
env        = "staging"

# Swarm cluster — moins de nodes, instances plus petites qu'en prod
manager_count         = 1
worker_count          = 1
instance_type_manager = "t3.micro"
instance_type_worker  = "t3.micro"
instance_type_small   = "t3.micro"  # bastion, Traefik, monitoring

admin_ip = "x.x.x.x/32"  # à remplacer par ton IP — curl ifconfig.me

# db_password = "à définir dans local.tfvars (non commité)"
db_password = "password_to_define"
