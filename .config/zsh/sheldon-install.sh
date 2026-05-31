#!/usr/bin/env bash
# Fetch sheldon plugins and regenerate the source cache.
#
# Idempotent: re-running always brings every plugin up to date and rebuilds
# the cache, so it doubles as recovery when ~/.local/share/sheldon/repos is
# emptied (symptom: "command not found: zsh-defer" on shell startup).
#
# Usage: .config/zsh/sheldon-install.sh
set -euo pipefail

# Match .zshrc's `SHELDON_CONFIG_DIR="$ZDOTDIR"` (= ~/.config/zsh).
config_dir="${SHELDON_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/zsh}"
cache="$config_dir/sheldon.zsh"

if ! command -v sheldon >/dev/null 2>&1; then
  echo "error: sheldon not found in PATH" >&2
  exit 1
fi

if [[ ! -r "$config_dir/plugins.toml" ]]; then
  echo "error: $config_dir/plugins.toml not found" >&2
  exit 1
fi

echo "==> sheldon lock --update ($config_dir)"
sheldon --config-dir "$config_dir" lock --update

echo "==> regenerate cache: $cache"
rm -f "$cache" "$cache.zwc"
sheldon --config-dir "$config_dir" source >"$cache"

# Pre-compile so the first shell startup skips the "Compiling ..." step.
# (.zshrc's ensure_zcompiled would otherwise do it lazily.)
if command -v zsh >/dev/null 2>&1; then
  zsh -fc "zcompile -- '$cache'" 2>/dev/null || true
fi

echo "==> done. reload with: exec zsh"
