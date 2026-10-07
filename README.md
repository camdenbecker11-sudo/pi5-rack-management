# Pi 5 Rack Management Stack

A self-hosted technology stack for managing a small rack, homelab, or lab environment using a Raspberry Pi 5.

This project is designed to give you one place to manage:
- containers and services
- networking and DNS
- uptime and alerts
- automation
- device inventory
- secure remote access
- monitoring and dashboards

## Included tools

- Portainer - container management
- Traefik - reverse proxy and routing
- Home Assistant - automation and smart device control
- Uptime Kuma - uptime checks and status pages
- AdGuard Home - local DNS and ad blocking
- Prometheus - metrics collection
- Grafana - monitoring dashboards
- NetBox - infrastructure inventory and IP management
- Tailscale - secure remote access

## Recommended hardware

- Raspberry Pi 5
- 32GB+ microSD or SSD boot drive
- Active cooling fan
- 10-inch rack mount
- Optional UPS or PoE HAT

## Recommended OS

- Raspberry Pi OS Lite (64-bit)
- Debian 12
- Ubuntu Server 24.04 LTS

## Quick start

1. Install Docker and Docker Compose on your Pi.
2. Clone this repo.
3. Copy the example environment file.
4. Edit the values.
5. Start the stack.

```bash
git clone https://github.com/camdenbecker11-sudo/pi5-rack-management.git
cd pi5-rack-management
cp .env.example .env
nano .env
docker compose up -d
```

## Access points

After the stack starts, open these in your browser:

- Portainer: http://<PI_IP>:9000
- Traefik: http://<PI_IP>:8080
- Home Assistant: http://<PI_IP>:8123
- Uptime Kuma: http://<PI_IP>:3001
- AdGuard Home: http://<PI_IP>:3000
- Grafana: http://<PI_IP>:3002
- Prometheus: http://<PI_IP>:9090
- NetBox: http://<PI_IP>:8000

## Default ports

- 80: HTTP
- 443: HTTPS
- 8080: Traefik dashboard
- 9000: Portainer
- 8123: Home Assistant
- 3000: AdGuard Home
- 3001: Uptime Kuma
- 3002: Grafana
- 9090: Prometheus
- 8000: NetBox

## Environment variables

Edit `.env` before starting the stack.

Example values:

```env
TZ=America/New_York
ACME_EMAIL=you@example.com
DOMAIN=example.com
TAILSCALE_AUTHKEY=tskey-xxxxxxxxxxxxx
TAILSCALE_HOSTNAME=pi5-rack
ADGUARD_USERNAME=admin
ADGUARD_PASSWORD=change-this-password
HOMEASSISTANT_PORT=8123
PORTAINER_PORT=9000
UPTIMEKUMA_PORT=3001
GRAFANA_PORT=3002
PROMETHEUS_PORT=9090
NETBOX_PORT=8000
NETBOX_DB_NAME=netbox
NETBOX_DB_USER=netbox
NETBOX_DB_PASSWORD=change-this-password
```

## Notes

- For real HTTPS, configure DNS and a public domain.
- Tailscale is useful for secure remote access without exposing ports publicly.
- This is best used as a self-hosted lab or home rack control layer.
- For heavy workloads, keep the Pi 5 focused on control and monitoring and use other devices for compute-intensive services.

## Suggested use cases

- homelab dashboard
- device inventory and IP tracking
- DNS filtering
- rack automation
- container administration
- status monitoring
- secure remote management
- multi-service management from one box

## License

This project is provided as a starter template for a self-hosted rack setup.

## Future ideas

- Add a custom landing page for the rack
- Add backup automation
- Add smart UPS monitoring
- Add cloudflare tunnel support
- Add alerts via Discord/Telegram/Slack
- Add volume mount and disk health monitoring
- Add custom dashboards for each rack device

## Troubleshooting

### Docker permission issues

If Docker commands require sudo:

```bash
sudo usermod -aG docker $USER
```

Then log out and back in.

### Port conflicts

If a service port is already in use, change the port in `.env` or edit `docker-compose.yml`.

### Home Assistant network issues

Home Assistant uses `network_mode: host` for simpler local device discovery.

### NetBox startup problems

Make sure `SECRET_KEY` is set and the database variables are correct.

## Optional next steps

If you want a production-grade version, the next improvements would be:
- proper HTTPS with Let's Encrypt
- custom domain routing
- backup volume strategy
- monitoring for disk health and temperatures
- application-specific dashboards
- a nicer rack landing page
- centralized authentication

