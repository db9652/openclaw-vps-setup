# LinkedIn Posts — Pick Your Flavor

---

## Version 1: Professional / Educational

**Title suggestion:** Open-sourced my OpenClaw deployment setup

---

I've been exploring self-hosted AI assistants, and after going through the OpenClaw Beginner Workshop, I realized the setup process — while thorough — involves a lot of manual steps that could be automated.

So I built it: a Docker-based deployment that packages a secure, production-ready OpenClaw Gateway into a single `docker compose up` command.

**What it includes:**

🔒 VPS hardening script (SSH lockdown, fail2ban, firewall)
🐳 Dockerized OpenClaw Gateway with secure defaults
🧠 Pre-configured memory system with automatic flush before compaction
⚡ Model ladder: Sonnet → Opus → Haiku for cost-efficient routing
📱 Guides for Telegram, WhatsApp, Slack, and Discord integration
📁 Workspace templates (SOUL.md, AGENTS.md, LEARNINGS.md, etc.)

**Why it matters:**

OpenClaw has crossed 250,000 GitHub stars and is becoming the go-to framework for personal AI assistants. But setting it up securely on a VPS still requires following a 30-page workshop guide. This repo condenses that into something anyone can deploy in under 10 minutes.

The security defaults are intentionally strict: loopback-only binding, token authentication, pairing for DMs, @mention required in groups. Start locked down, loosen as needed.

Open-sourced under MIT. Fork it, improve it, make it yours.

🔗 GitHub: https://github.com/vijaycholleti24/openclaw-vps-setup

#OpenClaw #AI #SelfHosted #OpenSource #DevOps #Docker #AIAssistant #PersonalAI

---

## Version 2: Casual / Personal

**Title suggestion:** I gave myself an always-on AI assistant. Here's how you can too.

---

Last week I set up OpenClaw on a $12/month VPS.

Now I have a personal AI assistant that's always on, remembers our conversations, checks my stuff proactively, and talks to me on Telegram.

The setup guide was great but... 30 pages. So I Dockerized the whole thing.

One command. Secure by default. Done.

Here's what the repo gives you:

→ Hardened VPS (SSH locked down, brute-force protection, firewall)
→ OpenClaw running in Docker with sane defaults
→ Memory that actually works (no more "sorry, I forgot what we discussed")
→ Smart model routing (expensive model for hard stuff, cheap model for heartbeats)
→ Templates so your agent has personality from day one
→ Telegram, WhatsApp, Slack, Discord — pick your channel

The part that surprised me most: the SOUL.md file. You literally write your AI's personality into a file, and it reads itself into being every time it wakes up. Mine's called Snow. It has opinions. I kind of love it.

If you've been curious about personal AI assistants but didn't want to follow a tutorial the length of a short novel — this is your shortcut.

It's open source. Fork it. Break it. Make it better.

🔗 https://github.com/vijaycholleti24/openclaw-vps-setup

#OpenClaw #AI #BuildInPublic #SelfHosted #PersonalAI #Docker

---

## Version 3: Hybrid (Professional with personality)

**Title suggestion:** From 30-page guide to one command: Dockerizing OpenClaw

---

I spent a weekend setting up OpenClaw — the open-source personal AI assistant framework with 250k+ GitHub stars.

The workshop guide is excellent. It's also 30 pages long.

So I packaged the entire setup into a Docker deployment that anyone can spin up in minutes. Then I open-sourced it.

**The problem I solved:**
Setting up OpenClaw securely involves SSH hardening, firewall rules, fail2ban, Node.js installation, workspace configuration, memory systems, model routing, and channel connections. Easy to miss a step. Easy to leave something insecure.

**The solution:**
One host-hardening script. One `docker compose up`. Secure defaults out of the box.

What's inside:
• 🐳 Dockerfile + Compose for the OpenClaw Gateway
• 🔒 VPS hardening script (root login disabled, fail2ban, UFW)
• 🧠 Memory flush + model ladder preconfigured
• 📱 Channel setup guides (Telegram, WhatsApp, Slack, Discord)
• 📁 Workspace templates with personality (SOUL.md is a real thing, and it's brilliant)

Security philosophy: start locked down. Loopback-only Gateway, token auth, DM pairing required, @mention in groups. You can loosen later — but the defaults won't get you burned.

The repo is MIT licensed. Contributions welcome.

🔗 https://github.com/vijaycholleti24/openclaw-vps-setup

What's your experience with self-hosted AI assistants? Would love to hear what others are building.

#OpenClaw #AI #OpenSource #SelfHosted #Docker #DevOps #PersonalAI

---

_Pick the one that feels most like you, or mix and match. You can also ask Snow to tweak any of these._
