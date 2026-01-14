# kickstart

Opinionated Claude Code plugin for fast web project setup. Get productive immediately with sensible defaults for git workflows, TypeScript, testing, and more.

## Installation

Run these commands inside a Claude Code session:

```
/plugin marketplace add jzstern/kickstart
/plugin install kickstart@kickstart
```

### Companion Plugins

Kickstart installs these official plugins when you run `/init --plugins`:

| Plugin | Purpose |
|--------|---------|
| `github` | GitHub MCP integration for PRs, issues, and repos |
| `code-simplifier` | Simplifies and refines code for clarity |
| `code-review` | Code review for pull requests |
| `frontend-design` | High-quality frontend interface generation |
| `typescript-lsp` | TypeScript language server integration |
| `pr-review-toolkit` | PR review agents for tests, types, and code quality |
| `playwright` | Browser automation and E2E testing MCP |
| `security-guidance` | Security hooks for injection, XSS, unsafe patterns |

## Getting Started

When you open a project that hasn't been initialized with Kickstart, you'll see a welcome message and be prompted to run `/init`. This sets up:

- Project-specific `CLAUDE.md` with your project name and description
- Git worktree workflow enforcement
- TypeScript, testing, and comment rules
- Companion plugins for code quality

The prompt only appears once per project. After initialization, Kickstart works silently in the background.

## Features

### Git Worktree Workflow
Never commit to main. Kickstart enforces creating worktrees for all changes:
```bash
git worktree add -b feat/my-feature ../repo-feat-my-feature main
```

Stale worktrees are automatically cleaned up at session start when their branches are deleted from `origin` (e.g., after a PR is merged). For this to work, enable auto-delete in your GitHub repo under **Settings → General → Pull Requests → Automatically delete head branches**.

### Skills

<!-- kickstart:skills:start -->
| Skill | Description |
|-------|-------------|
| `/init` | Initialize project with kickstart config and companion plugins |
| `/update` | Check for and apply config updates |
| `/cleanup` | Remove stale worktrees (runs automatically at session start) |
| `/uninstall` | Uninstall plugin, keeping project config |
| `/docs` | Regenerate documentation tables (runs automatically) |
| `/resolve-conflicts` | Detect and resolve merge conflicts with base branch |
| `/review` | Code review of staged/changed files |
| `/security` | Security audit with OWASP Top 10 checks |
| `/test` | Generate comprehensive unit tests |
| `/e2e` | E2E testing with Playwright |
| `/compound` | Capture session learnings to improve future work |
<!-- kickstart:skills:end -->

### Agents

<!-- kickstart:agents:start -->
| Agent | Description |
|-------|-------------|
| `conflict-resolver` | Detects and resolves git merge conflicts |
| `debugger` | Investigates errors and stack traces |
| `e2e-runner` | Playwright E2E testing specialist |
| `security-auditor` | OWASP Top 10 vulnerability scanning |
| `test-generator` | Generates comprehensive unit tests |
| `code-reviewer` | Reviews code for quality, security, and standards |
| `codebase-search` | Locates code and implementations with parallel search |
| `media-interpreter` | Extracts data from PDFs, images, diagrams |
| `open-source-librarian` | Researches libraries with GitHub permalinks |
<!-- kickstart:agents:end -->

### Hooks

<!-- kickstart:hooks:start -->
| Hook | Event | Description |
|------|-------|-------------|
| `session-start-warning` | SessionStart | Auto-cleans stale worktrees, warns on main |
| `auto-init` | UserPromptSubmit | Prompts /init for uninitialized projects |
| `block-main-commits` | PreToolUse | Blocks git commit/push on main |
| `check-worktree` | PreToolUse | Blocks file writes on main |
| `format-on-save` | PostToolUse | Auto-formats after write/edit |
| `auto-pr-update` | PreToolUse | Updates PR description before push ([setup required](#github-mcp-setup)) |
| `auto-assign-pr` | PostToolUse | Assigns created PRs to creator |
| `auto-docs` | PostToolUse | Regenerates docs when components change |
| `detect-conflicts` | PreToolUse | Checks for merge conflicts before push and auto-resolves them |
<!-- kickstart:hooks:end -->

### GitHub MCP Setup

The `auto-pr-update` hook requires the GitHub MCP integration to update PR descriptions. To enable it:

1. **Create a GitHub Personal Access Token**
   - Go to [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
   - Create a token with `repo` scope (for PR read/write access)

2. **Set the environment variable**
   ```bash
   # Add to your shell profile (~/.zshrc, ~/.bashrc, etc.)
   export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_your_token_here"
   ```

3. **Install the GitHub MCP plugin** (in Claude Code)
   ```
   /plugin install github@claude-plugins-official
   ```

4. **Restart Claude Code** to pick up the environment variable

Once configured, the hook will automatically update your PR description with a summary, testing instructions, and files changed whenever you push to a branch with an open PR.

### Rules
- **TypeScript** - Naming conventions, type safety, imports
- **Testing** - BDD structure, mocking, coverage
- **Comments** - Self-documenting code principles

### Templates
- **SvelteKit** - Bun, Svelte 5, Tailwind, Biome
- **Base** - Generic web project setup

## Permissions

⚠️ **Warning: This plugin grants Claude extensive permissions.** It can edit files, run code, push to git, deploy to Vercel, and more—all without asking first. This is by design: fewer interruptions, faster coding.

**[See the full list →](.claude/settings.json)**

**Want fewer permissions?** Edit `.claude/settings.json`, remove whatever scares you.

## How It Works

**Plugin-owned (updates automatically):**
- Agents, hooks, rules
- Base CLAUDE.md with universal guidelines
- CI workflow templates

**Project-owned (you control):**
- Project name and description
- Custom commands
- Project-specific notes

Run `/update` periodically to get the latest config without losing your customizations.

## License

MIT
