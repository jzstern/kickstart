---
name: cleanup
description: Remove git worktrees for branches that have been merged or deleted from remote.
---

# Cleanup Stale Worktrees

You are cleaning up git worktrees whose branches no longer exist on the remote (typically after a PR was merged and the branch was deleted).

## Process

### Step 1: Fetch Latest Remote State

```bash
git fetch --prune origin
```

### Step 2: Find Stale Worktrees

List all worktrees and check if their branches still exist on remote:

```bash
git worktree list --porcelain
```

For each worktree (except the main one), check if its branch exists on remote:

```bash
git ls-remote --heads origin <branch-name>
```

A worktree is "stale" if:
- It tracks a branch (not detached HEAD)
- That branch no longer exists on the remote
- It's not the main/master branch

### Step 3: Remove Stale Worktrees

For each stale worktree found:

```bash
git worktree remove <worktree-path>
```

If the worktree has uncommitted changes, warn the user and skip it (don't use `--force`).

### Step 4: Prune Worktree Metadata

Clean up any stale worktree administrative files:

```bash
git worktree prune
```

### Step 5: Report Results

Summarize what was cleaned up:
- Number of stale worktrees removed
- Paths that were removed
- Any worktrees skipped due to uncommitted changes

## Example Output

```
Cleaned up 2 stale worktrees:
  - ../myproject-feat-add-login (branch feat/add-login was merged)
  - ../myproject-fix-typo (branch fix/typo was merged)

Skipped 1 worktree with uncommitted changes:
  - ../myproject-feat-wip
```

## Notes

- This skill only removes worktrees for branches deleted from remote
- Local-only branches are not touched
- Uncommitted work is never lost (worktrees with changes are skipped)
- The main worktree is never removed
