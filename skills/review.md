---
description: Code review of staged/changed files
allowed-tools: Read, Grep, Glob, Bash
---

# Code Review

Perform a comprehensive code review of staged/changed files.

## Instructions

1. **Get changed files**: Run `git diff --name-only HEAD` to see what's changed
2. **Read each changed file** and analyze against these criteria:

### Security Review
- Path traversal vulnerabilities (check for `../` in user inputs)
- Command injection (check shell command construction)
- Unvalidated URL inputs
- Sensitive data exposure in logs
- XSS in rendered content

### Code Quality
- TypeScript strict typing (no `any` unless justified)
- Proper error handling (try/catch with user-friendly messages)
- Modern framework patterns
- Consistent indentation

### Performance
- Unnecessary re-renders in components
- Large bundle imports (prefer tree-shaking)
- Memory leaks (unsubscribed listeners)

### Best Practices
- Component structure matches CLAUDE.md guidelines
- Proper imports (value imports, not type-only for runtime)
- Consistent naming conventions

3. **Output format**:
```
## Review Summary

### Critical Issues
- [File:Line] Issue description

### Warnings
- [File:Line] Warning description

### Suggestions
- [File:Line] Suggestion

### Passed Checks
- List what looks good
```

4. **Run validation**: Execute type checker and linter to catch additional issues.
