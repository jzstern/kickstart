---
name: init
description: Initialize project configuration with kickstart defaults. Scaffolds .claude/CLAUDE.md, GitHub workflows, Playwright E2E testing, and deployment configs.
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
- `{{PACKAGE_MANAGER_X}}` - The exec command (bunx, npx, pnpx)
- `{{DEV_COMMAND}}` - e.g., `bun run dev`
- `{{BUILD_COMMAND}}` - e.g., `bun run build`
- `{{TEST_COMMAND}}` - e.g., `bun run test`
- `{{LINT_COMMAND}}` - e.g., `bun run lint`

### Step 3: Configure Permissions

Create `.claude/settings.json` with pre-approved commands so Claude can run development tasks automatically.

Use the appropriate template:
- For SvelteKit: Copy `${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/settings.json`
- For other stacks: Use `${CLAUDE_PLUGIN_ROOT}/templates/base/settings.json.template`
  - Replace `{{PACKAGE_MANAGER}}` with the package manager (bun, npm, pnpm)
  - Replace `{{PACKAGE_MANAGER_X}}` with the exec command (bunx, npx, pnpx)

This allows Claude to automatically run:
- Package installation (`bun add`, `npm install`, etc.)
- Dev server, build, lint, and test commands
- Playwright browser installation and test execution
- GitHub CLI read commands (`gh pr view`, `gh api`, `gh issue view`, etc.)

### Step 4: Copy GitHub Workflows

Create `.github/workflows/` directory and copy workflow templates:

```bash
mkdir -p .github/workflows
```

Copy from `${CLAUDE_PLUGIN_ROOT}/templates/<stack>/github/workflows/` if they exist.

### Step 5: Set Up Playwright E2E Testing

For web projects (SvelteKit, Next.js, Remix, Astro):

1. Install Playwright: `{{PACKAGE_MANAGER}} add -D @playwright/test`
2. Install browsers: `{{PACKAGE_MANAGER_X}} playwright install chromium`
3. Copy config from `${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/playwright.config.ts` or `base/playwright.config.ts.template`
4. Create `tests/` directory with example from `${CLAUDE_PLUGIN_ROOT}/templates/shared/tests/example.spec.ts`
5. Add `"test:e2e": "playwright test"` script to package.json if not present

### Step 6: Create Rules Directory

```bash
mkdir -p .claude/rules
```

Note: Rules are provided by the kickstart plugin and don't need to be copied into the project.

### Step 7: Install Companion Plugins

Add the official marketplace and install all companion plugins:

```bash
claude plugin marketplace add anthropics/claude-code-plugins
claude plugin install github@claude-plugins-official
claude plugin install code-simplifier@claude-plugins-official
claude plugin install code-review@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install typescript-lsp@claude-plugins-official
```

### Step 8: Configure Deployment (Optional)

Use AskUserQuestion to ask about deployment platform:

**Question**: "Would you like to configure Vercel deployment?"

**Options**:
1. **Yes** - Create vercel.json for zero-config deployments
2. **Skip** - Configure deployment later

**If "Yes"**, create `vercel.json` using template from `${CLAUDE_PLUGIN_ROOT}/templates/shared/deploy/vercel.json.template`.

See `${CLAUDE_PLUGIN_ROOT}/templates/shared/deploy/README.md` for framework presets and template variables.

### Step 9: Confirm Setup

Summarize what was created:
- `.claude/CLAUDE.md` - Project configuration
- `.claude/settings.json` - Pre-approved commands for automatic execution
- `.github/workflows/` - CI workflows (if copied)
- `playwright.config.ts` - Playwright E2E test configuration
- `tests/` - E2E test directory with example test
- `vercel.json` - Vercel deployment config (if configured)

Remind the user:
- Run `bun run test:e2e` (or equivalent) to run E2E tests
- Run `/update` periodically to get config updates
- Edit `.claude/CLAUDE.md` to add project-specific notes
- The kickstart plugin provides agents, hooks, and base rules automatically
- For SvelteKit + Vercel, consider `@sveltejs/adapter-vercel` for advanced features

## Important

- Do NOT copy the plugin's base CLAUDE.md into the project - it's loaded automatically
- Project CLAUDE.md should only contain project-specific information
- Keep the project config minimal - let the plugin handle common rules
