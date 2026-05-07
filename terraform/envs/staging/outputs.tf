output "bastion_public_ip" {
  description = "Bastion public IP — à mettre dans l'inventaire Ansible"
  value       = module.ec2.bastion_public_ip
}

output "traefik_public_ip" {
  description = "Traefik public IP — à mettre à jour dans le DNS avant présentation"
  value       = module.ec2.traefik_public_ip
}

output "manager_private_ips" {
  description = "IPs privées des Swarm managers"
  value       = module.ec2.manager_private_ips
}

output "worker_private_ips" {
  description = "IPs privées des Swarm workers"
  value       = module.ec2.worker_private_ips
}

output "monitoring_private_ip" {
  description = "IP privée du serveur monitoring"
  value       = module.ec2.monitoring_private_ip
}

output "efs_dns_name" {
  description = "EFS DNS name — utilisé par Ansible pour monter l'EFS sur les nodes Swarm"
  value       = module.efs.efs_dns_name
}
