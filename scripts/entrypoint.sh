#!/bin/bash
set -e

echo "╔══════════════════════════════════════════╗"
echo "║  🦞 OpenClaw VPS Setup — Starting...     ║"
echo "╚══════════════════════════════════════════╝"

CONFIG_DIR="$HOME/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
WORKSPACE_DIR="$CONFIG_DIR/workspace"

# ── Initialize workspace templates if first run ──
if [ ! -f "$WORKSPACE_DIR/AGENTS.md" ]; then
    echo "📁 First run detected — setting up workspace templates..."
    cp -n /home/openclaw/workspace-templates/*.md "$WORKSPACE_DIR/" 2>/dev/null || true
    echo "✅ Workspace templates copied"
fi

# ── Create memory directories ──
mkdir -p "$WORKSPACE_DIR/memory/archive/raw"
mkdir -p "$WORKSPACE_DIR/skills"

# ── Generate config if it doesn't exist ──
if [ ! -f "$CONFIG_FILE" ]; then
    echo "⚙️  Generating secure default configuration..."
    
    # Generate a random gateway token if not provided
    GATEWAY_TOKEN="${OPENCLAW_GATEWAY_TOKEN:-$(openssl rand -hex 32)}"
    
    cat > "$CONFIG_FILE" << JSONEOF
{
  "gateway": {
    "mode": "local",
    "bind": "0.0.0.0",
    "port": 18789,
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  },
  "agents": {
    "defaults": {
      "model": "anthropic/claude-sonnet-4-6",
      "fallbacks": ["anthropic/claude-opus-4-6", "anthropic/claude-haiku-4-5"],
      "heartbeat": {
        "every": "30m",
        "model": "anthropic/claude-haiku-4-5",
        "lightContext": true
      },
      "memoryFlush": {
        "enabled": true,
        "mode": "safeguard",
        "softThreshold": 4000
      }
    }
  }
}
JSONEOF

    echo "✅ Config generated"
    echo "🔑 Gateway token: $GATEWAY_TOKEN"
    echo "   (Save this! You'll need it to access the Control UI)"
fi

# ── Set secure permissions ──
chmod 700 "$CONFIG_DIR"
chmod 600 "$CONFIG_FILE"

# ── Print status ──
echo ""
echo "🦞 OpenClaw $(openclaw --version 2>/dev/null || echo 'installed')"
echo "📂 Workspace: $WORKSPACE_DIR"
echo "🔒 Bind: 127.0.0.1:18789 (access via SSH tunnel)"
echo ""
echo "To access the Control UI:"
echo "  1. SSH tunnel: ssh -N -L 18789:127.0.0.1:18789 user@your-vps"
echo "  2. Open: http://127.0.0.1:18789/"
echo ""

# ── Start the Gateway ──
echo "🚀 Starting OpenClaw Gateway..."
exec openclaw gateway --port 18789
