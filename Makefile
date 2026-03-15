SHELL := /usr/bin/env bash

.PHONY: setup verify lint

setup:
	bash scripts/bootstrap.sh

verify:
	@bash -euo pipefail -c '\
	for cmd in git curl python3 pip docker node npm; do \
	  if command -v "$$cmd" >/dev/null 2>&1; then \
	    echo "[OK] $$cmd"; \
	  else \
	    echo "[MISSING] $$cmd"; \
	    missing=1; \
	  fi; \
	done; \
	if [[ $${missing:-0} -ne 0 ]]; then \
	  echo "[ERROR] Some required tools are missing."; \
	  exit 1; \
	fi'

lint:
	@bash -euo pipefail -c '\
	if command -v shellcheck >/dev/null 2>&1; then \
	  shellcheck scripts/bootstrap.sh .devcontainer/postCreate.sh; \
	else \
	  echo "[INFO] shellcheck is not installed. Install: sudo apt-get install -y shellcheck"; \
	fi; \
	if command -v ansible-lint >/dev/null 2>&1; then \
	  ansible-lint ansible/site.yml; \
	else \
	  echo "[INFO] ansible-lint is not installed. Install: pipx install ansible-lint"; \
	fi'
