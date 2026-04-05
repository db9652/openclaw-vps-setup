# 🦞 OpenClaw VPS Setup

**One-command deployment of a secure, always-on OpenClaw Gateway on any VPS.**

Based on the [OpenClaw Beginner Workshop](https://docs.openclaw.ai) — all the best practices baked into a Docker setup so you don't have to follow a 30-page guide manually.

## What You Get

- ✅ **Secure VPS** — SSH hardening, fail2ban, UFW firewall (SSH-only)
- ✅ **OpenClaw Gateway** — running in Docker with safe defaults (loopback bind, token auth)
- ✅ **Personalized workspace** — SOUL.md, USER.md, AGENTS.md, TOOLS.md, LEARNINGS.md templates
- ✅ **Memory system** — automatic flush before compaction, daily logs, long-term memory
- ✅ **Model ladder** — Sonnet (default) → Opus (complex) → Haiku (heartbeats) preconfigured
- ✅ **Production-ready** — health checks, auto-restart, persistent volumes

## Architecture

```
Your Laptop                          Your VPS (Docker)
┌──────────┐    SSH Tunnel     ┌─────────────────────────┐
│ Browser   │◄────────────────►│  OpenClaw Gateway       │
│ Terminal  │  localhost:18789  │  ├─ Control UI          │
└──────────┘                   │  ├─ Agent Runtime       │
                               │  ├─ Workspace (mounted) │
┌──────────┐    Telegram API   │  └─ Memory + Sessions   │
│ Telegram  │◄────────────────►│                         │
└──────────┘                   └─────────────────────────┘
```

## Prerequisites

| Requirement | Details |
|---|---|
| **VPS** | Ubuntu 22.04+ / 24.04+, 2+ GB RAM, public IP |
| **API Keys** | Anthropic (required), OpenAI (for embeddings), Brave Search (optional) |
| **Local** | Terminal with SSH access |

## Quick Start

### 1. Harden Your VPS (first time only)

```bash
ssh root@YOUR_VPS_IP
git clone https://github.com/vijaycholleti24/openclaw-vps-setup.git
cd openclaw-vps-setup
sudo bash scripts/setup-host.sh
```

This creates the `openclaw` user, installs Docker, hardens SSH, sets up fail2ban, and enables the firewall.

### 2. Configure

```bash
# Switch to openclaw user
su - openclaw
cd /path/to/openclaw-vps-setup

# Set up your environment
cp .env.example .env
nano .env  # Add your API keys
```

### 3. Launch

```bash
docker compose up -d
```

### 4. Access the Control UI

On your **local machine**, create an SSH tunnel:

```bash
ssh -N -L 18789:127.0.0.1:18789 openclaw@YOUR_VPS_IP
```

Then open: [http://127.0.0.1:18789/](http://127.0.0.1:18789/)

The gateway token is printed in the container logs on first run:

```bash
docker compose logs openclaw | grep "Gateway token"
```

### 5. Personalize Your Agent

In the Control UI, introduce yourself:

> "Hey! I'm [your name]. Call me [nickname]. You're my personal AI assistant — help me with [your use case]. Save this to IDENTITY.md and USER.md."

Then ask it to interview you and build out your workspace files.

## Project Structure

```
openclaw-vps-setup/
├── Dockerfile                 # OpenClaw container image
├── docker-compose.yml         # Production deployment config
├── Makefile                   # Common commands (make start, make logs, etc.)
├── .env.example               # Environment variables template
├── .gitignore                 # Keeps secrets out of git
├── LICENSE                    # MIT
├── CONTRIBUTING.md            # How to contribute
├── SECURITY.md                # Security policy + design principles
├── scripts/
│   ├── entrypoint.sh          # Container startup script
│   └── setup-host.sh          # VPS hardening (run once)
├── docs/
│   ├── CHANNELS.md            # Detailed channel setup (Telegram/WhatsApp/Slack/Discord)
│   ├── COST-GUIDE.md          # Real costs vs the $6,000 myth
│   └── TROUBLESHOOTING.md     # Common problems + fixes
├── workspace-templates/       # Default workspace files
│   ├── AGENTS.md
│   ├── SOUL.md
│   ├── USER.md
│   ├── TOOLS.md
│   ├── LEARNINGS.md
│   ├── MEMORY.md
│   └── HEARTBEAT.md
└── .github/
    └── ISSUE_TEMPLATE/        # Bug report + feature request templates
```

## Channel Setup

### Telegram

1. Create a bot via [@BotFather](https://t.me/BotFather) on Telegram (`/newbot`)
2. Add the bot token to your `.env` file as `TELEGRAM_BOT_TOKEN`
3. Restart the container: `docker compose restart`
4. In the Control UI, tell your agent:
   ```
   Connect Telegram using the bot token from the TELEGRAM_BOT_TOKEN environment variable.
   Set DM policy to "pairing" and require @mention in groups.
   ```
5. DM your bot on Telegram — it will show a pairing code
6. Approve it:
   ```bash
   docker compose exec openclaw openclaw pairing list
   docker compose exec openclaw openclaw pairing approve telegram <CODE>
   ```

### WhatsApp

1. In the Control UI, tell your agent:
   ```
   Set up WhatsApp channel. Show me the QR code for linking.
   ```
2. Or via CLI inside the container:
   ```bash
   docker compose exec openclaw openclaw channels login --channel whatsapp
   ```
3. Scan the QR code with WhatsApp on your phone (Settings → Linked Devices → Link a Device)
4. Set safe defaults:
   ```
   Set WhatsApp DM policy to "pairing" and require @mention in groups.
   ```

> ⚠️ WhatsApp Web sessions can expire. You may need to re-link periodically.

### Slack

1. Create a Slack app at [api.slack.com/apps](https://api.slack.com/apps)
2. Add required bot scopes: `chat:write`, `channels:history`, `groups:history`, `im:history`, `reactions:write`
3. Install the app to your workspace and copy the Bot User OAuth Token
4. In the Control UI:
   ```
   Connect Slack using bot token xoxb-your-token-here.
   Set DM policy to "pairing" and require @mention in channels.
   ```
5. Invite the bot to channels: `/invite @your-bot-name`

### Discord

1. Create a Discord application at [discord.com/developers](https://discord.com/developers/applications)
2. Create a bot, enable Message Content Intent under Privileged Gateway Intents
3. Copy the bot token
4. Generate an invite URL with `bot` scope and `Send Messages`, `Read Message History`, `Add Reactions` permissions
5. In the Control UI:
   ```
   Connect Discord using bot token your-discord-bot-token.
   Set DM policy to "pairing" and require @mention in servers.
   ```

## Security Notes

- 🔒 Gateway binds to **loopback only** — access via SSH tunnel, never expose publicly
- 🔑 Token auth enabled by default — token auto-generated on first run
- 🛡️ VPS hardened: root login disabled, fail2ban active, firewall (SSH only)
- 🚫 Never commit `.env` — it contains your API keys
- 📁 File permissions: 700 on state dir, 600 on config

Run security audits regularly:

```bash
docker compose exec openclaw openclaw security audit --deep
```

## Quick Commands (Makefile)

```bash
make setup        # First-time: copy .env + build
make start        # Start the Gateway
make stop         # Stop the Gateway
make restart      # Restart
make logs         # Tail logs
make status       # Check Gateway status
make health       # Health check
make audit        # Security audit (deep)
make update       # Update OpenClaw + restart
make backup       # Create backup
make shell        # Open shell inside container
make doctor       # Run diagnostics
make token        # Show Gateway auth token
make tunnel-hint  # Print SSH tunnel command
```

## Maintenance

```bash
# Or without Make:
docker compose exec openclaw openclaw update
docker compose exec openclaw openclaw status
docker compose exec openclaw openclaw doctor
docker compose exec openclaw openclaw security audit --deep
docker compose exec openclaw openclaw backup create
```

## Cost Optimization

| Model | Use For | Approx. Cost |
|---|---|---|
| Sonnet (default) | Day-to-day tasks | ~$3/1M input tokens |
| Opus | Complex reasoning | ~$15/1M input tokens |
| Haiku | Heartbeats, simple queries | ~$0.25/1M input tokens |

**Tips:**
- Heartbeats use Haiku with `lightContext` — pennies per day
- Memory flush prevents expensive re-discussions
- Set provider-level spend limits

## Troubleshooting

| Problem | Fix |
|---|---|
| Can't access Control UI | Check SSH tunnel is running, verify port 18789 |
| "Unauthorized" | Check gateway token: `docker compose logs openclaw \| grep token` |
| Agent forgot something | Enable memory flush, ask agent to write to MEMORY.md |
| Container won't start | `docker compose logs openclaw` for errors |
| Telegram not connecting | Verify bot token in .env, restart container |

## 📖 Documentation

- **[Channel Setup Guide](docs/CHANNELS.md)** — Detailed Telegram, WhatsApp, Slack, Discord setup
- **[Cost Guide](docs/COST-GUIDE.md)** — Real costs vs the $6,000 myth
- **[Troubleshooting](docs/TROUBLESHOOTING.md)** — Common problems + fixes
- **[Contributing](CONTRIBUTING.md)** — How to contribute
- **[Security Policy](SECURITY.md)** — Security design + reporting vulnerabilities

## Credits

- Based on the [OpenClaw Beginner Workshop](https://docs.openclaw.ai) (rev. 2026-03-19)
- [OpenClaw](https://github.com/openclaw/openclaw) — 250k+ ⭐ on GitHub
- [OpenClaw Docs](https://docs.openclaw.ai)
- [Community Discord](https://discord.com/invite/clawd)

## License

MIT — do whatever you want with it.

---

**Built by [Vijay Cholleti](https://github.com/vijaycholleti24)** ❄️
