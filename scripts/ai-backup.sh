#!/bin/bash
set -e

BACKUP_DIR="./backups"
RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-30}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="ai-rack-backup-${TIMESTAMP}.tar.gz"

mkdir -p "$BACKUP_DIR"

echo "Creating AI backup at $(date)"

tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" \
  ./data \
  ./.env \
  ./docker-compose.ai.yml \
  ./README-ai.md \
  2>/dev/null || true

find "$BACKUP_DIR" -name "ai-rack-backup-*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "Backup complete: ${BACKUP_DIR}/${BACKUP_NAME}"
