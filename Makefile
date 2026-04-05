# OpenClaw VPS Setup — Common Commands
# Usage: make <target>

.PHONY: help setup start stop restart logs status health audit update backup shell

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

setup: ## First-time setup: copy .env and build
	@test -f .env || (cp .env.example .env && echo "✅ Created .env — edit it with your API keys: nano .env")
	@test -f .env && docker compose build

start: ## Start OpenClaw Gateway
	docker compose up -d
	@echo "✅ Gateway starting... Check logs: make logs"

stop: ## Stop OpenClaw Gateway
	docker compose down

restart: ## Restart OpenClaw Gateway
	docker compose restart

logs: ## Tail Gateway logs
	docker compose logs -f openclaw

status: ## Check Gateway status
	docker compose exec openclaw openclaw status

health: ## Health check
	docker compose exec openclaw openclaw health

audit: ## Run security audit
	docker compose exec openclaw openclaw security audit --deep

update: ## Update OpenClaw inside container
	docker compose exec openclaw openclaw update
	docker compose restart
	@echo "✅ Updated and restarted"

backup: ## Create a backup
	docker compose exec openclaw openclaw backup create
	@echo "✅ Backup created"

shell: ## Open a shell inside the container
	docker compose exec openclaw bash

doctor: ## Run diagnostics
	docker compose exec openclaw openclaw doctor

token: ## Show Gateway auth token (from first-run logs)
	@docker compose logs openclaw 2>&1 | grep -i "token" | tail -5

tunnel-hint: ## Print SSH tunnel command
	@echo "Run this on your LOCAL machine:"
	@echo "  ssh -N -L 18789:127.0.0.1:18789 openclaw@YOUR_VPS_IP"
	@echo ""
	@echo "Then open: http://127.0.0.1:18789/"
