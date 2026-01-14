---
description: E2E testing with Playwright
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# E2E Testing with Playwright

Run end-to-end tests for the full user journey.

## Instructions

1. **Check Playwright installation**:
```bash
npx playwright --version || npm install -D @playwright/test && npx playwright install
```

2. **Run E2E tests** (Playwright will start the server if `webServer` is configured):
```bash
npx playwright test
```

3. **If `webServer` is not configured**, start the dev server in a separate terminal and stop it when you're done:
```bash
npm run dev
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
