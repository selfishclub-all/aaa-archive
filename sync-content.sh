#!/bin/bash
VAULT="/Users/dada/PJ/AAA/selfish-aaa"
CONTENT="/Users/dada/PJ/AAA/selfish-aaa-site-astro/src/content"

mkdir -p "$CONTENT/concepts" "$CONTENT/insights" "$CONTENT/gallery" "$CONTENT/tools" "$CONTENT/analysis" "$CONTENT/proposals"

# Use find + cp to handle subdirectories
find "$VAULT/02_개념/" -name "*.md" -exec cp {} "$CONTENT/concepts/" \; 2>/dev/null
find "$VAULT/03_인사이트/" -name "*.md" -exec cp {} "$CONTENT/insights/" \; 2>/dev/null
find "$VAULT/04_갤러리/" -name "*.md" -exec cp {} "$CONTENT/gallery/" \; 2>/dev/null
find "$VAULT/05_플러그인_스킬/" -name "*.md" -exec cp {} "$CONTENT/tools/" \; 2>/dev/null
find "$VAULT/_분석/주차별분석/" -name "*.md" -exec cp {} "$CONTENT/analysis/" \; 2>/dev/null
find "$VAULT/_제안/" -name "*.md" -exec cp {} "$CONTENT/proposals/" \; 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
