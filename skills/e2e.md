---
description: E2E testing with Playwright
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# E2E Testing with Playwright

Run end-to-end tests for the full user journey.

## Instructions

1. **Check Playwright installation**:

Before installing anything, verify you're in a Node project (a `package.json` exists in the current directory) and `npx` is available. If either is missing, do not install dependencies; report the issue and stop.
```bash
if ! npx playwright --version >/dev/null 2>&1; then
  npm install -D @playwright/test && npx playwright install
fi
```

Note: if `npx playwright` isn't available, this will install `@playwright/test` into the current project and update lockfiles. Run this from the project (or package) root where your Playwright tests live (i.e., where `package.json` exists), and verify `package.json` is present before installing.

2. **Ensure the app is running**:
   - Prefer configuring `webServer` in `playwright.config.(ts|js)` (see below). If it is configured, do not start the dev server manually.
   - Otherwise, start the dev server in a separate terminal and stop it when you're done:

To determine whether `webServer` is configured, open `playwright.config.(ts|js)` and look for a `webServer` property. In non-interactive environments, prefer relying on `webServer` rather than starting `npm run dev` in the foreground.
```bash
npm run dev
```

Stop the dev server when you're done (for example, with Ctrl+C).

3. **Run E2E tests**:
```bash
npx playwright test
```

4. **If no tests exist**, create them in `tests/e2e/`:

### Test Structure
```typescript
// tests/e2e/example.spec.ts
import { test, expect } from '@playwright/test';

test.describe('User Journey', () => {

  test('should complete main flow', async ({ page }) => {
    await page.goto('/');

    // Interact with the page
    await page.fill('input[type="text"]', 'test input');
    await page.click('button[type="submit"]');

    // Verify results
    await expect(page.locator('[data-testid="result"]')).toBeVisible();
  });

  test('should show error for invalid input', async ({ page }) => {
    await page.goto('/');
    await page.fill('input[type="text"]', '');
    await page.click('button[type="submit"]');

    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
  });
});
```

5. **Create Playwright config** if not present:
```typescript
// playwright.config.ts
import { defineConfig } from '@playwright/test';

export default defineConfig({
  testDir: './tests/e2e',
  timeout: 60000,
  webServer: {
    command: 'npm run dev',
    port: 3000,
    reuseExistingServer: true,
  },
  use: {
    baseURL: 'http://localhost:3000',
    screenshot: 'only-on-failure',
    video: 'retain-on-failure',
  },
});
```

6. **Report results** with screenshots/videos for failures.

7. **AI Analysis**: After tests complete, analyze any failures:
   - Read the error messages
   - Check screenshots in `test-results/`
   - Suggest fixes for failing tests
