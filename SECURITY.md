# Security Policy

## Reporting a Vulnerability

If you discover a security issue in this project, please **do not** open a public GitHub issue.

Instead, email: **vijaycholleti24@gmail.com** (or open a private security advisory on GitHub).

I'll respond within 48 hours and work on a fix.

## Security Design Principles

This project follows these security defaults:

1. **Loopback-only binding** — Gateway never exposed to the public internet
2. **Token authentication** — required for all Control UI access
3. **SSH tunnel access** — the only way to reach the Control UI remotely
4. **DM pairing** — strangers can't message your bot without approval
5. **@mention required** — bot stays silent in groups unless addressed
6. **No secrets in code** — all API keys via environment variables
7. **Strict file permissions** — 700 on state dir, 600 on config
8. **Firewall** — only SSH (port 22) open, Gateway port blocked

## What This Project Does NOT Cover

- TLS termination (use Tailscale or a reverse proxy if needed)
- Multi-tenant setups (OpenClaw is one-user-per-Gateway by design)
- Vetting community skills (always inspect before installing)

## Keeping Updated

```bash
# Update OpenClaw
make update

# Security audit
make audit

# System updates
sudo apt update && sudo apt upgrade -y
```
