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

**Package manager command mapping**:
| PM | Install cmd | Exec cmd | Add dev dep |
|----|-------------|----------|-------------|
| bun | `bun install` | `bunx` | `bun add -D` |
| pnpm | `pnpm install` | `pnpm dlx` | `pnpm add -D` |
| yarn | `yarn install` | `npx` | `yarn add -D` |
| npm | `npm install` | `npx` | `npm install -D` |

Note: `npx` is used for yarn because `yarn dlx` only exists in Yarn 2+ (Berry), not Yarn 1 (Classic).

**Detect framework** from package.json dependencies:
- `@sveltejs/kit` → SvelteKit (port 5173)
- `next` → Next.js (port 3000)
- `@remix-run/react` → Remix (port 3000)
- `astro` → Astro (port 4321)
- `express`, `fastify`, `hono` → Node API (skip Playwright)
- No package.json or no framework deps → Node/Generic (skip Playwright)

```bash
# Check lockfiles
ls -la bun.lockb pnpm-lock.yaml yarn.lock package-lock.json 2>/dev/null

# Check package.json
cat package.json 2>/dev/null | head -50
```

### Step 2: Create Project Configuration

**First, check for existing CLAUDE.md files (case-insensitive):**

```bash
# Check .claude/ directory first (case-insensitive)
find .claude -maxdepth 1 -type f -iname 'claude.md' 2>/dev/null

# Check root directory (case-insensitive)
find . -maxdepth 1 -type f -iname 'claude.md' 2>/dev/null
```

**If `.claude/CLAUDE.md` (any case) already exists:**
- **Do NOT overwrite it** - the user has customized content
- Skip to Step 3

**If root has a CLAUDE.md (any case) but `.claude/` does not:**
- Move it into `.claude/` without overwriting:
```bash
mkdir -p .claude
ROOT_CLAUDE=$(find . -maxdepth 1 -type f -iname 'claude.md' -print -quit)
if [ -n "$ROOT_CLAUDE" ]; then
  mv "$ROOT_CLAUDE" .claude/CLAUDE.md
fi
```
- Skip to Step 3

**If no CLAUDE.md exists**, create `.claude/CLAUDE.md` using the appropriate template.

**Project name**: Use the current directory name (do not ask).

**Description**: Leave as placeholder text for user to fill in later.

Use template from `${CLAUDE_PLUGIN_ROOT}/templates/`:
- `sveltekit/CLAUDE.md.template` for SvelteKit
- `base/CLAUDE.md.template` for others

Replace template variables:
- `{{PROJECT_NAME}}` - Current directory name
- `{{DESCRIPTION}}` - "Brief project description (edit this)"
- `{{PACKAGE_MANAGER}}` - Detected package manager
- `{{PACKAGE_MANAGER_X}}` - Exec command from mapping above
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

Copy workflows in this order:
1. **Shared workflows** from `${CLAUDE_PLUGIN_ROOT}/templates/shared/github/workflows/` (includes `address-pr-comments.yml` for auto-addressing PR review comments)
2. **Stack-specific workflows** from `${CLAUDE_PLUGIN_ROOT}/templates/<stack>/github/workflows/` if they exist

**Important:** The `address-pr-comments.yml` workflow requires an `ANTHROPIC_API_KEY` secret in the repository. Remind the user to add this secret in their GitHub repository settings under Settings > Secrets and variables > Actions.

### Step 5: Set Up Playwright E2E Testing

**Skip this step for Node API or Node/Generic projects** (no web UI to test).

For web projects (SvelteKit, Next.js, Remix, Astro):

1. Install Playwright using the correct command for the detected package manager:
   - bun: `bun add -D @playwright/test`
   - pnpm: `pnpm add -D @playwright/test`
   - yarn: `yarn add -D @playwright/test`
   - npm: `npm install -D @playwright/test`

2. Install browsers (use exec command from mapping above):
   - bun: `bunx playwright install chromium`
   - pnpm: `pnpm dlx playwright install chromium`
   - yarn: `npx playwright install chromium`
   - npm: `npx playwright install chromium`

3. Copy Playwright config:
   - For SvelteKit: Copy `${CLAUDE_PLUGIN_ROOT}/templates/sveltekit/playwright.config.ts`
   - For other stacks: Use `${CLAUDE_PLUGIN_ROOT}/templates/base/playwright.config.ts.template`
     - Replace `{{DEV_PORT}}` with framework default port (see Step 1)
     - Replace `{{DEV_COMMAND}}` with `<pm> run dev`

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

**Only if the user passed `--plugins`**, install recommended plugins.

The marketplace add command is idempotent (safe to run if already added):

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

**Skip this step for Node API or Node/Generic projects** (no Vercel framework preset available).

**Only if the user passed `--vercel`** and the project is a web framework (SvelteKit, Next.js, Remix, Astro), create `vercel.json`.

Use `${CLAUDE_PLUGIN_ROOT}/templates/shared/deploy/vercel.json.template` and replace all variables:

| Framework | `{{FRAMEWORK}}` | `{{OUTPUT_DIR}}` | `{{DEV_PORT}}` |
|-----------|-----------------|------------------|----------------|
| SvelteKit | `sveltekit` | `.svelte-kit` | `5173` |
| Next.js | `nextjs` | `.next` | `3000` |
| Remix | `remix` | `build` | `3000` |
| Astro | `astro` | `dist` | `4321` |

Additional variables (derive from detected package manager):
- `{{INSTALL_COMMAND}}` - Install command from PM mapping (e.g., `bun install`)
- `{{BUILD_COMMAND}}` - `<pm> run build`
- `{{DEV_COMMAND}}` - `<pm> run dev`

For SvelteKit, also suggest installing the Vercel adapter (use "Add dev dep" command from PM mapping):
- bun: `bun add -D @sveltejs/adapter-vercel`
- pnpm: `pnpm add -D @sveltejs/adapter-vercel`
- yarn: `yarn add -D @sveltejs/adapter-vercel`
- npm: `npm install -D @sveltejs/adapter-vercel`

If `--vercel` was not passed, skip this step entirely.

### Step 9: Confirm Setup

Print a summary based on what happened:

**If CLAUDE.md was preserved (already existed in `.claude/`):**
```text
Setup complete for <PROJECT_NAME> (<FRAMEWORK>)

Preserved:
  .claude/CLAUDE.md - Existing configuration kept

Created:
  .claude/settings.json - Pre-approved commands
  .claude/rules/ - Rules directory
```

**If CLAUDE.md was moved from root:**
```text
Setup complete for <PROJECT_NAME> (<FRAMEWORK>)

Moved:
  CLAUDE.md → .claude/CLAUDE.md

Created:
  .claude/settings.json - Pre-approved commands
  .claude/rules/ - Rules directory
```

**If CLAUDE.md was created from template:**
```text
Setup complete for <PROJECT_NAME> (<FRAMEWORK>)

Created:
  .claude/CLAUDE.md - Project configuration
  .claude/settings.json - Pre-approved commands
  .claude/rules/ - Rules directory

Next steps:
  1. Edit .claude/CLAUDE.md to add your project description
```

**Always include (when applicable):**
```text
Configured:
  Playwright E2E testing (if web project)
  Companion plugins (if --plugins)
  Vercel deployment (if --vercel)

Run `/update` periodically for config updates
```

## Important

- Do NOT copy the plugin's base CLAUDE.md - it loads automatically
- Project CLAUDE.md should only contain project-specific info
- Never ask questions - detect everything automatically
