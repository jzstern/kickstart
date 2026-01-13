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
| `format-on-save` | Auto-formats files after write/edit |
| `check-worktree` | Blocks writes on main branch |

### Rules
- **TypeScript** - Naming conventions, type safety, imports
- **Testing** - BDD structure, mocking, coverage
- **Comments** - Self-documenting code principles

### Templates
- **SvelteKit** - Bun, Svelte 5, Tailwind, Biome
- **Base** - Generic web project setup

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
