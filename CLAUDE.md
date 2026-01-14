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
Worktrees are automatically cleaned up at session start when their branches are deleted from remote. You can also run `/cleanup` manually.

## Available Skills

<!-- kickstart:skills:start -->
| Skill | Description |
|-------|-------------|
| `/init` | Initialize project with kickstart config and companion plugins |
| `/update` | Check for and apply config updates |
| `/cleanup` | Remove stale worktrees (runs automatically at session start) |
| `/uninstall` | Uninstall plugin, keeping customizations |
| `/docs` | Regenerate documentation tables (runs automatically) |
| `/resolve-conflicts` | Detect and resolve merge conflicts with base branch |
| `/review` | Code review of staged/changed files |
| `/security` | Security audit with OWASP Top 10 checks |
| `/test` | Generate comprehensive unit tests |
| `/e2e` | E2E testing with Playwright |
| `/compound` | Capture session learnings to improve future work |
<!-- kickstart:skills:end -->

## Available Agents

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

## Active Hooks

<!-- kickstart:hooks:start -->
| Hook | Event | Description |
|------|-------|-------------|
| `session-start-warning` | SessionStart | Auto-cleans stale worktrees, warns on main |
| `auto-init` | UserPromptSubmit | Prompts /init for uninitialized projects |
| `block-main-commits` | PreToolUse | Blocks git commit/push on main |
| `check-worktree` | PreToolUse | Blocks file writes on main |
| `format-on-save` | PostToolUse | Auto-formats after write/edit |
| `auto-pr-update` | PreToolUse | Updates PR description before push |
| `auto-assign-pr` | PostToolUse | Assigns created PRs to creator |
| `auto-docs` | PostToolUse | Regenerates docs when components change |
| `detect-conflicts` | PreToolUse | Checks for merge conflicts before push |
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
