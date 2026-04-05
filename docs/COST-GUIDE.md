# Cost Guide — What OpenClaw Actually Costs to Run

## The $6,000 Myth

Some companies charge $3,000–$6,000+ for OpenClaw setup. Here's what it actually costs:

| Component | Cost | Notes |
|---|---|---|
| OpenClaw software | **$0** | Open source, MIT licensed |
| This setup repo | **$0** | Also open source |
| VPS (2 GB RAM) | **~$12/month** | DigitalOcean, Hetzner, etc. |
| Anthropic API | **Pay-as-you-go** | ~$3/1M tokens (Sonnet) |
| OpenAI embeddings | **~$0.02/1M tokens** | For memory search only |
| Brave Search | **Free tier** | 2,000 queries/month |
| Telegram bot | **$0** | Free via BotFather |

**Realistic monthly cost for personal use: $15–$30** (VPS + moderate API usage)

## Model Pricing (as of March 2026)

| Model | Input | Output | Best For |
|---|---|---|---|
| Claude Haiku 4.5 | ~$0.25/1M | ~$1.25/1M | Heartbeats, simple queries |
| Claude Sonnet 4.6 | ~$3/1M | ~$15/1M | Day-to-day tasks (default) |
| Claude Opus 4.6 | ~$15/1M | ~$75/1M | Complex reasoning |

## Cost Optimization Tips

1. **Heartbeats on Haiku** — runs every 30 min, costs pennies/day
2. **lightContext for heartbeats** — only loads HEARTBEAT.md, not full workspace
3. **Memory flush** — prevents expensive re-discussions of forgotten context
4. **Model ladder** — use Sonnet by default, Opus only when needed
5. **Set provider spend limits** — prevents runaway costs from agent loops
6. **Restrict active hours** — no heartbeats from 22:00–08:00

## Monthly Estimate by Usage Level

| Usage | API Cost | VPS | Total |
|---|---|---|---|
| Light (few chats/day) | ~$2–5 | $12 | **~$15–17** |
| Moderate (daily use) | ~$10–20 | $12 | **~$22–32** |
| Heavy (always chatting) | ~$30–60 | $12 | **~$42–72** |
| Power user (multiple agents) | ~$50–100+ | $24 | **~$74–124+** |

Compare that to $6,000 for just the setup. 😉
