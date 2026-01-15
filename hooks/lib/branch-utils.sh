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

get_default_branch() {
  local ref
  ref=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null) || true
  if [ -n "$ref" ]; then
    printf '%s\n' "${ref#refs/remotes/origin/}"
    return 0
  fi

  if git show-ref --verify --quiet refs/remotes/origin/main 2>/dev/null; then
    printf '%s\n' main
    return 0
  fi
  if git show-ref --verify --quiet refs/remotes/origin/master 2>/dev/null; then
    printf '%s\n' master
    return 0
  fi

  printf '%s\n' main
}

was_tracking_origin() {
  local branch="$1"
  local remote
  remote=$(git config --get "branch.$branch.remote" 2>/dev/null)
  [ "$remote" = "origin" ]
}

is_branch_merged() {
  local branch="$1"
  local default_branch="$2"
  git merge-base --is-ancestor "$branch" "origin/$default_branch" 2>/dev/null
}

is_stale_branch() {
  local branch="$1"
  local default_branch="$2"
  was_tracking_origin "$branch" && is_branch_merged "$branch" "$default_branch"
}

get_stale_worktrees() {
  git fetch --prune origin 2>/dev/null
  local stale=""
  local wt_path=""
  local wt_branch=""
  local default_branch
  default_branch=$(get_default_branch)

  while IFS= read -r line; do
    if [[ "$line" == "worktree "* ]]; then
      wt_path="${line#worktree }"
    elif [[ "$line" == "branch "* ]]; then
      wt_branch="${line#branch refs/heads/}"
      if ! is_main_branch "$wt_branch"; then
        local ls_exit_code
        git ls-remote --exit-code --heads origin "$wt_branch" >/dev/null 2>&1
        ls_exit_code=$?

        if [ "$ls_exit_code" -eq 2 ]; then
          if is_stale_branch "$wt_branch" "$default_branch"; then
            if [ -n "$stale" ]; then
              stale="$stale"$'\n'"$wt_path"$'\t'"$wt_branch"
            else
              stale="$wt_path"$'\t'"$wt_branch"
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
          printf '  Removed: %s (branch %s merged)\n' "$wt_path" "$wt_branch"
        else
          printf '  Skipped: %s (%s)\n' "$wt_path" "$err"
        fi
      fi
    fi
  done <<< "$stale"

  git worktree prune 2>/dev/null
  printf '\n'
}
