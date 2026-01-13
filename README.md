# kickstart

Opinionated Claude Code plugin for fast web project setup. Get productive immediately with sensible defaults for git workflows, TypeScript, testing, and more.

## Installation

```bash
# Add the kickstart marketplace
/plugin marketplace add jzstern/kickstart

# Install kickstart
/plugin install kickstart@kickstart
```

### Companion Plugins

Kickstart works great alongside these official plugins. **During `/init`, you'll be offered the option to install them automatically.**

| Plugin | Purpose |
|--------|---------|
| `code-simplifier` | Simplifies and refines code for clarity |
| `code-review` | Code review for pull requests |
| `frontend-design` | High-quality frontend interface generation |
| `typescript-lsp` | TypeScript language server integration |

To install manually:
```bash
/plugin marketplace add anthropics/claude-code-plugins
/plugin install code-simplifier@claude-plugins-official
```

## Features

### Git Worktree Workflow
Never commit to main. Kickstart enforces creating worktrees for all changes:
```bash
git worktree add -b feat/my-feature ../repo-feat-my-feature main
```

### Skills

<!-- kickstart:skills:start -->
| Skill | Description |
|-------|-------------|
| `/init` | Initialize project configuration with kickstart defaults (includes option to install companion plugins) |
| `/update` | Check for and apply config updates with user approval |
| `/uninstall` | Uninstall plugin while preserving project configuration and customizations |
| `/docs` | Auto-generate documentation from plugin components |
<!-- kickstart:skills:end -->

### Agents

<!-- kickstart:agents:start -->
| Agent | Description |
|-------|-------------|
| `debugger` | Investigates errors, analyzes stack traces, traces issues through codebase |
| `e2e-runner` | E2E testing specialist using Playwright |
| `security-auditor` | OWASP Top 10 vulnerability scanning |
| `test-generator` | Generates comprehensive unit tests |
<!-- kickstart:agents:end -->

### Hooks

<!-- kickstart:hooks:start -->
| Hook | Event | Description |
|------|-------|-------------|
| `session-start-warning` | SessionStart | Warns when on main/master branch and checks if behind remote |
| `block-main-commits` | PreToolUse | Blocks git commit and push commands on main/master |
| `check-worktree` | PreToolUse | Blocks file writes on main/master branch |
| `format-on-save` | PostToolUse | Auto-formats files after write/edit |
| `auto-pr-update` | PreToolUse | Updates PR description before push ([setup required](#github-mcp-setup)) |
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

3. **Install the GitHub MCP plugin**
   ```bash
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

<!-- kickstart:permissions:start -->
| Category | Commands |
|----------|----------|
| **Git** | `status`, `branch`, `log`, `diff`, `show`, `fetch`, `pull`, `add`, `commit`, `push`, `checkout`, `switch`, `rebase`, `merge`, `stash`, `worktree`, `remote`, `tag`, `cherry-pick`, `reset`, `restore`, `clean` |
| **GitHub CLI** | `api`, `pr`, `issue`, `repo view`, `run`, `workflow` |
| **Bun** | `add`, `install`, `run dev`, `run build`, `run check`, `run lint`, `run test` |
| **Playwright** | `bunx playwright` |
| **Biome** | `bunx biome` |
<!-- kickstart:permissions:end -->

By installing this plugin, you're allowing Claude to execute the following without asking:

| Category | Commands | Risk Level |
|----------|----------|------------|
| **File Operations** | `Edit`, `Write`, `mkdir`, `rm`, `mv`, `cp` | 🔴 High - Can modify/delete any file in project |
| **Package Execution** | `npx`, `bunx` | 🔴 High - Can run arbitrary npm packages (supply chain risk) |
| **Code Execution** | `python3` | 🔴 High - Arbitrary Python code execution |
| **Network** | `curl`, `dig`, `ping` | 🟠 Medium - Can make network requests, potential data exfiltration |
| **Git Operations** | `git push`, `git reset`, `git commit` | 🟠 Medium - Can push to remotes, discard uncommitted work |
| **GitHub CLI** | `gh` (all commands) | 🟠 Medium - Includes `gh repo delete`, `gh release delete`, etc. |
| **GitHub MCP** | PR creation, branch creation, issue reading | 🟠 Medium - Can create PRs and branches automatically |
| **Deployment** | `vercel` | 🟠 Medium - Can deploy to production environments |
| **System** | `pkill`, `chmod`, `brew install` | 🟠 Medium - Process control, file permissions, package installation |
| **Plugin Management** | `claude plugin`, `claude mcp` | 🟡 Low - Can install/remove plugins and MCP servers |
| **Plugin Commands** | `Skill(*)` | 🟡 Low - All Claude plugin commands run without confirmation |

> **Note:** Git operations on main branch are blocked by kickstart hooks even though the commands are permitted. This provides safety while maintaining a frictionless workflow on feature branches.

### Who Should Use This

✅ **Recommended for:**
- Personal development machines you fully control
- Trusted development environments
- Developers comfortable with Claude having broad access

❌ **Not recommended for:**
- Shared or multi-user systems
- Production environments
- Users who prefer explicit confirmation for each command

### Reducing Permissions

If you want tighter security, fork this plugin and edit `.claude/settings.json` to remove permissions you're not comfortable with. For example, remove `Bash(npx:*)` to require confirmation before running arbitrary npm packages.

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

## Documentation Maintenance

Run `/docs` after modifying kickstart components to regenerate this README's tables. The sections between `<!-- kickstart:*:start -->` and `<!-- kickstart:*:end -->` markers are auto-generated.

## Credits

Kickstart recommends these excellent official plugins:
- [code-simplifier](https://github.com/anthropics/claude-code-plugins) by Anthropic
- [code-review](https://github.com/anthropics/claude-code-plugins) by Anthropic
- [frontend-design](https://github.com/anthropics/claude-code-plugins) by Anthropic
- [typescript-lsp](https://github.com/anthropics/claude-code-plugins) by Anthropic

## Contributing

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Run `/docs` to update documentation
5. Submit a PR

## License

MIT
