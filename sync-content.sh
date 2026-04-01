#!/bin/bash
# vault에서 공개 폴더만 Quartz content/로 동기화

VAULT="/Users/dada/PJ/AAA/selfish-aaa"
CONTENT="/Users/dada/PJ/AAA/selfish-aaa-site/content"

# 기존 콘텐츠 정리 (index.md는 유지)
find "$CONTENT" -name "*.md" ! -name "index.md" -delete 2>/dev/null

# 공개 폴더만 복사
mkdir -p "$CONTENT/개념" "$CONTENT/인사이트" "$CONTENT/제안" "$CONTENT/아카이브북"

cp "$VAULT/01_개념/"*.md "$CONTENT/개념/" 2>/dev/null
cp "$VAULT/02_인사이트/"*.md "$CONTENT/인사이트/" 2>/dev/null
cp "$VAULT/_제안/"*.md "$CONTENT/제안/" 2>/dev/null
cp "$VAULT/_아카이브북/"*.md "$CONTENT/아카이브북/" 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
