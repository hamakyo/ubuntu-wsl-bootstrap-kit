#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APT_LIST_FILE="$ROOT_DIR/packages/apt.txt"

if [[ "${EUID}" -eq 0 ]]; then
  echo "[ERROR] Run as a regular user. Do not run this script with sudo."
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "[ERROR] apt-get is required. This script supports Ubuntu/WSL Ubuntu."
  exit 1
fi

sudo apt-get update

if [[ -f "$APT_LIST_FILE" ]]; then
  mapfile -t packages < <(grep -Ev '^\s*(#|$)' "$APT_LIST_FILE")
else
  packages=(curl git ca-certificates gnupg lsb-release)
fi

if [[ "${#packages[@]}" -gt 0 ]]; then
  sudo apt-get install -y --no-install-recommends "${packages[@]}"
fi

echo "[INFO] Bootstrap complete."
echo "[INFO] Next steps:"
echo "  1) make verify"
echo "  2) Open project in VS Code Dev Container"
