#!/bin/bash

get_branch() {
  git branch --show-current 2>/dev/null
}

get_repo() {
  basename "$PWD"
}

get_repo_root() {
  git rev-parse --show-toplevel 2>/dev/null
}

is_main_branch() {
  local branch="$1"
  [ "$branch" = "main" ] || [ "$branch" = "master" ]
}

worktree_message() {
  local branch="$1"
  local repo="$2"
  printf 'Create a worktree first:\n\n  git worktree add -b feat/your-feature ../%s-feat-your-feature %s\n  cd ../%s-feat-your-feature\n' "$repo" "$branch" "$repo"
}

is_kickstart_initialized() {
  local root
  root=$(get_repo_root) || return 1
  [ -f "$root/.claude/CLAUDE.md" ]
}
