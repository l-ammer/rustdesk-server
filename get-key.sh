#!/bin/bash
# Get the RustDesk public key from running container or data directory

DATA_DIR="$(dirname "$0")/data"

if [ -f "$DATA_DIR/id_ed25519.pub" ]; then
    echo "=== RustDesk Public Key ==="
    cat "$DATA_DIR/id_ed25519.pub"
    echo ""
    echo "=== Use this in your RustDesk client settings ==="
    echo "ID Server: 202.61.192.237:21116"
    echo "Relay Server: 202.61.192.237:21117"
else
    echo "Key not found. Is the server running?"
    echo "Checking docker logs..."
    docker logs rustdesk-hbbs 2>&1 | grep -i "key\|Public" || echo "No key found in logs yet. Wait a few seconds and retry."
fi
