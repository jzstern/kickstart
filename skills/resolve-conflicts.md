---
name: resolve-conflicts
description: Detect and resolve merge conflicts with the base branch. Can be run proactively before pushing or to fix existing conflicts.
---

# Resolve Merge Conflicts

You are helping the user detect and resolve merge conflicts intelligently.

## Step 1: Assess Current State

Check if there are existing conflicts in the working directory:

```bash
git status
```

Look for:
- "Unmerged paths" - Active conflicts that need resolution
- Clean working directory - No current conflicts, check for potential conflicts

## Step 2: Handle Existing Conflicts

If there are unmerged paths (active conflicts):

1. List all conflicted files:
   ```bash
   git diff --name-only --diff-filter=U
   ```

2. For each conflicted file:
   - Read the file to see conflict markers
   - Analyze both sides of each conflict
   - Determine resolution strategy (auto-resolve or ask user)

3. Apply resolutions using Edit tool

4. Stage resolved files:
   ```bash
   git add <file>
   ```

5. Verify no markers remain:
   ```bash
   grep -r "<<<<<<" . --include="*.ts" --include="*.js" --include="*.tsx" --include="*.jsx" --include="*.json" --include="*.md" 2>/dev/null || echo "No conflict markers found"
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

3. Check for divergence:
   ```bash
   git log --oneline origin/$BASE..HEAD | head -5
   git log --oneline HEAD..origin/$BASE | head -5
   ```

4. If both have commits, test for conflicts:
   ```bash
   git merge --no-commit --no-ff origin/$BASE 2>&1
   ```

5. If conflicts detected, list them and ask user:

   Use AskUserQuestion:
   - "Resolve conflicts now" - Proceed with merge and resolution
   - "View conflicts first" - Show detailed conflict preview
   - "Cancel" - Abort merge and return to clean state

6. If user cancels:
   ```bash
   git merge --abort
   ```

## Step 4: Resolution Strategies

### Auto-Resolvable (resolve without asking)

| Conflict Type | Resolution |
|--------------|------------|
| Import ordering | Merge both, sort alphabetically |
| Whitespace only | Take cleaner version |
| Non-overlapping additions | Keep both in logical order |
| Deleted vs unchanged | Take deletion |
| Added vs unchanged | Take addition |

### Requires User Input

| Conflict Type | Action |
|--------------|--------|
| Logic changes | Present both options, ask preference |
| API signature changes | Explain implications, ask user |
| Business rule changes | Show context, require explicit choice |
| Both modified same line | Cannot auto-resolve |

## Step 5: Conflict Resolution

For each conflict:

1. **Read context** - Understand what both changes do
2. **Check history** - `git log -p --follow -1 -- <file>` for each branch
3. **Decide approach**:
   - If auto-resolvable → apply fix
   - If complex → present options with AskUserQuestion

Example question format:

```
Conflict in `src/utils/calculate.ts` line 45:

**Current branch (HEAD):**
```typescript
const total = items.reduce((sum, item) => sum + item.price, 0);
```

**Incoming (main):**
```typescript
const total = items.reduce((acc, item) => acc + item.cost, 0);
```

This appears to be a rename of both the accumulator variable and the price field. Which version should we keep?
```

Options:
- Keep current branch version (price field)
- Keep incoming version (cost field)
- Let me edit manually

## Step 6: Complete Resolution

After all conflicts are resolved:

1. Verify clean state:
   ```bash
   git diff --check
   git status
   ```

2. Show summary of changes:
   ```bash
   git diff --staged --stat
   ```

3. Ask user to confirm:
   - "Complete merge (create merge commit)"
   - "Review changes first (git diff --staged)"
   - "Abort merge"

4. If completing:
   ```bash
   git commit -m "merge: resolve conflicts with $(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)"
   ```

## Tips for Users

- Run `/resolve-conflicts` before pushing to catch issues early
- The hook will also warn you automatically before push
- Complex conflicts always require your explicit approval
- Use "View conflicts first" to understand changes before resolving
