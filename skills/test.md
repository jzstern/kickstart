---
description: Generate comprehensive unit tests
allowed-tools: Read, Write, Edit, Glob, Grep, Bash
---

# Generate Tests

Generate comprehensive tests for the codebase.

## Instructions

1. **Analyze existing code** to understand what needs testing:
   - API routes
   - Utility functions
   - Components

2. **Create unit tests** following BDD conventions:

### Test Structure
```typescript
describe('ModuleName.functionName()', () => {
	// #given
	const mockData = { /* test data */ };

	beforeEach(() => {
		// Reset mocks
	});

	it('should handle valid input', async () => {
		// #given
		const input = 'valid';

		// #when
		const result = await functionName(input);

		// #then
		expect(result).toBeDefined();
	});

	it('should reject invalid input', async () => {
		// #given
		const input = '';

		// #when & #then
		await expect(functionName(input)).rejects.toThrow();
	});
});
```

3. **Test categories to cover**:
   - Happy path (valid inputs)
   - Error cases (invalid inputs, failures)
   - Edge cases (empty strings, null, boundaries)
   - Security cases (path traversal attempts, injection payloads)

4. **Testing guidelines**:
   - One logical assertion per test
   - Mock external systems (APIs, databases)
   - Never mock the code being tested
   - Reset mocks between test cases
   - Use descriptive test names explaining each scenario

5. **Output**: Create test files and report what was generated.
