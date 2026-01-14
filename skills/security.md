---
description: Security audit with OWASP Top 10 checks
allowed-tools: Read, Grep, Glob, Bash
---

# Security Audit

Perform a security-focused review of the codebase.

## Instructions

1. **Scan the entire codebase** for security vulnerabilities:

### OWASP Top 10 Checks

#### Injection
- Search for command construction: `grep -r "exec\|spawn\|execSync" src/`
- Check user input sanitization
- Verify URL validation

#### Broken Authentication
- Check for hardcoded credentials
- Verify no API keys in source code
- Check .gitignore for sensitive files

#### Sensitive Data Exposure
- Search for: `console.log.*password\|token\|key\|secret`
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
```
## Security Audit Report

### Critical Vulnerabilities
- [CVSS Score] [File:Line] Description and remediation

### High Risk
- [File:Line] Issue and fix

### Medium Risk
- [File:Line] Issue and fix

### Low Risk / Informational
- [File:Line] Note

### Security Best Practices Applied
- List positive findings
```
