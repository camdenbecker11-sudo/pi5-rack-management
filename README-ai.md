# Pi 5 Rack Management Stack

A self-hosted rack and homelab control center for a Raspberry Pi 5.

This repository starts with a general rack/ops stack, and now includes an AI-focused mode optimized for:
- local AI chat and model hosting
- chat backup and history retention
- storage for old files, PDFs, notes, screenshots, and images
- file access for AI retrieval and future context use
- local object storage with S3-compatible interfaces

## AI-focused stack

The new AI stack includes:
- Open WebUI for chat UI and local AI interactions
- Ollama for running local LLMs
- PostgreSQL with pgvector support for vector storage and metadata
- Redis for caching and session handling
- MinIO for object storage (S3-compatible)
- FileBrowser for file upload and browsing
- backup automation for AI files and chat data

This is designed for a Pi 5 with local privacy-first AI workflows, especially when you want a system that can keep old files and chats available for later retrieval.

## Quick start

```bash
cp .env.ai.example .env
nano .env
docker compose -f docker-compose.ai.yml up -d
```

Then open:
- Open WebUI: http://<PI_IP>:3000
- FileBrowser: http://<PI_IP>:8081
- MinIO Console: http://<PI_IP>:9001
- MinIO API: http://<PI_IP>:9000
- PostgreSQL: localhost:5432
- Redis: localhost:6379
- Ollama: http://<PI_IP>:11434

## AI storage design

This stack is meant for a workflow like:
- store chats and context
- attach important files and images
- keep historical documents for future retrieval
- let a local AI assistant pull from older files when needed
- retain raw local copies with object storage and file browser access

## Backup strategy

Use the included backup script:

```bash
chmod +x scripts/ai-backup.sh
./scripts/ai-backup.sh
```

This script exports:
- Open WebUI data
- MinIO data
- PostgreSQL data
- uploaded files
- configuration

## Security notes

This stack is optimized for local/home network use. If you want remote access without a domain, use Tailscale for secure private access.

## Additional resources

- AI stack guide: `README-ai.md`
- AI environment template: `.env.ai.example`
- AI backup script: `scripts/ai-backup.sh`

