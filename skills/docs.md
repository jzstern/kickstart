---
name: docs
description: "Regenerate documentation tables (runs automatically via hook)"
---

# Generate Documentation

This skill regenerates the documentation tables in README.md and CLAUDE.md. It runs automatically via the `auto-docs` hook when plugin components are modified.

You can also run `/docs` manually if needed.

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
```

### Step 3: Update Files

Update content between markers in these files:
- `${CLAUDE_PLUGIN_ROOT}/README.md`
- `${CLAUDE_PLUGIN_ROOT}/CLAUDE.md`

Markers:
- `<!-- kickstart:skills:start -->` / `<!-- kickstart:skills:end -->`
- `<!-- kickstart:agents:start -->` / `<!-- kickstart:agents:end -->`
- `<!-- kickstart:hooks:start -->` / `<!-- kickstart:hooks:end -->`
- `<!-- kickstart:permissions:start -->` / `<!-- kickstart:permissions:end -->`

**Important:** Preserve all content outside the markers.

### Step 4: Report Changes

```
📚 Documentation updated!

README.md:
  - Skills: 3
  - Agents: 4
  - Hooks: 4
  - Permissions: 5 categories

CLAUDE.md:
  - Skills: 3
  - Agents: 4
  - Hooks: 4
```

Warn if any component is missing a description in its frontmatter/JSON.
