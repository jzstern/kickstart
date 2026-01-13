# kickstart

Opinionated Claude Code plugin for fast web project setup. Get productive immediately with sensible defaults for git workflows, TypeScript, testing, and more.

## Features

- **Git Worktree Workflow** - Enforced branching with worktrees (never commit to main)
- **TypeScript Best Practices** - Naming conventions, type safety rules
- **Testing Standards** - BDD structure, mocking guidelines
- **Code Quality Agents** - Code review, security audit, test generation
- **CI/CD Templates** - GitHub Actions workflows ready to go

## Installation

Add to your project's `.claude/plugins/`:

```bash
mkdir -p .claude/plugins
cd .claude/plugins
git clone https://github.com/jzs/kickstart.git
```

Or add as a git submodule:

```bash
git submodule add https://github.com/jzs/kickstart.git .claude/plugins/kickstart
```

## Usage

### Initialize a New Project

```
/init
```

This will:
1. Detect your tech stack (or ask)
2. Create `.claude/CLAUDE.md` with project config
3. Set up GitHub workflows

### Update Configuration

```
/update
```

Check for plugin updates and merge them with your customizations. You'll approve all changes before they're applied.

## What's Included

### Agents

| Agent | Description |
|-------|-------------|
| `code-reviewer` | Reviews changes for quality and style |
| `security-auditor` | OWASP Top 10 vulnerability scanning |
| `test-generator` | Generates comprehensive unit tests |
| `debugger` | Investigates errors and stack traces |
| `e2e-runner` | Playwright E2E test specialist |
| `code-simplifier` | Simplifies code without changing behavior |

### Hooks

| Hook | Description |
|------|-------------|
| `format-on-save` | Auto-formats files after write/edit |
| `check-worktree` | Warns if writing code on main branch |

### Rules

- **TypeScript** - Naming, type safety, imports, async handling
- **Testing** - BDD structure, mocking, coverage requirements
- **Comments** - Self-documenting code principles

### Templates

- **SvelteKit** - Bun, Svelte 5, Tailwind, Biome
- **Base** - Generic web project setup

## Configuration Philosophy

**Plugin-owned (updates automatically):**
- Agents, hooks, rules
- Base CLAUDE.md with universal guidelines
- CI workflow templates

**Project-owned (you control):**
- Project name and description
- Custom commands
- Project-specific notes

This split means you get updates without losing customizations.

## Contributing

1. Fork the repo
2. Create a feature branch
3. Make your changes
4. Submit a PR

## License

MIT
