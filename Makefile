#!/usr/bin/env bash
# Tab sign surrounded by two dots: .	.

THIS_FILE := $(lastword $(MAKEFILE_LIST))
.PHONY: help

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


build: ## Building the project
	docker compose -f docker-compose.yml build
start-dev: ## Start service
	docker compose -f docker-compose.yml up --force-recreate --remove-orphans
stop: ## Stop service
	docker compose -f docker-compose.yml down
ps-docker: ## Podman ps in normal mode
	docker ps -s --format "table {{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Size}}\t{{.Ports}}"
makemigrations:
	docker compose -f docker-compose.yml run -u root --rm web diesel migration generate --diff-schema
migrate: ## Apply database migrations
	docker compose -f docker-compose.yml run -u root --rm web diesel migration run
