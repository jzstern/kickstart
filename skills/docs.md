---
name: docs
description: Auto-generate documentation from plugin components. Updates README.md tables for agents, hooks, skills, and permissions.
---

# Generate Documentation

You are updating kickstart documentation by parsing the actual plugin components.

## When to Run

- After adding/removing/modifying agents, hooks, or skills
- After changing permissions in settings.json templates
- Before committing changes to kickstart

## Process

### Step 1: Parse Plugin Components

Read and extract metadata from each component type:

**Agents** (`${CLAUDE_PLUGIN_ROOT}/agents/*.md`):
```bash
ls ${CLAUDE_PLUGIN_ROOT}/agents/*.md
```
For each file, extract `name` and `description` from YAML frontmatter.

**Hooks** (`${CLAUDE_PLUGIN_ROOT}/hooks/*.json`):
```bash
ls ${CLAUDE_PLUGIN_ROOT}/hooks/*.json
```
For each file, extract `name`, `description`, and the `event` type from the hooks array.

**Skills** (`${CLAUDE_PLUGIN_ROOT}/skills/*.md`):
```bash
ls ${CLAUDE_PLUGIN_ROOT}/skills/*.md
```
For each file, extract `name` and `description` from YAML frontmatter.

**Permissions** (`${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/settings.json`):
Read the `permissions.allow` array and categorize by type (git, gh, package manager, etc.)

### Step 2: Generate Markdown Tables

Create tables in this format:

**Agents:**
```markdown
| Agent | Description |
|-------|-------------|
| `agent-name` | Description from frontmatter |
```

**Hooks:**
```markdown
| Hook | Event | Description |
|------|-------|-------------|
| `hook-name` | SessionStart | Description from JSON |
```

**Skills:**
```markdown
| Skill | Description |
|-------|-------------|
| `/skill-name` | Description from frontmatter |
```

**Permissions (grouped):**
```markdown
| Category | Commands |
|----------|----------|
| Git | `status`, `branch`, `log`, ... |
| GitHub CLI | `pr`, `issue`, `run`, ... |
```

### Step 3: Update README.md

Read `${CLAUDE_PLUGIN_ROOT}/README.md` and replace content between markers:

```markdown
<!-- kickstart:agents:start -->
... auto-generated content ...
<!-- kickstart:agents:end -->
```

Markers to update:
- `<!-- kickstart:agents:start -->` / `<!-- kickstart:agents:end -->`
- `<!-- kickstart:hooks:start -->` / `<!-- kickstart:hooks:end -->`
- `<!-- kickstart:skills:start -->` / `<!-- kickstart:skills:end -->`
- `<!-- kickstart:permissions:start -->` / `<!-- kickstart:permissions:end -->`

**Important:** Preserve all content outside the markers. Only replace content between marker pairs.

### Step 4: Update Plugin CLAUDE.md (if needed)

If `${CLAUDE_PLUGIN_ROOT}/CLAUDE.md` has markers, update those sections too.

### Step 5: Report Changes

Summarize what was updated:
- Number of agents documented
- Number of hooks documented
- Number of skills documented
- Number of permission categories documented

If any component is missing a description, warn about it.

## For User Projects

When run in a user project (not the kickstart repo itself), this skill can update the project's `.claude/CLAUDE.md` to document available kickstart features:

1. Check if `.claude/CLAUDE.md` exists
2. Look for `<!-- kickstart:features:start -->` marker
3. Insert/update a summary of available agents, hooks, and skills

## Output Format

After running, display:

```
📚 Documentation updated!

Agents: 4 documented
  - debugger
  - e2e-runner
  - security-auditor
  - test-generator

Hooks: 4 documented
  - session-start-warning (SessionStart)
  - block-main-commits (PreToolUse)
  - check-worktree (PreToolUse)
  - format-on-save (PostToolUse)

Skills: 3 documented
  - /init
  - /update
  - /docs

Permissions: 6 categories
  - Git (18 commands)
  - GitHub CLI (6 commands)
  - Package Manager (7 commands)
  - Playwright (1 command)
  - Biome (1 command)
```
