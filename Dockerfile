# OpenClaw VPS Setup — Production-ready Docker image
# Based on the OpenClaw Beginner Workshop (rev. 2026-03-19)
#
# Build:  docker build -t openclaw-vps .
# Run:    docker-compose up -d

FROM ubuntu:24.04

LABEL maintainer="Vijay Cholleti <https://github.com/vijaycholleti24>"
LABEL description="Self-hosted OpenClaw Gateway with secure defaults"
LABEL version="1.0.0"

# ── Prevent interactive prompts during build ──
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# ── System dependencies ──
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    ca-certificates \
    gnupg \
    git \
    sudo \
    fail2ban \
    ufw \
    unattended-upgrades \
    nano \
    jq \
    && rm -rf /var/lib/apt/lists/*

# ── Install Node.js 22.x (LTS) ──
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# ── Create non-root user ──
RUN useradd -m -s /bin/bash -G sudo openclaw \
    && echo "openclaw ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/openclaw

# ── Install OpenClaw CLI globally ──
RUN npm install -g openclaw@latest

# ── Switch to non-root user ──
USER openclaw
WORKDIR /home/openclaw

# ── Create workspace + state directories ──
RUN mkdir -p \
    /home/openclaw/.openclaw/workspace \
    /home/openclaw/.openclaw/workspace/memory \
    /home/openclaw/.openclaw/workspace/memory/archive \
    /home/openclaw/.openclaw/workspace/memory/archive/raw \
    /home/openclaw/.openclaw/workspace/skills

# ── Copy setup scripts and workspace templates ──
COPY --chown=openclaw:openclaw scripts/ /home/openclaw/scripts/
COPY --chown=openclaw:openclaw workspace-templates/ /home/openclaw/workspace-templates/

# ── Set secure file permissions ──
RUN chmod 700 /home/openclaw/.openclaw \
    && chmod +x /home/openclaw/scripts/*.sh

# ── Expose Gateway port (loopback-only by default) ──
EXPOSE 18789

# ── Health check ──
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD openclaw health || exit 1

# ── Entrypoint ──
ENTRYPOINT ["/home/openclaw/scripts/entrypoint.sh"]
