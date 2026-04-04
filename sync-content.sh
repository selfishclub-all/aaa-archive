#!/bin/bash
VAULT="/Users/dada/PJ/AAA/selfish-aaa"
CONTENT="/Users/dada/PJ/AAA/selfish-aaa-site-astro/src/content"

mkdir -p "$CONTENT/gallery" "$CONTENT/insights" "$CONTENT/tools" "$CONTENT/analysis" "$CONTENT/proposals"

# 미션 파일은 이미지 참조가 많아 직접 sync하지 않음
# 대신 /analyze로 생성된 _분석/ 데이터가 AI 분석 탭에 표시됨
find "$VAULT/01_결과물갤러리/" -name "*.md" -exec cp {} "$CONTENT/gallery/" \; 2>/dev/null
find "$VAULT/02_인사이트/" -name "*.md" -exec cp {} "$CONTENT/insights/" \; 2>/dev/null
find "$VAULT/03_스킬_플러그인/" -name "*.md" -exec cp {} "$CONTENT/tools/" \; 2>/dev/null
find "$VAULT/_분석/주차별분석/" -name "*.md" -exec cp {} "$CONTENT/analysis/" \; 2>/dev/null
find "$VAULT/_제안/" -name "*.md" -exec cp {} "$CONTENT/proposals/" \; 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
