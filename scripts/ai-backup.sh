#!/bin/bash
# AI Stack Backup Script
# Backs up all AI data: chats, files, configs, and metadata

set -e

BACKUP_DIR="./backups"
RETENTION_DAYS=${BACKUP_RETENTION_DAYS:-30}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="ai-backup-${TIMESTAMP}.tar.gz"

echo "[*] Starting AI backup at $(date)"
mkdir -p "$BACKUP_DIR"

# Check if compose is running
if ! docker compose -f docker-compose.ai.yml ps | grep -q "running"; then
  echo "[!] Warning: Some services may not be running"
fi

echo "[*] Creating backup archive..."
tar -czf "${BACKUP_DIR}/${BACKUP_NAME}" \
  ./data/open-webui \
  ./data/postgres-ai \
  ./data/minio \
  ./data/filebrowser \
  ./data/redis \
  ./.env \
  ./docker-compose.ai.yml \
  ./README-ai.md \
  2>/dev/null || true

echo "[*] Cleaning old backups (keeping last ${RETENTION_DAYS} days)..."
find "$BACKUP_DIR" -name "ai-backup-*.tar.gz" -mtime +${RETENTION_DAYS} -delete

echo "[+] Backup complete: ${BACKUP_DIR}/${BACKUP_NAME}"
echo "[+] Size: $(du -h ${BACKUP_DIR}/${BACKUP_NAME} | cut -f1)"
