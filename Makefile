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
ps-podman: ## Podman ps in normal mode
	docker ps -s --format "table {{.ID}}\t{{.Status}}\t{{.Names}}\t{{.Size}}\t{{.Ports}}"
run-ci: ## Start CI
	docker compose run --user=root --rm web docker/linter.sh
run-tests: ## Start testing
	docker compose run -u root --rm web pytest tests -v -rP --no-cov
##############################################################################################
migrate: ## Apply database migrations
	docker compose run -u root --rm web clickhouse-migrations --migrations-dir=migrations --db-host=clickhouse --db-user=default --db-password=default --db-name=skynet
##############################################################################################
docs-gen: ## Build RST documentation
	docker compose run --user=root --rm web sh -c "sphinx-apidoc -f -o ./docs/pages/server/ ./server/ -d 2 --follow-links --module-first --separate -a --private && sphinx-apidoc -f -o ./docs/pages/tests/ ./tests/ -d 2 --follow-links --module-first --separate -a --private"
docs-build: ## Build project documentation
	docker compose run z--user=root --rm web sh -c "sphinx-build -M html ./docs ./docs/_build"