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

get_stale_worktrees() {
  git fetch --prune origin 2>/dev/null
  local stale=""
  local wt_path=""
  local wt_branch=""

  while IFS= read -r line; do
    if [[ "$line" == "worktree "* ]]; then
      wt_path="${line#worktree }"
    elif [[ "$line" == "branch "* ]]; then
      wt_branch="${line#branch refs/heads/}"
      if ! is_main_branch "$wt_branch"; then
        local remote
        remote=$(git config --get "branch.$wt_branch.remote" 2>/dev/null)
        if [ "$remote" = "origin" ]; then
          local ls_output
          if ls_output=$(git ls-remote --heads origin "$wt_branch" 2>/dev/null); then
            if ! echo "$ls_output" | grep -Fq "refs/heads/$wt_branch"; then
              if [ -n "$stale" ]; then
                stale="$stale"$'\n'"$wt_path"$'\t'"$wt_branch"
              else
                stale="$wt_path"$'\t'"$wt_branch"
              fi
            fi
          fi
        fi
      fi
      wt_path=""
      wt_branch=""
    fi
  done < <(git worktree list --porcelain 2>/dev/null)

  echo "$stale"
}

cleanup_stale_worktrees() {
  local stale
  stale=$(get_stale_worktrees)

  if [ -z "$stale" ]; then
    return 0
  fi

  local count
  count=$(echo "$stale" | wc -l | tr -d ' ')
  printf '\n🧹 Cleaning up %s stale worktree(s)...\n' "$count"

  local current_wt
  current_wt=$(realpath "$PWD" 2>/dev/null || echo "$PWD")

  while IFS=$'\t' read -r wt_path wt_branch; do
    if [ -n "$wt_path" ]; then
      local resolved_path
      resolved_path=$(realpath "$wt_path" 2>/dev/null || echo "$wt_path")
      if [ "$resolved_path" = "$current_wt" ]; then
        printf '  Skipped: %s (current working directory)\n' "$wt_path"
      else
        local err
        if err=$(git worktree remove "$wt_path" 2>&1); then
          printf '  Removed: %s (branch %s deleted from remote)\n' "$wt_path" "$wt_branch"
        else
          printf '  Skipped: %s (%s)\n' "$wt_path" "$err"
        fi
      fi
    fi
  done <<< "$stale"

  git worktree prune 2>/dev/null
  printf '\n'
}
