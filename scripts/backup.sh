#!/bin/bash
# Backup script for Pi 5 rack management stack
set -e

BACKUP_DIR="./backups"
RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-30}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="rack-backup-${TIMESTAMP}.tar.gz"

echo "Starting backup at $(date)"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Stop docker compose to ensure consistency
echo "Stopping services..."
docker compose -f docker-compose.prod.yml stop

# Create tarball of all data
echo "Creating backup archive..."
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" \
  ./data \
  ./letsencrypt \
  ./prometheus.yml \
  ./.env \
  2>/dev/null || true

# Restart services
echo "Restarting services..."
docker compose -f docker-compose.prod.yml up -d

# Clean old backups
echo "Cleaning old backups (keeping last ${RETENTION_DAYS} days)..."
find "$BACKUP_DIR" -name "rack-backup-*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "Backup complete: ${BACKUP_NAME}"
echo "Backup size: $(du -h ${BACKUP_DIR}/${BACKUP_NAME} | cut -f1)"
