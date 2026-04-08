// @ts-check
import { defineConfig } from 'astro/config';
import tailwindcss from '@tailwindcss/vite';

// Obsidian ![[image]] 문법을 제거하는 remark 플러그인
function remarkRemoveObsidianImages() {
  return (tree) => {
    const visit = (node) => {
      if (node.children) {
        node.children = node.children.filter(child => {
          // ![[...]] 패턴의 텍스트 노드 제거
          if (child.type === 'paragraph' && child.children) {
            const text = child.children.map(c => c.value || c.url || '').join('');
            if (text.match(/!\[\[.*\]\]/)) return false;
          }
          return true;
        });
        node.children.forEach(visit);
      }
    };
    visit(tree);
  };
}

export default defineConfig({
  site: 'https://selfishclub-all.github.io',
  base: '/aaa-archive/',
  output: 'static',
  markdown: {
    remarkPlugins: [remarkRemoveObsidianImages],
  },
  vite: {
    plugins: [tailwindcss()],
  },
});
