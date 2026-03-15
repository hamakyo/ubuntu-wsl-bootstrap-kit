#!/usr/bin/env bash
set -euo pipefail

if command -v python3 >/dev/null 2>&1; then
  python3 --version
fi

if command -v node >/dev/null 2>&1; then
  node --version
fi

if command -v npm >/dev/null 2>&1; then
  npm --version
fi
