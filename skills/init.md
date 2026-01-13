---
name: init
description: Initialize project configuration with kickstart defaults. Scaffolds .claude/CLAUDE.md and GitHub workflows.
---

# Initialize Kickstart Configuration

You are setting up a new project with kickstart configuration.

## Process

### Step 1: Detect or Ask for Stack

First, check if the project has identifiable technology markers:

```bash
# Check for package.json
cat package.json 2>/dev/null | head -50
```

Look for:
- **SvelteKit**: `@sveltejs/kit` in dependencies
- **Next.js**: `next` in dependencies
- **Remix**: `@remix-run/react` in dependencies
- **Astro**: `astro` in dependencies
- **Express/Node API**: `express` or no framework

If unclear, use AskUserQuestion to ask:
- Which framework? (SvelteKit, Next.js, Remix, Astro, Node API, Other)
- Package manager? (bun, pnpm, npm, yarn)

### Step 2: Create Project Configuration

Create `.claude/CLAUDE.md` with project-specific information.

Use the appropriate template from `${CLAUDE_PLUGIN_ROOT}/templates/`:
- `sveltekit/CLAUDE.md.template` for SvelteKit projects
- `base/CLAUDE.md.template` for other projects

Replace template variables:
- `{{PROJECT_NAME}}` - Directory name or ask user
- `{{DESCRIPTION}}` - Ask user for brief description
- `{{PACKAGE_MANAGER}}` - Detected or asked
- `{{DEV_COMMAND}}` - e.g., `bun run dev`
- `{{BUILD_COMMAND}}` - e.g., `bun run build`
- `{{TEST_COMMAND}}` - e.g., `bun run test`
- `{{LINT_COMMAND}}` - e.g., `bun run lint`

### Step 3: Copy GitHub Workflows

Create `.github/workflows/` directory and copy workflow templates:

```bash
mkdir -p .github/workflows
```

Copy from `${CLAUDE_PLUGIN_ROOT}/templates/<stack>/github/workflows/` if they exist.

### Step 4: Create Rules Directory

```bash
mkdir -p .claude/rules
```

Note: Rules are provided by the kickstart plugin and don't need to be copied into the project.

### Step 5: Confirm Setup

Summarize what was created:
- `.claude/CLAUDE.md` - Project configuration
- `.github/workflows/` - CI workflows (if copied)

Remind the user:
- Run `/update` periodically to get config updates
- Edit `.claude/CLAUDE.md` to add project-specific notes
- The kickstart plugin provides agents, hooks, and base rules automatically

## Important

- Do NOT copy the plugin's base CLAUDE.md into the project - it's loaded automatically
- Project CLAUDE.md should only contain project-specific information
- Keep the project config minimal - let the plugin handle common rules
