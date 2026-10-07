# Windows 11 Access Guide for Pi 5 AI Stack

This guide shows you how to access your Pi 5 AI stack from a Windows 11 PC without exposing it to the public internet.

The recommended method is Tailscale, which gives you a secure private network between your PC and the Pi.

## Goal

From your Windows 11 PC, you want to be able to:
- open Open WebUI in the browser
- open FileBrowser for file access
- open MinIO for object storage
- access the Pi over a secure private connection
- run Ollama models on the Pi while using the Windows PC as the client

## Recommended method: Tailscale

Tailscale creates a private network between devices. No domain is needed.

## Step 1: Install Tailscale on the Pi

Your repo already includes a Tailscale service in `docker-compose.ai.yml`.

Make sure your `.env` file contains:

```env
TAILSCALE_AUTHKEY=tskey-xxxxxxxxxxxxx
TAILSCALE_HOSTNAME=pi5-ai-rack
```

Then start the stack:

```bash
docker compose -f docker-compose.ai.yml up -d
```

Check the logs:

```bash
docker compose -f docker-compose.ai.yml logs -f tailscale
```

You should see the Pi connect to your Tailscale tailnet.

## Step 2: Install Tailscale on Windows 11

1. Open your browser and go to:
   https://tailscale.com/download/windows
2. Download the Windows installer
3. Run the installer and complete setup
4. Sign in to your Tailscale account
5. Confirm the device is connected

## Step 3: Find the Pi on the Tailscale Network

Once both devices are connected:

- Your Pi will appear as something like `pi5-ai-rack` in Tailscale
- Your Windows PC will appear as its own device name

From Windows, you can access the Pi using either:
- the device name: `http://pi5-ai-rack:3000`
- or the Tailscale IP assigned to the Pi

## Step 4: Access the AI Services from Windows

Use these URLs in your browser on Windows:

- Open WebUI: `http://pi5-ai-rack:3000`
- FileBrowser: `http://pi5-ai-rack:8081`
- MinIO Console: `http://pi5-ai-rack:9001`
- Ollama API: `http://pi5-ai-rack:11434`

If you prefer IP-based access, use the Tailscale IP from the Pi device in your Tailscale admin panel.

## Step 5: Use the Pi for Local Ollama Models

The Pi runs the models locally.

From Windows, you can still use the AI by visiting the Open WebUI dashboard on the Pi.

You do not need to run Ollama on Windows unless you want to.

### Useful commands on the Pi:

```bash
docker exec ai-ollama ollama list
docker exec ai-ollama ollama pull mistral
docker exec ai-ollama ollama run mistral
```

## Step 6: Optional: Use Windows to Access the Pi’s File Storage

You can mount or browse the Pi’s data via:
- FileBrowser on port 8081
- MinIO console on port 9001
- SMB/SSH if you enable it on the Pi

For a simple solution, use the browser UI on the Tailscale connection.

## Step 7: Optional: Run Windows Terminal Remote Access

If you want terminal access to the Pi from Windows, use one of these:

### Option A: PowerShell + SSH

On the Pi, ensure SSH is enabled:

```bash
sudo raspi-config
```

Then:

```bash
sudo systemctl enable ssh
sudo systemctl start ssh
```

From Windows PowerShell:

```powershell
ssh pi@pi5-ai-rack.tailnetXYZ.ts.net
```

Replace the hostname with your actual Tailscale device name or IP.

### Option B: Tailscale + browser UI

This is easier if you do not want to use SSH from Windows.

## Step 8: Keep It Secure

- Only allow Tailscale access to the devices you want
- Do not expose ports 3000, 8081, or 9001 publicly
- Keep the Pi behind your local network and private Tailscale network
- Use strong passwords for MinIO and Postgres
- Keep Tailscale auth keys short-lived when possible

## Quick Access Summary

From Windows 11, connect to the Pi over Tailscale and open:

- http://pi5-ai-rack:3000
- http://pi5-ai-rack:8081
- http://pi5-ai-rack:9001

This gives you a simple, private local AI workflow without a domain.

## Common issues

### The Pi does not appear in Tailscale

Check:

```bash
docker compose -f docker-compose.ai.yml logs tailscale
```

Then restart:

```bash
docker compose -f docker-compose.ai.yml restart tailscale
```

### Browser says connection refused

Check the service is running:

```bash
docker compose -f docker-compose.ai.yml ps
```

### Open WebUI won’t load

Check the logs:

```bash
docker compose -f docker-compose.ai.yml logs -f open-webui
```

## Best practice for your workflow

Use:
- Windows 11 as the client device
- Pi 5 as the model host and storage machine
- Tailscale as the private network layer

This gives you a cleaner setup than exposing the Pi over the internet.

## Recommended Windows workflow

1. Turn on Tailscale on both devices
2. Open Open WebUI from the Pi over the Tailscale network
3. Use FileBrowser for files and images
4. Keep chat history and archives on the Pi
5. Back up everything nightly with the provided script

## Example Windows access URLs

```text
http://pi5-ai-rack:3000
http://pi5-ai-rack:8081
http://pi5-ai-rack:9001
```

If your Tailscale device name differs, replace `pi5-ai-rack` with the actual device name.

## Final note

This setup is ideal for a local AI memory/workflow where:
- the Pi runs the model
- the Windows PC acts as the user interface
- file storage and backups remain local and private
- no public domain is needed
