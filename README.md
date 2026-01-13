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
git clone https://github.com/jzstern/kickstart.git
```

Or add as a git submodule:

```bash
git submodule add https://github.com/jzstern/kickstart.git .claude/plugins/kickstart
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
