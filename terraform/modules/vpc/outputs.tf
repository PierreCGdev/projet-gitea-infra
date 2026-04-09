output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_public_id" {
  description = "Public subnet ID"
  value       = aws_subnet.public.id
}

output "subnet_private_id" {
  description = "Private subnet A ID (eu-west-3a) — used for EC2, EFS"
  value       = aws_subnet.private.id
}

output "subnet_private_b_id" {
  description = "Private subnet B ID (eu-west-3b) — used for RDS subnet group"
  value       = aws_subnet.private_b.id
}
