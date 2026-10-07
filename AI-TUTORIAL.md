# Pi 5 AI Stack - Complete Setup Tutorial

This guide walks you through setting up a complete local AI environment on your Raspberry Pi 5 with chat backup, file storage, and optional remote access via Tailscale.

## Quick start commands you can copy/paste

```bash
# 1) Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER

# 2) Log out and back in, then clone the repo
cd ~
git clone https://github.com/camdenbecker11-sudo/pi5-rack-management.git
cd pi5-rack-management

# 3) Copy the example environment file
cp .env.ai.example .env

# 4) Edit the environment file
nano .env

# 5) Create data folders
mkdir -p data/{postgres-ai,redis,minio,open-webui,filebrowser,ollama,tailscale}
chmod -R 777 data/

# 6) Start the stack
docker compose -f docker-compose.ai.yml up -d

# 7) Check status
docker compose -f docker-compose.ai.yml ps

# 8) View logs if needed
docker compose -f docker-compose.ai.yml logs -f
```

## Prerequisites

- Raspberry Pi 5 (4GB+ RAM recommended, 8GB+ better)
- SSD or microSD card (64GB+ for model storage)
- Active internet connection
- Basic familiarity with terminal/command line
- Docker and Docker Compose installed

## Step 0: Install Docker (if not done)

If Docker isn't installed on your Pi yet:

```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
```

Log out and back in for the group change to take effect.

Verify installation:

```bash
docker --version
docker compose version
```

## Step 1: Clone the Repository

```bash
cd ~
git clone https://github.com/camdenbecker11-sudo/pi5-rack-management.git
cd pi5-rack-management
```

## Step 2: Create Your Environment File

Copy the example environment file:

```bash
cp .env.ai.example .env
```

Edit it with your preferred editor:

```bash
nano .env
```

### Key values to change:

```env
# PostgreSQL - change the password
POSTGRES_PASSWORD=your-secure-password-here

# MinIO object storage - change the password
MINIO_ROOT_PASSWORD=your-secure-password-here

# Open WebUI - change the secret key
OPEN_WEBUI_SECRET_KEY=your-secure-key-here

# Tailscale (optional) - get from https://login.tailscale.com/admin/settings/tokens
TAILSCALE_AUTHKEY=tskey-xxxxxxxxxxxxx
```

**Tips for strong passwords:**

```bash
openssl rand -base64 32
```

## Step 3: Create Data Directories

The stack will create these automatically, but you can pre-create them:

```bash
mkdir -p data/{postgres-ai,redis,minio,open-webui,filebrowser,ollama,tailscale}
chmod -R 777 data/
```

## Step 4: Start the AI Stack

Launch all services:

```bash
docker compose -f docker-compose.ai.yml up -d
```

Watch the startup process:

```bash
docker compose -f docker-compose.ai.yml logs -f
```

Wait for all services to be healthy (30-60 seconds).

## Step 5: Verify Services Are Running

```bash
docker compose -f docker-compose.ai.yml ps
```

You should see:

- ai-postgres (healthy)
- ai-redis (healthy)
- ai-minio (healthy)
- ai-ollama (healthy)
- ai-open-webui (healthy)
- ai-filebrowser (running)
- ai-tailscale (running, if enabled)

## Step 6: Access the Services Locally

Find your Pi's IP address:

```bash
hostname -I
```

Example output: `192.168.1.100`

Access each service in your browser:

| Service | URL | Default Login |
|---------|-----|----------------|
| Open WebUI (Chat) | http://192.168.1.100:3000 | Create on first login |
| FileBrowser (Files) | http://192.168.1.100:8081 | admin / admin |
| MinIO Console | http://192.168.1.100:9001 | minioadmin / your-password |
| Ollama API | http://192.168.1.100:11434 | (API only) |
| PostgreSQL | localhost:5432 | aiuser / your-password |
| Redis | localhost:6379 | (No auth by default) |

## Step 7: Download Your First AI Model

Ollama comes with no models by default. Download one:

```bash
# Pull a small model (good for Pi 5)
docker exec ai-ollama ollama pull mistral

# Or try a smaller one
docker exec ai-ollama ollama pull neural-chat

# Or the smallest (for limited RAM)
docker exec ai-ollama ollama pull orca-mini
```

Available models: https://ollama.ai/library

**Model sizes (approximate):**
- orca-mini: 1.3GB
- neural-chat: 2.3GB
- mistral: 3.5GB
- llama2: 3.8GB

## Step 8: Use Open WebUI

1. Open http://192.168.1.100:3000 in your browser
2. Create an account (first user becomes admin)
3. Go to Settings → Models
4. Select your downloaded model
5. Start chatting!

## Step 9: Upload Files to FileBrowser

1. Open http://192.168.1.100:8081
2. Login: admin / admin
3. Upload files, PDFs, screenshots, notes
4. Create folders for organization

This is your AI memory vault where old files live for later retrieval.

## Step 10: Configure MinIO (Optional)

MinIO is S3-compatible object storage for larger files:

1. Open http://192.168.1.100:9001
2. Login: minioadmin / your-password from .env
3. Create a bucket called `ai-storage`
4. Upload documents, images, media

## Step 11: Set Up Tailscale for Remote Access (Optional)

If you want secure remote access without a domain:

### Get Tailscale authkey:

1. Go to https://login.tailscale.com/admin/settings/tokens
2. Create a new auth key
3. Copy it

### Update .env:

```env
TAILSCALE_AUTHKEY=tskey-xxxxxxxxxxxxx
TAILSCALE_HOSTNAME=pi5-ai-rack
```

### Restart Tailscale:

```bash
docker compose -f docker-compose.ai.yml restart tailscale
```

### Access from anywhere:

- Install Tailscale on your phone/laptop
- Access via: http://pi5-ai-rack:3000 (or the IP Tailscale assigns)

## Step 12: Set Up Automated Backups

Schedule daily backups of your AI data:

```bash
chmod +x scripts/ai-backup.sh

# Test the backup
./scripts/ai-backup.sh

# Schedule for 2 AM daily
(crontab -l 2>/dev/null; echo "0 2 * * * cd /path/to/pi5-rack-management && ./scripts/ai-backup.sh >> logs/backup.log 2>&1") | crontab -
```

Verify the cron job:

```bash
crontab -l
```

## Your AI Workflow

### Daily use:

1. Chat: Open WebUI for conversations with your local AI
2. Store: Save PDFs, notes, screenshots to FileBrowser
3. Retrieve: Ask the AI to search or recall older files/chats
4. Back up: Automated nightly backup of all data

### Access patterns:

- Local (home): http://pi-ip:3000
- Remote: Tailscale IP or device name
- FileBrowser: Same pattern, port 8081
- MinIO: Same pattern, port 9001

## Useful Commands

### View logs:

```bash
docker compose -f docker-compose.ai.yml logs -f open-webui
docker compose -f docker-compose.ai.yml logs -f ollama
```

### Restart a service:

```bash
docker compose -f docker-compose.ai.yml restart open-webui
```

### Stop everything:

```bash
docker compose -f docker-compose.ai.yml down
```

### Restart everything:

```bash
docker compose -f docker-compose.ai.yml up -d
```

### Check resource usage:

```bash
docker stats
```

### Update all images:

```bash
docker compose -f docker-compose.ai.yml pull
docker compose -f docker-compose.ai.yml up -d
```

### Remove a bad model or clean cache:

```bash
docker exec ai-ollama ollama rm mistral
rm -rf ./data/ollama
```

## Troubleshooting

### Port already in use:

If a port is already taken, edit `docker-compose.ai.yml`:

```yaml
ports:
  - "3001:8080"  # Change 3000 to 3001
```

### Out of storage:

Check disk usage:

```bash
du -sh data/*
df -h
```

Delete old backups if needed:

```bash
rm -rf backups/ai-backup-*.tar.gz
```

### High CPU/memory:

Check what's using resources:

```bash
docker stats
```

Ollama uses a lot of memory when models are loaded. If you run out of RAM, consider using a smaller model.

### Can't access from remote:

```bash
docker compose -f docker-compose.ai.yml logs tailscale
```

Then:

```bash
docker compose -f docker-compose.ai.yml restart tailscale
```

### Models won't download:

Check internet connection and disk space:

```bash
df -h
ping 8.8.8.8
```

## Next Steps

Once everything is running smoothly:

1. Add more models for different tasks
2. Create a RAG pipeline by embedding old documents into pgvector
3. Set up alerts for service failures
4. Add integrations to other tools
5. Export chats and save important conversations for archival

## Additional Resources

- Open WebUI docs: https://docs.openwebui.com
- Ollama docs: https://ollama.ai
- MinIO docs: https://min.io/docs
- FileBrowser docs: https://filebrowser.org
- Tailscale docs: https://tailscale.com/kb

## Support

If something breaks:

```bash
docker compose -f docker-compose.ai.yml logs
docker compose -f docker-compose.ai.yml restart
docker compose -f docker-compose.ai.yml down -v
```

Then start fresh:

```bash
docker compose -f docker-compose.ai.yml up -d
```

---

You now have a fully functional local AI environment with chat backup, file storage, and optional remote access via Tailscale.
