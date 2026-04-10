#!/bin/bash
VAULT="/Users/dada/PJ/AAA/selfish-aaa"
SITE="/Users/dada/PJ/AAA/selfish-aaa-site-astro"
CONTENT="$SITE/src/content"
IMAGES="$SITE/public/images"

mkdir -p "$CONTENT/gallery" "$CONTENT/insights" "$CONTENT/tools" "$CONTENT/analysis" "$CONTENT/proposals" "$CONTENT/missions"
mkdir -p "$IMAGES"

# 이미지 복사: vault 루트의 이미지 파일들
find "$VAULT" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.webp" -o -name "*.svg" \) -exec cp {} "$IMAGES/" \;

# 미션 하위폴더 이미지도 복사 (URL 디코딩된 폴더명)
find "$VAULT/00_주차별미션/" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.webp" \) -exec cp {} "$IMAGES/" \;

echo "이미지 동기화: $(find "$IMAGES" -type f | wc -l)개 파일"

# 미션 파일: Week_0N_ 패턴만, 이미지 경로를 /aaa-archive/images/ 로 변환
find "$VAULT/00_주차별미션/" -name "Week_0*.md" -size +10c | while read f; do
  filename=$(basename "$f")
  # ![[image.png]] → ![image](/aaa-archive/images/image.png)
  # ![alt](any/path/image.png) → ![alt](/aaa-archive/images/image.png)
  # ![alt](image.png) → ![alt](/aaa-archive/images/image.png)
  sed -E \
    -e 's/!\[\[([^]]+)\]\]/![\1](\/aaa-archive\/images\/\1)/g' \
    -e 's/!\[([^]]*)\]\(([^)]*\/)?([^)]+\.(png|jpg|jpeg|gif|webp|svg))\)/![\1](\/aaa-archive\/images\/\3)/g' \
    "$f" > "$CONTENT/missions/$filename"
done

find "$VAULT/01_결과물갤러리/" -name "*.md" -exec cp {} "$CONTENT/gallery/" \; 2>/dev/null
find "$VAULT/02_인사이트/" -name "*.md" -exec cp {} "$CONTENT/insights/" \; 2>/dev/null
find "$VAULT/03_스킬_플러그인/" -name "*.md" -exec cp {} "$CONTENT/tools/" \; 2>/dev/null
find "$VAULT/_분석/주차별분석/" -name "*.md" -exec cp {} "$CONTENT/analysis/" \; 2>/dev/null
find "$VAULT/_제안/" -name "*.md" -exec cp {} "$CONTENT/proposals/" \; 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
