#!/bin/bash
# ══════════════════════════════════════════════════════════════
# OpenClaw VPS Host Setup Script
# Run this BEFORE docker-compose up to harden your VPS
# Usage: sudo bash scripts/setup-host.sh
# ══════════════════════════════════════════════════════════════

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}╔══════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║  🔒 OpenClaw VPS Host Hardening          ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════╝${NC}"

# ── Check root ──
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Error: Run this script as root (sudo bash scripts/setup-host.sh)${NC}"
    exit 1
fi

# ── Create openclaw user if not exists ──
if ! id "openclaw" &>/dev/null; then
    echo -e "${YELLOW}Creating 'openclaw' user...${NC}"
    adduser --disabled-password --gecos "" openclaw
    usermod -aG sudo openclaw
    echo -e "${GREEN}✅ User 'openclaw' created${NC}"
    echo -e "${YELLOW}Set a password: passwd openclaw${NC}"
else
    echo -e "${GREEN}✅ User 'openclaw' already exists${NC}"
fi

# ── Install Docker if not present ──
if ! command -v docker &>/dev/null; then
    echo -e "${YELLOW}Installing Docker...${NC}"
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker openclaw
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✅ Docker installed${NC}"
else
    echo -e "${GREEN}✅ Docker already installed${NC}"
fi

# ── Install Docker Compose plugin if not present ──
if ! docker compose version &>/dev/null 2>&1; then
    echo -e "${YELLOW}Installing Docker Compose plugin...${NC}"
    apt-get update && apt-get install -y docker-compose-plugin
    echo -e "${GREEN}✅ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✅ Docker Compose already installed${NC}"
fi

# ── SSH Hardening ──
echo -e "${YELLOW}Hardening SSH...${NC}"
SSHD_CONFIG="/etc/ssh/sshd_config"

# Disable root login
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' "$SSHD_CONFIG"
# Limit auth attempts
grep -q "^MaxAuthTries" "$SSHD_CONFIG" || echo "MaxAuthTries 5" >> "$SSHD_CONFIG"
grep -q "^LoginGraceTime" "$SSHD_CONFIG" || echo "LoginGraceTime 60" >> "$SSHD_CONFIG"

# Validate config before restarting
if sshd -t 2>/dev/null; then
    systemctl restart ssh
    echo -e "${GREEN}✅ SSH hardened (root login disabled)${NC}"
else
    echo -e "${RED}⚠️  SSH config has errors — fix manually${NC}"
fi

# ── fail2ban ──
echo -e "${YELLOW}Setting up fail2ban...${NC}"
apt-get update && apt-get install -y fail2ban

cat > /etc/fail2ban/jail.local << 'EOF'
[sshd]
enabled = true
port = ssh
filter = sshd
maxretry = 5
findtime = 600
bantime = 3600
EOF

systemctl enable fail2ban
systemctl restart fail2ban
echo -e "${GREEN}✅ fail2ban configured (5 attempts → 1hr ban)${NC}"

# ── Firewall ──
echo -e "${YELLOW}Configuring UFW firewall...${NC}"
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp
# Note: Gateway port (18789) is NOT opened — use SSH tunnel
ufw --force enable
echo -e "${GREEN}✅ Firewall enabled (SSH only)${NC}"

# ── Auto-updates ──
echo -e "${YELLOW}Enabling unattended upgrades...${NC}"
apt-get install -y unattended-upgrades
echo -e "${GREEN}✅ Unattended upgrades installed${NC}"

echo ""
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✅ VPS hardening complete!${NC}"
echo -e "${GREEN}══════════════════════════════════════════${NC}"
echo ""
echo "Next steps:"
echo "  1. Set password for openclaw user:  passwd openclaw"
echo "  2. Log in as openclaw:              su - openclaw"
echo "  3. Copy .env.example to .env and fill in your API keys"
echo "  4. Run:                             docker compose up -d"
echo "  5. Access Control UI via SSH tunnel"
echo ""
echo -e "${YELLOW}⚠️  Test SSH login as 'openclaw' BEFORE closing this session!${NC}"
