# Kickstart Base Configuration

This configuration is provided by the [kickstart](https://github.com/jzs/kickstart) plugin.
Run `/update` to check for updates. Run `/init` to scaffold a new project.

## Git Worktree Workflow

**BEFORE writing ANY code or making ANY file changes**, you MUST:

1. Check if you're on the main branch: `git branch --show-current`
2. If on main, create a worktree FIRST: `git worktree add -b <branch-name> ../<repo>-<branch-name> main`
3. Change to the worktree directory before making changes

**This is NON-NEGOTIABLE.** Do not write code, create files, or edit files while on main.

Example workflow:
```bash
# 1. Check current branch
git branch --show-current  # If "main", STOP and create worktree

# 2. Create worktree with new branch
git worktree add -b feat/my-feature ../repo-feat-my-feature main

# 3. Work in the worktree directory
cd ../repo-feat-my-feature
# Now you can write code
```

### Branch Naming
- `feat/` - New features
- `fix/` - Bug fixes
- `refactor/` - Code refactoring
- `docs/` - Documentation changes
- `test/` - Test additions/changes

### After Merging
Clean up worktrees: `git worktree remove ../repo-<branch-name>`

## Commit Conventions

Use conventional commits:
- `feat:` - New feature
- `fix:` - Bug fix
- `refactor:` - Code refactoring (no behavior change)
- `docs:` - Documentation only
- `test:` - Adding/updating tests
- `chore:` - Maintenance tasks

## Code Quality

### Before Committing
1. Run the project's type checker
2. Run the project's linter
3. Run tests if they exist
4. Test the feature manually

### Security
- Never commit credentials or secrets
- Validate user input at system boundaries
- Sanitize filenames to prevent path traversal
- Clean up temporary files

### Performance
- Use dynamic imports for large dependencies
- Import specific functions, not entire libraries
- Avoid premature optimization

## Error Handling

### Server-Side
- Log full error details to console for debugging
- Return user-friendly messages to clients
- Never expose stack traces or internal paths

### Client-Side
- Log errors to console for debugging
- Show friendly messages to users via UI state
- Handle loading, success, and error states

## AI-Assisted Development

### Available Commands
- `/init` - Scaffold project configuration
- `/update` - Check for and apply config updates
- `/review` - Code review current changes
- `/security` - Security audit
- `/test` - Generate tests

### Automatic Hooks
- Format on save
- Worktree enforcement

### Documentation Maintenance
After completing tasks, ask: "Would a new developer need to know this?"
If yes, update the relevant documentation.
