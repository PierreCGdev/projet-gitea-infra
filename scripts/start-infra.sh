#!/bin/bash
set -e

echo "=== Démarrage de l'infra Gitea ==="

echo "Démarrage des instances EC2..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=gitea-prod-*" \
            "Name=instance-state-name,Values=stopped" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "Aucune instance EC2 arrêtée trouvée."
else
  aws ec2 start-instances --instance-ids $INSTANCE_IDS
  echo "Instances démarrées : $INSTANCE_IDS"
fi

echo ""
echo "Démarrage RDS..."
aws rds start-db-instance --db-instance-identifier gitea-prod-db 2>/dev/null \
  && echo "RDS en cours de démarrage (~5 min)..." \
  || echo "RDS déjà en cours d'exécution ou inexistant."

echo ""
echo "Attente RDS disponible..."
aws rds wait db-instance-available --db-instance-identifier gitea-prod-db
echo "RDS disponible."

echo ""
echo "=== Infra démarrée. ==="
echo ""
echo "IP du bastion (peut avoir changé) :"
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=gitea-prod-bastion" \
            "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].PublicIpAddress" \
  --output text

echo ""
echo "⚠️  Si l'IP du bastion a changé, mets à jour admin_ip dans local.tfvars."
