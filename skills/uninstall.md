---
name: uninstall
description: Uninstall kickstart plugin while preserving all project-specific configuration and customizations.
---

# Uninstall Kickstart

You are helping the user uninstall the kickstart plugin while preserving their project-specific configuration.

## What Gets Removed vs Preserved

**Removed (Plugin-Owned):**
- Kickstart agents (debugger, security-auditor, test-generator, e2e-runner)
- Kickstart hooks (worktree enforcement, format-on-save, etc.)
- Kickstart rules (comments, testing, typescript)
- Kickstart skills (/init, /update, /docs, /uninstall)
- Base CLAUDE.md loaded by the plugin

**Preserved (Project-Owned):**
- `.claude/CLAUDE.md` - Your project configuration
- `.claude/settings.json` - Your pre-approved commands
- `.github/workflows/` - Your CI/CD workflows
- `playwright.config.ts` - Your test configuration
- `tests/` - Your test files
- All other project files

## Process

### Step 1: Confirm Intent

Use AskUserQuestion to confirm:

**Question**: "Are you sure you want to uninstall kickstart?"

**Options**:
1. **Yes, uninstall** - Remove the plugin but keep all my project configuration
2. **Cancel** - Don't uninstall

If "Cancel", stop here and inform the user that no changes were made.

### Step 2: Check Project Files

Inventory what project files exist that will be preserved:

```bash
ls -la .claude/ 2>/dev/null
ls -la .github/workflows/ 2>/dev/null
ls playwright.config.ts 2>/dev/null
ls -d tests/ 2>/dev/null
```

### Step 3: Offer to Export Rules

First, check if on main/master branch:

```bash
git branch --show-current
```

**If on main/master**, use AskUserQuestion:

**Question**: "You're on the main branch. Copying rules requires a feature branch (the check-worktree hook blocks writes on main). What would you like to do?"

**Options**:
1. **Skip copying, continue uninstall** - Proceed without copying rules
2. **Cancel** - Stop so I can switch branches first

Handle each choice:
- **Skip copying, continue uninstall**: Skip to Step 4
- **Cancel**: Stop here and inform the user that no changes were made

**If NOT on main/master**, use AskUserQuestion:

**Question**: "Would you like to copy kickstart's rules to your project before uninstalling?"

**Options**:
1. **Yes, copy rules** - Copy rules to `.claude/rules/` so they remain after uninstall
2. **No, just uninstall** - Remove everything, I don't need the rules

If "No, just uninstall", skip to Step 4.

If "Yes, copy rules":

Check for existing rule files that would be overwritten:

```bash
ls .claude/rules/comments.md .claude/rules/testing.md .claude/rules/typescript.md 2>/dev/null
```

**If no existing files found**, proceed directly to copying (skip the overwrite dialog).

**If any files exist**, use AskUserQuestion to warn:

**Question**: "The following rule files already exist and will be overwritten: [list files]. Continue?"

**Options**:
1. **Overwrite** - Replace existing files with kickstart defaults
2. **Skip existing** - Only copy rules that don't already exist
3. **Cancel** - Don't copy any rules

Handle each choice:
- **Overwrite**: Proceed to copy all rule files
- **Skip existing**: Proceed to copy only rules that don't already exist
- **Cancel**: Skip to Step 4 without copying any rules

**When proceeding with copy** (no conflicts, Overwrite, or Skip existing):

```bash
mkdir -p .claude/rules
```

Copy rule files based on the user's choice:
- `${CLAUDE_PLUGIN_ROOT}/rules/comments.md` → `.claude/rules/comments.md`
- `${CLAUDE_PLUGIN_ROOT}/rules/testing.md` → `.claude/rules/testing.md`
- `${CLAUDE_PLUGIN_ROOT}/rules/typescript.md` → `.claude/rules/typescript.md`

### Step 4: Uninstall Plugin

Run the uninstall command:

```bash
claude plugin uninstall kickstart
```

### Step 5: Summarize

Tell the user what happened:

**Removed:**
- Kickstart plugin and all its agents, hooks, rules, and skills

**Preserved:**
- List each project file that was preserved (from Step 2)
- If rules were copied, mention `.claude/rules/`

**Note:** Remind the user:
- They can reinstall anytime with `claude plugin install kickstart`
- Their project configuration in `.claude/` will work with any plugins they install
- If they copied rules, those will continue to work locally

## Important

- Never delete project files (`.claude/`, `tests/`, workflows, etc.)
- The uninstall only removes the plugin registration, not project files
- If user wants to completely remove all traces, they would need to manually delete project files
