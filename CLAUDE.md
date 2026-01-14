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

### After Completing Work

When you finish implementing a feature or fix:
1. Run type checker and linter
2. Run tests
3. Commit all changes with a conventional commit message
4. Push the branch to origin
5. Open a pull request using `gh pr create` (skip if PR already exists)

Do this automatically without asking for confirmation.

### After Merging
Clean up: `git worktree remove ../<repo>-<branch>`

## Available Skills

<!-- kickstart:skills:start -->
| Skill | Description |
|-------|-------------|
| `/init` | Initialize project with kickstart config and companion plugins |
| `/update` | Check for and apply config updates |
| `/uninstall` | Uninstall plugin, keeping project config |
| `/docs` | Regenerate documentation tables (runs automatically) |
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
| `session-start-warning` | SessionStart | Warns on main, checks if behind remote |
| `auto-init` | UserPromptSubmit | Prompts /init for uninitialized projects |
| `block-main-commits` | PreToolUse | Blocks git commit/push on main |
| `check-worktree` | PreToolUse | Blocks file writes on main |
| `format-on-save` | PostToolUse | Auto-formats after write/edit |
| `auto-pr-update` | PreToolUse | Updates PR description before push |
| `auto-assign-pr` | PostToolUse | Assigns created PRs to creator |
| `auto-docs` | PostToolUse | Regenerates docs when components change |
<!-- kickstart:hooks:end -->

## Commit Conventions

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code change (no behavior change)
- `docs:` - Documentation only
- `test:` - Test changes
- `chore:` - Maintenance

## Security
- Never commit secrets
- Validate input at boundaries
- Sanitize filenames
- Clean up temp files

## Error Handling

**Server-side:** Log full details, return friendly messages
**Client-side:** Log to console, show friendly UI messages
