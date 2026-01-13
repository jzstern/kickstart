---
name: resolve-conflicts
description: Automatically detect and resolve merge conflicts with the base branch. Run proactively before pushing or to fix existing conflicts.
---

# Resolve Merge Conflicts

Automatically detect and resolve merge conflicts.

## Step 1: Assess Current State

Check if there are existing conflicts in the working directory:

```bash
git status
```

Look for:
- "Unmerged paths" - Active conflicts that need resolution
- Clean working directory - Check for potential conflicts with base branch

## Step 2: Handle Existing Conflicts

If there are unmerged paths (active conflicts):

1. List all conflicted files:
   ```bash
   git diff --name-only --diff-filter=U
   ```

2. For each conflicted file:
   - Read the file to see conflict markers
   - Analyze both sides of each conflict
   - Apply automatic resolution (see strategies below)

3. Edit files to resolve conflicts - remove markers and keep resolved content

4. Stage resolved files:
   ```bash
   git add <file>
   ```

5. Verify no markers remain:
   ```bash
   grep -r "<<<<<<" . --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" --include="*.json" --include="*.md" 2>/dev/null || echo "Clean"
   ```

6. Complete the merge:
   ```bash
   git commit -m "merge: resolve conflicts with $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)"
   ```

## Step 3: Check for Potential Conflicts (if no active conflicts)

If working directory is clean, check if the branch would conflict with base:

1. Get current and base branch:
   ```bash
   CURRENT=$(git branch --show-current)
   BASE=$(git remote show origin 2>/dev/null | grep 'HEAD branch' | cut -d' ' -f5 || echo "main")
   echo "Current: $CURRENT, Base: $BASE"
   ```

2. Fetch latest:
   ```bash
   git fetch origin
   ```

3. Attempt merge:
   ```bash
   git merge --no-commit --no-ff origin/$BASE 2>&1
   ```

4. If conflicts detected, resolve them automatically using strategies below

5. If no conflicts, complete merge:
   ```bash
   git commit -m "merge: sync with $BASE"
   ```

6. If already up to date, report "No conflicts - branch is up to date with $BASE"

## Automatic Resolution Strategies

| Conflict Type | Resolution |
|--------------|------------|
| Import ordering | Merge both import sets, deduplicate, sort alphabetically |
| Whitespace only | Take cleaner/better formatted version |
| Non-overlapping additions | Keep both in logical order |
| Deleted vs unchanged | Take the deletion (code cleanup wins) |
| Added vs unchanged | Take the addition |
| Both modified same line | Analyze intent - take most complete version |
| Type/interface changes | Take version with more complete types |
| Function signature changes | Take version that matches existing call sites |

## Resolution Guidelines

When both sides have meaningful changes:

1. **Check commit messages** for context on why changes were made
2. **Prefer completeness** - take the version with more functionality
3. **Match patterns** - align with existing codebase conventions
4. **Shared code** - prefer base branch for utilities others depend on
5. **Feature code** - prefer current branch for feature-specific changes

## Output

After resolution, report:
- Number of files resolved
- Brief summary of what was merged
- Confirmation that no conflict markers remain

Example:
```
Resolved 3 conflicts:
- src/utils/api.ts: merged import statements
- src/components/Button.tsx: kept both style additions
- package.json: merged dependencies

No conflict markers remaining. Ready to push.
```
