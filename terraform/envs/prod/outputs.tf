output "bastion_public_ip" {
  description = "Bastion public IP — à mettre dans l'inventaire Ansible"
  value       = module.ec2.bastion_public_ip
}

output "traefik_public_ip" {
  description = "Traefik EIP stable — enregistrement DNS"
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
