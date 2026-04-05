# Channel Setup Guide

Detailed setup instructions for connecting messaging channels to your OpenClaw Gateway.

## Telegram (Recommended for beginners)

### Why Telegram?
- Free, no phone number sharing required for the bot
- Supports groups, DMs, reactions, file sharing
- Bot API is straightforward
- Best privacy defaults of the major platforms

### Step-by-Step

1. **Create the bot:**
   - Open Telegram → search for `@BotFather`
   - Send `/newbot`
   - Choose a display name (e.g., "My Assistant")
   - Choose a username (must end in `bot`, e.g., `my_openclaw_bot`)
   - Copy the bot token

2. **Add to your .env:**
   ```
   TELEGRAM_BOT_TOKEN=your_token_here
   ```

3. **Restart the container:**
   ```bash
   docker compose restart
   ```

4. **Connect via the Control UI:**
   ```
   Connect Telegram using the bot token from TELEGRAM_BOT_TOKEN.
   Set DM policy to "pairing" and require @mention in groups.
   ```

5. **Pair your DM:**
   - Message your bot on Telegram — it shows a pairing code
   - Approve it:
     ```bash
     docker compose exec openclaw openclaw pairing list
     docker compose exec openclaw openclaw pairing approve telegram <CODE>
     ```

6. **Optional — Group reading:**
   If you want the bot to read group messages (not just @mentions):
   - Go back to @BotFather → `/setprivacy` → select your bot → `Disable`
   - Add the bot to your group

### Security Defaults
- ✅ DM policy: pairing (only approved users)
- ✅ Groups: require @mention
- ❌ Don't set DM policy to "open" unless you want strangers messaging your bot

---

## WhatsApp

### Important Caveats
- Uses WhatsApp Web protocol (not official Business API)
- Sessions can expire — you may need to re-link periodically
- Your personal WhatsApp number is used (the bot IS you)
- Be careful in groups — messages come from your account

### Step-by-Step

1. **Connect via CLI:**
   ```bash
   docker compose exec openclaw openclaw channels login --channel whatsapp
   ```

2. **Scan the QR code:**
   - Open WhatsApp on your phone
   - Settings → Linked Devices → Link a Device
   - Scan the QR code shown in terminal

3. **Set safe defaults (in Control UI):**
   ```
   Set WhatsApp DM policy to "pairing" and require @mention in groups.
   ```

4. **Verify:**
   ```bash
   docker compose exec openclaw openclaw status
   ```

### Tips
- Keep your phone connected to the internet (WhatsApp Web requires it)
- If disconnected, re-link with `openclaw channels login --channel whatsapp`
- Don't let the bot auto-reply to everyone — use pairing

---

## Slack

### Prerequisites
- A Slack workspace where you have admin permissions
- Ability to create Slack apps

### Step-by-Step

1. **Create a Slack App:**
   - Go to [api.slack.com/apps](https://api.slack.com/apps)
   - "Create New App" → "From scratch"
   - Name it (e.g., "OpenClaw Assistant")
   - Select your workspace

2. **Add Bot Scopes:**
   - OAuth & Permissions → Bot Token Scopes:
     - `chat:write` — send messages
     - `channels:history` — read public channels
     - `groups:history` — read private channels
     - `im:history` — read DMs
     - `reactions:write` — add reactions
     - `files:read` — read shared files (optional)

3. **Install to Workspace:**
   - OAuth & Permissions → Install to Workspace → Allow
   - Copy the **Bot User OAuth Token** (`xoxb-...`)

4. **Connect (in Control UI):**
   ```
   Connect Slack using bot token xoxb-your-token-here.
   Set DM policy to "pairing" and require @mention in channels.
   ```

5. **Invite to channels:**
   In each Slack channel: `/invite @your-bot-name`

### Tips
- The bot only sees channels it's been invited to
- Use threads for back-and-forth to keep channels clean
- Consider a dedicated `#ai-assistant` channel

---

## Discord

### Prerequisites
- A Discord server where you have admin permissions
- Discord Developer account

### Step-by-Step

1. **Create a Discord Application:**
   - Go to [discord.com/developers/applications](https://discord.com/developers/applications)
   - "New Application" → name it → Create

2. **Create a Bot:**
   - Bot section → "Add Bot"
   - Copy the bot **Token**
   - Enable **Message Content Intent** under Privileged Gateway Intents
     (required for the bot to read message content)

3. **Generate Invite URL:**
   - OAuth2 → URL Generator
   - Scopes: `bot`
   - Permissions: `Send Messages`, `Read Message History`, `Add Reactions`, `Use Slash Commands`
   - Copy the generated URL → open it → select your server → Authorize

4. **Connect (in Control UI):**
   ```
   Connect Discord using bot token your-discord-bot-token.
   Set DM policy to "pairing" and require @mention in servers.
   ```

5. **Verify:**
   The bot should appear online in your server.

### Tips
- Create a dedicated channel (e.g., `#openclaw`) for cleaner conversations
- The bot responds to @mentions by default — keeps it non-intrusive
- Discord supports reactions — your bot can react to messages naturally

---

## Channel Comparison

| Feature | Telegram | WhatsApp | Slack | Discord |
|---|---|---|---|---|
| Setup difficulty | Easy | Medium | Medium | Medium |
| Free? | ✅ | ✅ | ✅ (free tier) | ✅ |
| File sharing | ✅ | ✅ | ✅ | ✅ |
| Groups | ✅ | ✅ | ✅ | ✅ |
| Reactions | ✅ | Limited | ✅ | ✅ |
| Session stability | Excellent | Expires | Excellent | Excellent |
| Privacy | Good | Moderate | Workspace | Server |
| Best for | Personal use | Existing contacts | Work teams | Communities |

**Recommendation:** Start with Telegram. Add others as needed.
