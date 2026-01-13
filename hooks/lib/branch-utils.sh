#!/bin/bash

get_branch() {
  git branch --show-current 2>/dev/null
}

get_repo() {
  basename "$PWD"
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
          if ! git ls-remote --heads origin "$wt_branch" 2>/dev/null | grep -q "$wt_branch"; then
            if [ -n "$stale" ]; then
              stale="$stale"$'\n'"$wt_path|$wt_branch"
            else
              stale="$wt_path|$wt_branch"
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

  while IFS='|' read -r wt_path wt_branch; do
    if [ -n "$wt_path" ]; then
      if git worktree remove "$wt_path" 2>/dev/null; then
        printf '  Removed: %s (branch %s was merged)\n' "$wt_path" "$wt_branch"
      else
        printf '  Skipped: %s (has uncommitted changes)\n' "$wt_path"
      fi
    fi
  done <<< "$stale"

  git worktree prune 2>/dev/null
  printf '\n'
}
