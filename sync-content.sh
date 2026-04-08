#!/bin/bash
VAULT="/Users/dada/PJ/AAA/selfish-aaa"
CONTENT="/Users/dada/PJ/AAA/selfish-aaa-site-astro/src/content"

mkdir -p "$CONTENT/gallery" "$CONTENT/insights" "$CONTENT/tools" "$CONTENT/analysis" "$CONTENT/proposals" "$CONTENT/missions"

# 미션 파일: Week_0N_ 패턴만, 이미지 참조 제거 후 텍스트만 sync
find "$VAULT/00_주차별미션/" -name "Week_0*.md" -size +10c | while read f; do
  filename=$(basename "$f")
  # 이미지 참조 라인 제거 (![[...]], ![...](...))
  sed '/!\[\[.*\]\]/d; /!\[.*\](.*)/d' "$f" > "$CONTENT/missions/$filename"
done

find "$VAULT/01_결과물갤러리/" -name "*.md" -exec cp {} "$CONTENT/gallery/" \; 2>/dev/null
find "$VAULT/02_인사이트/" -name "*.md" -exec cp {} "$CONTENT/insights/" \; 2>/dev/null
find "$VAULT/03_스킬_플러그인/" -name "*.md" -exec cp {} "$CONTENT/tools/" \; 2>/dev/null
find "$VAULT/_분석/주차별분석/" -name "*.md" -exec cp {} "$CONTENT/analysis/" \; 2>/dev/null
find "$VAULT/_제안/" -name "*.md" -exec cp {} "$CONTENT/proposals/" \; 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
