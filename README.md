# kickstart

Opinionated Claude Code plugin for fast web project setup. Get productive immediately with sensible defaults for git workflows, TypeScript, testing, and more.

## Installation

```bash
# Add the kickstart marketplace
/plugin marketplace add jzstern/kickstart

# Install kickstart
/plugin install kickstart@kickstart
```

### Recommended Plugins

Kickstart works great alongside these official plugins. Install them for the complete experience:

```bash
# Code quality
/plugin install code-simplifier@claude-plugins-official
/plugin install code-review@claude-plugins-official

# Frontend development
/plugin install frontend-design@claude-plugins-official

# TypeScript support
/plugin install typescript-lsp@claude-plugins-official
```

## Features

### Git Worktree Workflow
Never commit to main. Kickstart enforces creating worktrees for all changes:
```bash
git worktree add -b feat/my-feature ../repo-feat-my-feature main
```

### Project Scaffolding
```
/init    # Set up a new project with kickstart config
/update  # Check for and apply config updates (with approval)
```

### Agents
| Agent | Description |
|-------|-------------|
| `debugger` | Investigates errors and stack traces |
| `security-auditor` | OWASP Top 10 vulnerability scanning |
| `test-generator` | Generates comprehensive unit tests |
| `e2e-runner` | Playwright E2E test specialist |

### Hooks
| Hook | Description |
|------|-------------|
| `session-start-warning` | Warns immediately when starting a session on main |
| `block-main-commits` | Blocks `git commit` and `git push` on main |
| `check-worktree` | Blocks file writes on main branch |
| `format-on-save` | Auto-formats files after write/edit |

### Rules
- **TypeScript** - Naming conventions, type safety, imports
- **Testing** - BDD structure, mocking, coverage
- **Comments** - Self-documenting code principles

### Templates
- **SvelteKit** - Bun, Svelte 5, Tailwind, Biome
- **Base** - Generic web project setup

## Security & Permissions

**⚠️ This plugin grants Claude Code broad permissions to run commands without confirmation prompts.**

By installing this plugin, you're allowing Claude to execute the following without asking:

| Category | Commands | Risk Level |
|----------|----------|------------|
| **Package Execution** | `npx`, `bunx` | 🔴 High - Can run arbitrary npm packages (supply chain risk) |
| **Code Execution** | `python3` | 🔴 High - Arbitrary Python code execution |
| **Network** | `curl`, `dig`, `ping` | 🟠 Medium - Can make network requests, potential data exfiltration |
| **Git Operations** | `git push`, `git reset`, `git commit` | 🟠 Medium - Can push to remotes, discard uncommitted work |
| **GitHub CLI** | `gh` (all commands) | 🟠 Medium - Includes `gh repo delete`, `gh release delete`, etc. |
| **Deployment** | `vercel` | 🟠 Medium - Can deploy to production environments |
| **System** | `pkill`, `chmod`, `brew install` | 🟠 Medium - Process control, file permissions, package installation |
| **Plugin Commands** | `Skill(*)` | 🟡 Low - All Claude plugin commands run without confirmation |

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
4. Submit a PR

## License

MIT
