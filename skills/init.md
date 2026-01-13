---
name: init
description: Initialize project with kickstart config. Use --plugins to install companion plugins, --vercel for Vercel deployment config.
args: "[--plugins] [--vercel]"
---

# Initialize Kickstart Configuration

You are setting up a new project with kickstart configuration. This process is fully automated - detect everything automatically without asking questions.

## Flags

- `--plugins` - Install recommended companion plugins after setup
- `--vercel` - Configure Vercel deployment

## Process

### Step 1: Auto-Detect Stack

Detect the framework and package manager automatically. Do NOT ask the user - infer from files.

**Detect package manager** (check in order):
1. `bun.lockb` exists → bun
2. `pnpm-lock.yaml` exists → pnpm
3. `yarn.lock` exists → yarn
4. `package-lock.json` exists → npm
5. Default → npm

**Detect framework** from package.json dependencies:
- `@sveltejs/kit` → SvelteKit
- `next` → Next.js
- `@remix-run/react` → Remix
- `astro` → Astro
- Otherwise → Node/Generic

```bash
# Check lockfiles
ls -la bun.lockb pnpm-lock.yaml yarn.lock package-lock.json 2>/dev/null

# Check package.json
cat package.json 2>/dev/null | head -50
```

### Step 2: Create Project Configuration

Create `.claude/CLAUDE.md` using the appropriate template.

**Project name**: Use the current directory name (do not ask).

**Description**: Leave as placeholder text for user to fill in later.

Use template from `${CLAUDE_PLUGIN_ROOT}/templates/`:
- `sveltekit/CLAUDE.md.template` for SvelteKit
- `base/CLAUDE.md.template` for others

Replace template variables:
- `{{PROJECT_NAME}}` - Current directory name
- `{{DESCRIPTION}}` - "Brief project description (edit this)"
- `{{PACKAGE_MANAGER}}` - Detected package manager
- `{{PACKAGE_MANAGER_X}}` - bunx, npx, pnpx, or yarn dlx
- `{{DEV_COMMAND}}` - `<pm> run dev`
- `{{BUILD_COMMAND}}` - `<pm> run build`
- `{{TEST_COMMAND}}` - `<pm> run test`
- `{{LINT_COMMAND}}` - `<pm> run lint`

### Step 3: Configure Permissions

Create `.claude/settings.json` with pre-approved commands.

Use template from `${CLAUDE_PLUGIN_ROOT}/templates/`:
- `sveltekit/settings.json` for SvelteKit
- `base/settings.json.template` for others (replace `{{PACKAGE_MANAGER}}` and `{{PACKAGE_MANAGER_X}}`)

### Step 4: Copy GitHub Workflows

```bash
mkdir -p .github/workflows
```

Copy from `${CLAUDE_PLUGIN_ROOT}/templates/<stack>/github/workflows/` if they exist.

### Step 5: Set Up Playwright E2E Testing

For web projects (SvelteKit, Next.js, Remix, Astro):

1. Install Playwright:
```bash
<pm> add -D @playwright/test  # or npm install -D, pnpm add -D
```

2. Install browsers:
```bash
<pmx> playwright install chromium
```

3. Copy Playwright config from templates.

4. Create tests directory:
```bash
mkdir -p tests
```
Copy `${CLAUDE_PLUGIN_ROOT}/templates/shared/tests/example.spec.ts`.

5. Add script to package.json if not present:
```json
{ "scripts": { "test:e2e": "playwright test" } }
```

### Step 6: Create Rules Directory

```bash
mkdir -p .claude/rules
```

### Step 7: Install Companion Plugins (if --plugins flag)

**Only if the user passed `--plugins`**, install recommended plugins:

```bash
claude plugin marketplace add anthropics/claude-code-plugins
claude plugin install github@claude-plugins-official
claude plugin install code-simplifier@claude-plugins-official
claude plugin install code-review@claude-plugins-official
claude plugin install frontend-design@claude-plugins-official
claude plugin install typescript-lsp@claude-plugins-official
```

If `--plugins` was not passed, skip this step entirely.

### Step 8: Configure Vercel (if --vercel flag)

**Only if the user passed `--vercel`**, create `vercel.json`.

Use `${CLAUDE_PLUGIN_ROOT}/templates/shared/deploy/vercel.json.template` with framework-specific values:

| Framework | `{{FRAMEWORK}}` | `{{OUTPUT_DIR}}` |
|-----------|-----------------|------------------|
| SvelteKit | `sveltekit` | `.svelte-kit` |
| Next.js | `nextjs` | `.next` |
| Remix | `remix` | `build` |
| Astro | `astro` | `dist` |

For SvelteKit, also suggest:
```bash
<pm> add -D @sveltejs/adapter-vercel
```

If `--vercel` was not passed, skip this step entirely.

### Step 9: Confirm Setup

Print a summary of what was created:

```
✓ Created .claude/CLAUDE.md
✓ Created .claude/settings.json
✓ Created .claude/rules/
✓ Set up Playwright E2E testing
✓ Installed companion plugins (if --plugins)
✓ Configured Vercel deployment (if --vercel)

Next steps:
- Edit .claude/CLAUDE.md to add your project description
- Run `<pm> run test:e2e` to verify Playwright works
- Run `/update` periodically for config updates
```

## Important

- Do NOT copy the plugin's base CLAUDE.md - it loads automatically
- Project CLAUDE.md should only contain project-specific info
- Never ask questions - detect everything automatically
