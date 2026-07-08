#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
install_dir="${RM_SHOTGUN_INSTALL_DIR:-$HOME/.shell/rm-shotgun}"

mkdir -p "$install_dir/lib" "$install_dir/bin"
cp "$script_dir/lib/rm-shotgun-guard.sh" "$install_dir/lib/"
cp "$script_dir/lib/rm-shotgun-toggle.zsh" "$install_dir/lib/"
cp "$script_dir/bin/rm-shotgun-pack.sh" "$install_dir/bin/"
chmod +x "$install_dir/bin/rm-shotgun-pack.sh"

cat <<EOF
[rm-shotgun install] installed to: $install_dir

Add these lines to ~/.zshrc or ~/.bashrc:

# rm-shotgun
[ -f "\$HOME/.shell/rm-shotgun/lib/rm-shotgun-guard.sh" ] && source "\$HOME/.shell/rm-shotgun/lib/rm-shotgun-guard.sh"
[ -n "\${ZSH_VERSION:-}" ] && [ -f "\$HOME/.shell/rm-shotgun/lib/rm-shotgun-toggle.zsh" ] && source "\$HOME/.shell/rm-shotgun/lib/rm-shotgun-toggle.zsh"

Then reload your shell.

Optional hourly cron packer:
  17 * * * * $install_dir/bin/rm-shotgun-pack.sh >/dev/null 2>&1
EOF
