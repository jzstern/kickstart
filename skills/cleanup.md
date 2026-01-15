---
name: cleanup
description: Remove git worktrees for merged branches that were tracking origin.
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
1. The branch was set up to track origin (pushed with `-u`)
2. The branch no longer exists on remote (exit code 2)
3. The branch tip is an ancestor of the default branch (merged)

```bash
git config --get branch.<name>.remote  # must be "origin"
git ls-remote --exit-code --heads origin <branch-name>  # exit 2 = not found
git merge-base --is-ancestor <branch-name> origin/main
```

A worktree is "stale" if ALL conditions are met:
- The branch was tracking origin (proof it was pushed)
- The branch no longer exists on the remote
- The branch has been merged into the default branch
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

- Only removes worktrees for branches that were tracking origin AND merged
- Branches pushed without `-u` flag are not auto-cleaned (use `git worktree remove` manually)
- Network errors during `ls-remote` are treated as "keep" (fail-safe)
- Uncommitted work is never lost (worktrees with changes are skipped)
- The main worktree is never removed
