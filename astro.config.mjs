// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

const isVercel = !!process.env.VERCEL;
const base = isVercel ? '/' : '/aaa-archive/';
const site = isVercel ? 'https://aaa-homepage.vercel.app' : 'https://selfishclub-all.github.io';

// Obsidian ![[image]] 문법을 표준 마크다운 이미지로 변환하는 remark 플러그인
function remarkObsidianImages() {
  return (tree) => {
    const visit = (node) => {
      if (node.children) {
        node.children.forEach((child, i) => {
          if (child.type === 'paragraph' && child.children) {
            const newChildren = [];
            child.children.forEach(c => {
              if (c.type === 'text' && c.value && c.value.match(/!\[\[([^\]]+)\]\]/)) {
                const parts = c.value.split(/!\[\[([^\]]+)\]\]/);
                parts.forEach((part, idx) => {
                  if (idx % 2 === 0) {
                    if (part) newChildren.push({ type: 'text', value: part });
                  } else {
                    newChildren.push({
                      type: 'image',
                      url: `${base}images/${part}`,
                      alt: part,
                    });
                  }
                });
              } else {
                newChildren.push(c);
              }
            });
            child.children = newChildren;
          }
          visit(child);
        });
      }
    };
    visit(tree);
  };
}

export default defineConfig({
  site,
  base,
  output: 'static',
  markdown: {
    remarkPlugins: [remarkObsidianImages],
  },
  vite: {
    plugins: [tailwindcss()],
  },
});
