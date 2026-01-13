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
