---
name: cleanup
description: Remove git worktrees for merged branches no longer on remote.
---

# Cleanup Stale Worktrees

You are cleaning up git worktrees whose branches have been merged into the default branch and deleted from the remote.

## Process

### Step 1: Fetch Latest Remote State

```bash
git fetch --prune origin
```

### Step 2: Find Stale Worktrees

List all worktrees and check if their branches are stale:

```bash
git worktree list --porcelain
```

For each worktree (except the main one), check if:
1. The branch no longer exists on remote (exit code 2 from `ls-remote`)
2. The branch is an ancestor of the default branch (merged)
3. The branch tip differs from the default branch tip (not newly created)

```bash
git ls-remote --exit-code --heads origin <branch-name>  # exit 2 = not found
git merge-base --is-ancestor <branch-name> origin/main
git rev-parse <branch-name>  # compare with origin/main
```

A worktree is "stale" if ALL conditions are met:
- The branch no longer exists on the remote
- The branch has been merged into the default branch
- The branch tip is not at the same commit as the default branch (skips newly created branches)
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
🧹 Cleaning up 2 stale worktree(s)...
  Removed: ../myproject-feat-add-login (branch feat/add-login merged)
  Removed: ../myproject-fix-typo (branch fix/typo merged)
```

If a worktree cannot be removed:

```
🧹 Cleaning up 1 stale worktree(s)...
  Skipped: ../myproject-feat-wip (fatal: '../myproject-feat-wip' contains modified or untracked files, use --force to delete it)
```

## Notes

- Only removes worktrees for branches that are merged AND deleted from remote
- Works for branches pushed with or without `-u` flag
- Newly created branches (at same commit as main) are never removed
- Network errors during `ls-remote` are treated as "keep" (fail-safe)
- Uncommitted work is never lost (worktrees with changes are skipped)
- The main worktree is never removed
