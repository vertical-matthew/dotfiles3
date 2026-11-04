#!/usr/bin/env bash
set -euo pipefail
repo_dir="$(cd "$(dirname "$0")/.." && pwd)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
backup_root="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles3-backups"
case "${1:-}" in
  --restore)
    backup_dir="${2:-}"
    if [[ -z "$backup_dir" ]]; then
      [[ -f "$backup_root/latest" ]] || { echo 'No local backup recorded.'; exit 1; }
      IFS= read -r backup_dir < "$backup_root/latest"
    fi
    [[ "$backup_dir" == "$backup_root/"* && -d "$backup_dir/nvim" ]] || { echo 'Invalid backup directory'; exit 1; }
    saved_dir="$(mktemp -d "$backup_root/before-restore.XXXXXX")"
    if [[ -e "$config_dir" || -L "$config_dir" ]]; then mv "$config_dir" "$saved_dir/nvim"; fi
    cp -a "$backup_dir/nvim" "$config_dir"
    echo "Restored $backup_dir/nvim; previous configuration retained at $saved_dir/nvim"
    exit 0 ;;
  --deps|'') ;;
  *) echo 'Usage: bash scripts/install.sh [--deps | --restore [backup-directory]]'; exit 1 ;;
esac
if [[ "${1:-}" == '--deps' ]]; then
  command -v brew >/dev/null || { echo 'Install Homebrew first: https://brew.sh'; exit 1; }
  brew install neovim ripgrep fd node tree-sitter-cli pyright ruff stylua lua-language-server prettier
  brew upgrade neovim
fi
command -v nvim >/dev/null || { echo 'Install Neovim 0.12+ or rerun with --deps on macOS.'; exit 1; }
nvim --clean --headless '+lua if vim.fn.has("nvim-0.12") == 0 then vim.cmd("cquit 1") end' +qa
for binary in git rg fd tree-sitter cc make; do
  command -v "$binary" >/dev/null || { echo "Missing $binary; install dependencies first."; exit 1; }
done
mkdir -p "$(dirname "$config_dir")" "$backup_root"
if [[ ! -L "$config_dir" || "$(readlink "$config_dir")" != "$repo_dir/nvim" ]]; then
  if [[ -e "$config_dir" || -L "$config_dir" ]]; then
    backup_dir="$(mktemp -d "$backup_root/pre-dotfiles3.XXXXXX")"
    mv "$config_dir" "$backup_dir/nvim"
    printf '%s\n' "$backup_dir" > "$backup_root/latest"
    echo "Original configuration preserved at $backup_dir/nvim"
  fi
  ln -s "$repo_dir/nvim" "$config_dir"
fi
bash "$repo_dir/scripts/install-tools.sh"
nvim --headless '+Lazy! restore' +qa
nvim --headless '+lua require("nvim-treesitter").install({"lua", "vim", "vimdoc", "query", "python", "bash", "json", "javascript", "typescript", "tsx", "html", "css", "markdown", "markdown_inline", "swift", "php", "php_only"}):wait(300000)' +qa
DOTFILES3_VERIFY="$repo_dir/scripts/verify.lua" nvim --headless '+lua local ok, err = pcall(dofile, vim.env.DOTFILES3_VERIFY); if not ok then print(err); vim.cmd("cquit 1") end' +qa
echo "Installed. Open: nvim $repo_dir/README.md"
echo "Rollback: bash $repo_dir/scripts/install.sh --restore"
