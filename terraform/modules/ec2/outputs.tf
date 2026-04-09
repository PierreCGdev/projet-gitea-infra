output "bastion_public_ip" {
  description = "Bastion public IP (changes on stop/start)"
  value       = aws_instance.bastion.public_ip
}

output "traefik_public_ip" {
  description = "Traefik public IP (changes on stop/start)"
  value       = aws_instance.traefik.public_ip
}

output "manager_private_ips" {
  description = "Swarm manager private IPs"
  value       = aws_instance.manager[*].private_ip
}

output "worker_private_ips" {
  description = "Swarm worker private IPs"
  value       = aws_instance.worker[*].private_ip
}

output "monitoring_private_ip" {
  description = "Monitoring instance private IP"
  value       = aws_instance.monitoring.private_ip
}

output "sg_swarm_id" {
  description = "Swarm security group ID (used by RDS and EFS)"
  value       = aws_security_group.swarm.id
}
