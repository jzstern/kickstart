---
description: Security audit with OWASP Top 10 checks
allowed-tools: Read, Grep, Glob, Bash
---

# Security Audit

Perform a security-focused review of the codebase.

## Instructions

1. **Discover code roots** (don't assume `src/` exists):
   - Use `Glob` to identify likely code directories (for example: `src/`, `app/`, `server/`, `packages/`, `lib/`)
   - Prefer scanning those roots; if you must fall back to searching from `.`, still exclude build/vendor directories
   - Avoid vendor/build directories such as `node_modules`, `.git`, `dist`, `build`, and `.next`

When running `grep`, replace `.` with your discovered code roots when possible (for example: `src app server packages lib`).
In the examples below, replace `CODE_ROOTS` with those roots.

**Important**: `CODE_ROOTS` is a placeholder. Never run these commands with `CODE_ROOTS` literally.

If no reasonable code roots can be discovered, use `.` as the fallback `CODE_ROOTS` value, keeping the same `--exclude-dir` filters.

Example: if you discover `src/` and `server/`, run `grep ... src server` (and only fall back to `grep ... .` if needed, keeping the same `--exclude-dir` filters).

When choosing `CODE_ROOTS` from `Glob` results:
- Prefer top-level directories named `src`, `app`, `server`, `packages`, or `lib`
- If multiple candidates exist, include all of them once in `CODE_ROOTS`
- If you can't find any reasonable roots, fall back to `.` (keeping the same `--exclude-dir` filters)

2. **Scan the codebase** for security vulnerabilities:

### OWASP Top 10 (2021) Checks

#### Injection
- Search for command construction: `grep -r -n -E --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.next '(execSync|exec|spawn)[[:space:]]*\(' CODE_ROOTS`
- Check user input sanitization
- Verify URL validation

#### Broken Authentication
- Check for hardcoded credentials
- Verify no API keys in source code
- Check .gitignore for sensitive files

#### Sensitive Data Exposure
- Search for logging of sensitive data: `grep -r -n -E --exclude-dir=node_modules --exclude-dir=dist --exclude-dir=build --exclude-dir=.next 'console\.(log|warn|error).*(password|token|key|secret)' CODE_ROOTS`
- Check error messages don't leak internal paths
- Verify temp files are cleaned up

#### XML External Entities (XXE)
- Check any XML/HTML parsing

#### Broken Access Control
- Verify file path sanitization
- Check for path traversal: `../` handling
- Validate directory restrictions

#### Security Misconfiguration
- Check CORS settings in API routes
- Verify Content-Security-Policy headers
- Check for development-only code in production

#### Cross-Site Scripting (XSS)
- Check for dangerously set HTML
- Verify user inputs are escaped
- Check dynamic content rendering

#### Insecure Deserialization
- Check JSON parsing of untrusted data

#### Components with Known Vulnerabilities
- Run `npm audit` or equivalent

#### Insufficient Logging
- Verify errors are logged (but not sensitive data)

2. **Output format**:

Each finding should include a `repo-path:` and should include an `abs-path:` when available.
For findings that aren't tied to a specific file, use `repo-path: N/A` and describe the scope.

When a tool returns absolute paths, derive `repo-path` by stripping the repository root or workspace directory prefix from the beginning of the path (for example, remove `/workspace/project/` from `/workspace/project/src/auth/login.ts` to get `src/auth/login.ts`).
```markdown
## Security Audit Report

### Critical Vulnerabilities
- [CVSS Score or N/A] [repo-path: repo/path:line] (abs-path optional) Description and remediation

### High Risk
- [repo-path: repo/path:line] (abs-path optional) Issue and fix

### Medium Risk
- [repo-path: repo/path:line] (abs-path optional) Issue and fix

### Low Risk / Informational
- [repo-path: repo/path:line] (abs-path optional) Note

### Security Best Practices Applied
- List positive findings
```
