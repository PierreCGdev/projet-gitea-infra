output "efs_dns_name" {
  description = "EFS DNS name (used to mount on Swarm nodes)"
  value       = aws_efs_file_system.main.dns_name
}

output "efs_id" {
  description = "EFS file system ID"
  value       = aws_efs_file_system.main.id
}
