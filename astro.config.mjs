// @ts-check
import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';

// https://astro.build/config
export default defineConfig({
  // Public URL, used for canonical and Open Graph links and the sitemap.
  site: 'https://jubierahammed.netlify.app',
  trailingSlash: 'ignore',
  integrations: [sitemap()],
});
