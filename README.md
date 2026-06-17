# projet-gitea-infra

Infrastructure as Code pour déployer Gitea sur AWS. Terraform provisionne les ressources cloud (VPC, EC2, RDS, EFS, S3), Ansible configure les machines et déploie les services.

## Prérequis

- AWS CLI configuré (`aws configure`)
- Terraform >= 1.5
- WSL + Ansible
- Clé SSH `~/.ssh/gitea-project` présente en local et importée dans AWS

## Environnements

`terraform/envs/prod` et `terraform/envs/staging` — même modules, sizing différent (3 managers t3.small en prod, 1 t3.micro en staging).

## Déployer

**1. Terraform**

```bash
cd terraform/envs/prod
cp example.tfvars local.tfvars  # remplir admin_ip et db_password
terraform init
terraform apply -var-file="local.tfvars"
```

L'apply génère automatiquement `ansible/inventory/prod/hosts.ini` avec les IPs des EC2.

**2. Ansible**

**Mac / Linux**

```bash
cd ansible
ansible-playbook playbooks/site.yml \
  -i inventory/prod/hosts.ini \
  --ask-vault-pass
```

**Windows (WSL)**

```bash
cd ansible
ANSIBLE_ROLES_PATH=./roles ansible-playbook playbooks/site.yml \
  -i inventory/prod/hosts.ini \
  --ask-vault-pass
```

> Depuis WSL, le dossier `/mnt/` est considéré world-writable par Ansible, ce qui fait ignorer `ansible.cfg`. Le préfixe `ANSIBLE_ROLES_PATH=./roles` compense ce comportement.

## Secrets

Mot de passe RDS et token DuckDNS chiffrés dans `ansible/inventory/<env>/group_vars/all/vault.yml`.

```bash
EDITOR=nano ansible-vault edit inventory/prod/group_vars/all/vault.yml --ask-vault-pass
```

`local.tfvars` est gitignored — ne jamais le committer.

## Après chaque terraform apply

Les IPs changent à chaque apply (pas d'IP fixe). Deux choses à faire :

- Mettre à jour `BASTION_IP` et `MANAGER_IP` dans les secrets GitHub Actions du repo `gitea-coderepublic`
- DuckDNS (`gitea-coderepublic.duckdns.org`) se met à jour automatiquement au prochain `ansible-playbook`

## Domaines

| Environnement | URL |
|---|---|
| Prod | https://gitea-coderepublic.duckdns.org |
| Staging | https://staging-gitea-coderepublic.duckdns.org |

## Accès aux services

Grafana et Prometheus sont dans le subnet privé, accessibles uniquement via tunnel SSH :

```bash
ssh -i ~/.ssh/gitea-project \
  -L 3000:<monitoring_ip>:3000 \
  -L 9090:<monitoring_ip>:9090 \
  -o ProxyCommand="ssh -i ~/.ssh/gitea-project -W %h:%p ubuntu@<bastion_ip>" \
  ubuntu@<monitoring_ip>
```

Puis `http://localhost:3000` (Grafana) et `http://localhost:9090` (Prometheus).
