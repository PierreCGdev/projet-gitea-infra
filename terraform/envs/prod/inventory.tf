# Génère automatiquement l'inventaire Ansible après terraform apply
resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../../../ansible/inventory/prod/hosts.ini"

  content = templatefile("${path.module}/hosts.ini.tpl", {
    bastion_ip    = module.ec2.bastion_public_ip
    traefik_ip    = module.ec2.traefik_public_ip
    manager_ips   = module.ec2.manager_private_ips
    worker_ips    = module.ec2.worker_private_ips
    monitoring_ip = module.ec2.monitoring_private_ip
  })
}

# Génère les variables Terraform utilisées par les rôles Ansible
resource "local_file" "ansible_terraform_vars" {
  filename = "${path.module}/../../../ansible/inventory/prod/group_vars/terraform.yml"

  content = templatefile("${path.module}/terraform_vars.yml.tpl", {
    efs_dns_name = module.efs.efs_dns_name
  })
}
