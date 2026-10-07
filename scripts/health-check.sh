#!/bin/bash
# Health check script for rack services
set -e

echo "Pi 5 Rack Health Check - $(date)"
echo "======================================"

# Check Docker
echo "[*] Docker status:"
docker ps --filter "label=com.docker.compose.project=pi5-rack-management" --format "table {{.Names}}\t{{.Status}}"

# Check disk usage
echo ""
echo "[*] Disk usage:"
df -h | grep -E '^/dev|Filesystem'

# Check temperatures (if available)
echo ""
echo "[*] CPU Temperature:"
if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
  TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)
  TEMP_C=$(echo "scale=1; $TEMP / 1000" | bc)
  echo "  ${TEMP_C}°C"
else
  echo "  N/A"
fi

# Check memory usage
echo ""
echo "[*] Memory usage:"
free -h | grep Mem

# Check services health
echo ""
echo "[*] Service health:"
curl -s http://localhost:3001/api/status-page/heartbeat || echo "Uptime Kuma: UNREACHABLE"

echo ""
echo "Health check complete"
