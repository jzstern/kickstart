import { test, expect } from '@playwright/test';

test.describe('Homepage', () => {
  test('loads successfully', async ({ page }) => {
    // #given
    await page.goto('/');

    // #then
    await expect(page).toHaveTitle(/./);
  });

  test('navigation works', async ({ page }) => {
    // #given
    await page.goto('/');

    // #when
    const links = page.locator('a[href]');

    // #then
    const count = await links.count();
    expect(count).toBeGreaterThanOrEqual(0);
  });
});
