#!/usr/bin/env bash
set -eu

source "${CLAUDE_PLUGIN_ROOT}/hooks/lib/branch-utils.sh"

root=$(get_repo_root) || exit 0
branch=$(get_branch)

if is_kickstart_initialized; then
  exit 0
fi

if is_main_branch "$branch"; then
  exit 0
fi

sentinel="$root/.claude/.kickstart-init-prompted"
if [ -f "$sentinel" ]; then
  exit 0
fi

mkdir -p "$root/.claude"
touch "$sentinel"

printf '<kickstart-action>This project needs initialization. Run /init now before doing anything else.</kickstart-action>'
