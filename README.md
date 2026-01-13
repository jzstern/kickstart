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

### Project Scaffolding
```
/init    # Set up a new project (includes option to install companion plugins)
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
| `format-on-save` | Auto-formats files after write/edit |
| `check-worktree` | Blocks writes on main branch |

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
