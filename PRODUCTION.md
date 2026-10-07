# Production Setup Guide

This guide covers deploying the Pi 5 rack management stack with production-grade HTTPS, backups, monitoring, and security.

## Prerequisites

- Raspberry Pi 5 with active cooling
- SSD boot drive (32GB+)
- A registered domain name
- Docker and Docker Compose installed

## Step 1: Domain Setup

1. Register a domain (e.g., `yourdomain.com`)
2. Point your domain to the Pi 5's static IP:
   - Add A record: `yourdomain.com` -> `<PI_IP>`
   - Add wildcard: `*.yourdomain.com` -> `<PI_IP>`
3. Wait for DNS propagation (5-30 minutes)

## Step 2: Environment Configuration

```bash
cp .env.example .env
nano .env
```

Key variables to set:

```env
DOMAIN=yourdomain.com
ACME_EMAIL=you@example.com
TRAEFIK_USER=admin:$2y$05$...
GRAFANA_PASSWORD=strong-password
NETBOX_DB_PASSWORD=strong-password
NETBOX_SECRET_KEY=generate-random-string
```

### Generate Traefik auth password:

```bash
apt-get install apache2-utils
htpasswd -nB admin | sed 's/\$/\$\$/g'
```

Copy the output to `TRAEFIK_USER`.

## Step 3: Start Production Stack

```bash
docker compose -f docker-compose.prod.yml up -d
```

Check logs:

```bash
docker compose -f docker-compose.prod.yml logs -f traefik
```

## Step 4: HTTPS & Let's Encrypt

Wait for certificates to generate (1-2 minutes). Check:

```bash
ls -la ./letsencrypt/acme.json
```

Access via HTTPS:
- https://yourdomain.com (dashboard)
- https://portainer.yourdomain.com
- https://grafana.yourdomain.com
- https://uptime.yourdomain.com
- https://netbox.yourdomain.com
- https://adguard.yourdomain.com

## Step 5: Automated Backups

Set up daily backups:

```bash
chmod +x scripts/backup.sh
(crontab -l 2>/dev/null; echo "0 2 * * * cd /path/to/pi5-rack-management && ./scripts/backup.sh") | crontab -
```

Manual backup:

```bash
./scripts/backup.sh
```

## Step 6: Monitoring & Health Checks

Run health check:

```bash
chmod +x scripts/health-check.sh
./scripts/health-check.sh
```

Schedule hourly:

```bash
(crontab -l 2>/dev/null; echo "0 * * * * cd /path/to/pi5-rack-management && ./scripts/health-check.sh >> ./logs/health-check.log 2>&1") | crontab -
```

## Step 7: System Monitoring

1. Open https://grafana.yourdomain.com
2. Login with admin / `GRAFANA_PASSWORD`
3. Add Prometheus data source: `http://prometheus:9090`
4. Import dashboard: `grafana/dashboards/system-metrics.json`

Metrics tracked:
- CPU usage
- Memory usage
- Disk usage
- Temperature
- Network traffic

## Step 8: Centralized Authentication (Optional)

For services that support it, add OAuth2/OIDC via Authelia or Keycloak. This is a future enhancement.

## Maintenance

### Update containers:

```bash
docker compose -f docker-compose.prod.yml pull
docker compose -f docker-compose.prod.yml up -d
```

### View logs:

```bash
docker compose -f docker-compose.prod.yml logs -f <service-name>
```

### Restart a service:

```bash
docker compose -f docker-compose.prod.yml restart <service-name>
```

### Clean up old volumes:

```bash
docker system prune -a --volumes
```

## Security Best Practices

1. **Firewall**: Only expose ports 80/443 to the internet
2. **SSH**: Disable password auth, use keys only
3. **Backups**: Store encrypted backups off-site
4. **Passwords**: Use strong, unique passwords
5. **Updates**: Keep OS and containers updated
6. **Monitoring**: Use Uptime Kuma to alert on failures

## Troubleshooting

### Certificate not generating:

```bash
docker compose -f docker-compose.prod.yml logs traefik | tail -50
```

Ensure DNS is working and port 80 is accessible.

### High CPU/memory usage:

Check which container:

```bash
docker stats
```

Scale back services or add more hardware.

### Backups not running:

Check cron:

```bash
crontab -l
grep -r backup /var/log/syslog | tail -20
```

## Support

For issues, check:
- Service logs: `docker compose -f docker-compose.prod.yml logs <service>`
- Health check: `./scripts/health-check.sh`
- Uptime Kuma dashboard for service status
