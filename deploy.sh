#!/bin/bash
# Deploy script for server

set -e

echo "=== RustDesk Server Deployment ==="

# Create data directory
mkdir -p data

# Pull latest image
docker compose pull

# Start services
docker compose up -d

echo ""
echo "=== Waiting for key generation (5s)... ==="
sleep 5

echo ""
if [ -f "data/id_ed25519.pub" ]; then
    echo "=== Your RustDesk Public Key ==="
    cat data/id_ed25519.pub
    echo ""
    echo "=== Client Settings ==="
    echo "ID Server: YOUR_SERVER_IP:21116"
    echo "Relay Server: YOUR_SERVER_IP:21117"
    echo "Key: (copy the key above)"
else
    echo "Key not generated yet. Run ./get-key.sh in a few seconds."
fi

echo ""
echo "=== Logs ==="
docker compose logs --tail 10
