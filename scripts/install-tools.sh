#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
data_dir="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/dotfiles3"
mkdir -p "$data_dir/tools"
cp "$repo_dir/tools/package.json" "$repo_dir/tools/package-lock.json" "$data_dir/tools/"
npm ci --prefix "$data_dir/tools" --no-audit --no-fund
if [[ ! -x "$data_dir/python/bin/python" ]]; then python3 -m venv "$data_dir/python"; fi
"$data_dir/python/bin/python" -m pip install -r "$repo_dir/tools/requirements.txt"
