# Deployment Templates

Vercel deployment configuration template.

## Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name (kebab-case) | `my-app` |
| `{{FRAMEWORK}}` | Vercel framework preset | `sveltekit`, `nextjs` |
| `{{BUILD_COMMAND}}` | Build command | `bun run build` |
| `{{DEV_COMMAND}}` | Dev server command | `bun run dev` |
| `{{OUTPUT_DIR}}` | Build output directory | `.svelte-kit`, `.next`, `dist` |
| `{{INSTALL_COMMAND}}` | Package install command | `bun install` |

## Framework Presets

| Framework | `{{FRAMEWORK}}` | `{{OUTPUT_DIR}}` |
|-----------|-----------------|------------------|
| SvelteKit | `sveltekit` | `.svelte-kit` |
| Next.js | `nextjs` | `.next` |
| Remix | `remix` | `build` |
| Astro | `astro` | `dist` |

## SvelteKit Adapter

For advanced Vercel features (edge functions, ISR), install the Vercel adapter:

```bash
bun add -D @sveltejs/adapter-vercel
```

Then update `svelte.config.js`:

```js
import adapter from '@sveltejs/adapter-vercel';

export default {
  kit: {
    adapter: adapter()
  }
};
```
