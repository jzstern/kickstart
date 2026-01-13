# Deployment Templates

These templates configure deployment for common hosting platforms.

## Template Variables

| Variable | Description | Example |
|----------|-------------|---------|
| `{{PROJECT_NAME}}` | Project name (kebab-case) | `my-app` |
| `{{FRAMEWORK}}` | Vercel framework preset | `sveltekit`, `nextjs` |
| `{{BUILD_COMMAND}}` | Build command | `bun run build` |
| `{{DEV_COMMAND}}` | Dev server command | `bun run dev` |
| `{{DEV_PORT}}` | Dev server port | `5173` |
| `{{OUTPUT_DIR}}` | Build output directory | `build`, `.next`, `dist` |
| `{{INSTALL_COMMAND}}` | Package install command | `bun install` |

## Framework Presets

### SvelteKit
- **Vercel**: `framework: sveltekit`, `outputDirectory: .svelte-kit`
- **Netlify**: Uses `@sveltejs/adapter-netlify`
- **Cloudflare**: Uses `@sveltejs/adapter-cloudflare`

### Next.js
- **Vercel**: `framework: nextjs`, `outputDirectory: .next`
- **Netlify**: Uses `@netlify/plugin-nextjs`
- **Cloudflare**: Uses `@cloudflare/next-on-pages`

### Astro
- **Vercel**: `framework: astro`, `outputDirectory: dist`
- **Netlify**: `outputDirectory: dist`
- **Cloudflare**: Uses `@astrojs/cloudflare`

## Adapter Installation

Some frameworks require platform-specific adapters:

```bash
# SvelteKit + Vercel
bun add -D @sveltejs/adapter-vercel

# SvelteKit + Netlify
bun add -D @sveltejs/adapter-netlify

# SvelteKit + Cloudflare
bun add -D @sveltejs/adapter-cloudflare
```
