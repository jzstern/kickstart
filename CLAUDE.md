# Kickstart

Opinionated Claude Code configuration for web development. This file is loaded automatically for all kickstart users.

## Git Worktree Workflow

**BEFORE writing ANY code**, you MUST:

1. Check current branch: `git branch --show-current`
2. If on main/master, create a worktree: `git worktree add -b <branch> ../<repo>-<branch> main`
3. Change to the worktree directory before making changes

**This is enforced by hooks.** Attempting to write files or commit on main will be blocked.

### Branch Naming
- `feat/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation
- `test/` - Test changes

### After Merging
Clean up: `git worktree remove ../<repo>-<branch>`

## Available Skills

<!-- kickstart:skills:start -->
| Skill | Description |
|-------|-------------|
| `/init` | Initialize project with kickstart config |
| `/update` | Check for and apply config updates |
| `/docs` | (Developer) Regenerate documentation |
<!-- kickstart:skills:end -->

## Available Agents

<!-- kickstart:agents:start -->
| Agent | Description |
|-------|-------------|
| `debugger` | Investigates errors and stack traces |
| `e2e-runner` | Playwright E2E testing specialist |
| `security-auditor` | OWASP Top 10 vulnerability scanning |
| `test-generator` | Generates comprehensive unit tests |
<!-- kickstart:agents:end -->

## Active Hooks

<!-- kickstart:hooks:start -->
| Hook | Event | Description |
|------|-------|-------------|
| `session-start-warning` | SessionStart | Warns on main, checks if behind origin |
| `block-main-commits` | PreToolUse | Blocks git commit/push on main |
| `check-worktree` | PreToolUse | Blocks file writes on main |
| `format-on-save` | PostToolUse | Auto-formats after write/edit |
<!-- kickstart:hooks:end -->

## Commit Conventions

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code change (no behavior change)
- `docs:` - Documentation only
- `test:` - Test changes
- `chore:` - Maintenance

## Code Quality

### Before Committing
1. Run type checker
2. Run linter
3. Run tests
4. Test manually

### Security
- Never commit secrets
- Validate input at boundaries
- Sanitize filenames
- Clean up temp files

## Error Handling

**Server-side:** Log full details, return friendly messages
**Client-side:** Log to console, show friendly UI messages
