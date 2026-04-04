// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

export default defineConfig({
  site: 'https://selfishclub-all.github.io',
  base: '/aaa-archive/',
  output: 'static',
  vite: {
    plugins: [tailwindcss()],
  },
});
