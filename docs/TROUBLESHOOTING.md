# Troubleshooting Guide

## Container Won't Start

```bash
# Check logs
docker compose logs openclaw

# Common fixes:
# 1. .env file missing
cp .env.example .env && nano .env

# 2. Port already in use
sudo lsof -i :18789
docker compose down && docker compose up -d

# 3. Rebuild from scratch
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

## Can't Access Control UI

**Symptom:** Browser shows "connection refused" at localhost:18789

```bash
# 1. Is the container running?
docker compose ps

# 2. Is the gateway healthy?
docker compose exec openclaw openclaw health

# 3. Is your SSH tunnel running? (on your LOCAL machine)
ssh -N -L 18789:127.0.0.1:18789 openclaw@YOUR_VPS_IP

# 4. Check the right URL
# ✅ http://127.0.0.1:18789/
# ❌ http://YOUR_VPS_IP:18789/ (blocked by firewall — by design)
```

## "Unauthorized" Error

```bash
# Get your gateway token
docker compose logs openclaw | grep "Gateway token"

# Or check config directly
docker compose exec openclaw cat ~/.openclaw/openclaw.json | grep token

# Use token in URL:
# http://127.0.0.1:18789/#token=YOUR_TOKEN_HERE
```

## Agent Forgot Previous Conversations

This is usually a memory/compaction issue:

1. **Enable memory flush** (should be on by default with this setup)
2. **Manually save important info:**
   Tell your agent: "Write this to MEMORY.md" or "Save this to today's daily log"
3. **Check memory status:**
   ```bash
   docker compose exec openclaw openclaw memory status
   ```
4. **Reindex if needed:**
   ```bash
   docker compose exec openclaw openclaw memory index
   ```

## Telegram Bot Not Responding

```bash
# 1. Check if channel is connected
docker compose exec openclaw openclaw status

# 2. Verify bot token
echo $TELEGRAM_BOT_TOKEN  # should not be empty

# 3. Restart with new token
# Edit .env, then:
docker compose restart

# 4. Check pairing
docker compose exec openclaw openclaw pairing list
```

## WhatsApp Disconnected

WhatsApp Web sessions expire periodically. Re-link:

```bash
docker compose exec openclaw openclaw channels login --channel whatsapp
# Scan the new QR code
```

## High API Costs

```bash
# Check what model is being used
docker compose exec openclaw openclaw config get agents.defaults.model

# Verify heartbeat is on Haiku (cheap)
docker compose exec openclaw openclaw config get agents.defaults.heartbeat.model

# Check cron jobs aren't running too frequently
docker compose exec openclaw openclaw cron list
```

## Docker Disk Space

```bash
# Check disk usage
df -h /

# Clean up Docker
docker system prune -f
docker image prune -f
```

## Nuclear Option (Full Reset)

⚠️ This deletes all state. Back up first!

```bash
# Backup
docker compose exec openclaw openclaw backup create

# Reset
docker compose down -v
docker compose build --no-cache
docker compose up -d
```

## Still Stuck?

- Run diagnostics: `docker compose exec openclaw openclaw doctor`
- Security check: `docker compose exec openclaw openclaw security audit --deep`
- OpenClaw docs: https://docs.openclaw.ai
- Community Discord: https://discord.com/invite/clawd
