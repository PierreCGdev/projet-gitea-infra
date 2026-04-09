#!/bin/bash
set -e

echo "=== Arrêt de l'infra Gitea ==="

echo "Arrêt des instances EC2..."
INSTANCE_IDS=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=gitea-prod-*" \
            "Name=instance-state-name,Values=running" \
  --query "Reservations[].Instances[].InstanceId" \
  --output text)

if [ -z "$INSTANCE_IDS" ]; then
  echo "Aucune instance EC2 en cours d'exécution."
else
  aws ec2 stop-instances --instance-ids $INSTANCE_IDS
  echo "Instances stoppées : $INSTANCE_IDS"
fi

echo ""
echo "Arrêt RDS..."
aws rds stop-db-instance --db-instance-identifier gitea-prod-db 2>/dev/null \
  && echo "RDS stoppé." \
  || echo "RDS déjà arrêté ou inexistant."

echo ""
echo "=== Infra stoppée. ==="
echo "⚠️  Pense à re-stopper RDS dans 7 jours si tu ne travailles pas :"
echo "    aws rds stop-db-instance --db-instance-identifier gitea-prod-db"
