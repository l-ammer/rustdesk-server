# RustDesk Self-Hosted Server

Self-hosted remote desktop server running on Docker.

## Architecture

- **hbbs** - ID/signaling server (handles peer discovery, ID registration)
- **hbbr** - Relay server (handles traffic when direct P2P fails)

## Default Ports

| Port | Protocol | Purpose |
|------|----------|---------|
| 21115 | TCP | NAT type test |
| 21116 | TCP+UDP | ID registration & heartbeat |
| 21117 | TCP | Relay service |
| 21118 | TCP | Web client (optional) |
| 21119 | TCP | Web client (optional) |

## Setup

### 1. Configure

Edit `docker-compose.yml` and set your relay host (domain or IP):

```yaml
command: hbbs -r YOUR_IP_OR_DOMAIN:21117
```

### 2. Deploy

```bash
cd ~/Projekte/rustdesk-server
# Copy to server (when SSH available)
scp -r . lam@202.61.192.237:~/services/rustdesk/
# Or use git push if you add to a repo
```

On server:
```bash
cd ~/services/rustdesk
docker compose up -d
```

### 3. Get Key

After first start, the public key is generated:

```bash
docker logs rustdesk-hbbs 2>&1 | grep "Public Key"
# Or check the data directory
cat data/id_ed25519.pub
```

### 4. Client Configuration

In RustDesk client:
- **ID Server**: Your server IP or domain (port 21116)
- **Relay Server**: Your server IP or domain (port 21117)
- **Key**: The public key from step 3

## Nginx Proxy Manager Integration (Optional)

If you want web client access via HTTPS, add proxy hosts in NPM:
- Web Client: `rustdesk.yourdomain.com` → `http://202.61.192.237:21118`

Note: Native RustDesk clients connect directly to ports 21115-21117, not through NPM.

## Firewall

Ensure ports are open:
```bash
sudo ufw allow 21115:21119/tcp
sudo ufw allow 21116/udp
```

## Backup

Backup the `./data/` directory - it contains the persistent key pair.
