#!/bin/bash
VAULT="/Users/dada/PJ/AAA/selfish-aaa"
SITE="/Users/dada/PJ/AAA/selfish-aaa-site-astro"
CONTENT="$SITE/src/content"
IMAGES="$SITE/public/images"

mkdir -p "$CONTENT/gallery" "$CONTENT/insights" "$CONTENT/tools" "$CONTENT/analysis" "$CONTENT/proposals" "$CONTENT/missions"
mkdir -p "$IMAGES"

# 이미지 복사: 파일명 공백→언더스코어로 변환하여 복사
copy_image() {
  local src="$1"
  local name=$(basename "$src" | tr ' ' '_')
  cp "$src" "$IMAGES/$name"
}

find "$VAULT" -maxdepth 1 -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.webp" -o -name "*.svg" \) | while read f; do
  copy_image "$f"
done

find "$VAULT/00_주차별미션/" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.webp" \) | while read f; do
  copy_image "$f"
done

# _attachments 폴더 (이미지 + 영상)
find "$VAULT/_attachments/" -type f \( -name "*.png" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.gif" -o -name "*.webp" -o -name "*.svg" -o -name "*.mp4" \) 2>/dev/null | while read f; do
  copy_image "$f"
done

echo "이미지 동기화: $(find "$IMAGES" -type f | wc -l)개 파일"

# 미션 파일: Week_0N_ 패턴만, 이미지 경로 변환 (공백→언더스코어)
# 모든 미션 파일 (Week_0* + 보조 문서)
find "$VAULT/00_주차별미션/" -name "*.md" -size +10c | while read f; do
  filename=$(basename "$f")
  # 1) ![[image.png]] → ![image](/aaa-archive/images/image.png)
  # 2) ![alt](path/image.png) → ![alt](/aaa-archive/images/image.png)
  # 3) 이미지 URL 내 공백을 언더스코어로 변환
  sed -E \
    -e 's/!\[\[([^]|]+)\|[0-9]+\]\]/![\1](\/images\/\1)/g' \
    -e 's/!\[\[([^]]+)\]\]/![\1](\/images\/\1)/g' \
    -e 's/!\[([^]]*)\]\(([^)]*\/)?([^)]+\.(png|jpg|jpeg|gif|webp|svg))\|[0-9]+\)/![\1](\/images\/\3)/g' \
    -e 's/!\[([^]]*)\]\(([^)]*\/)?([^)]+\.(png|jpg|jpeg|gif|webp|svg))\)/![\1](\/images\/\3)/g' \
    -e 's/!\[([^]]*)\]\(([^)]*\/)?([^)]+\.mp4)\)/<video src="\/images\/\3" controls style="max-width:100%;border-radius:8px;"><\/video>/g' \
    "$f" | perl -pe 's{(\(/images/|src="/images/)([^)"]+)([)"])}{my $p=$1; my $n=$2; my $e=$3; $n=~s/ /_/g; "$p$n$e"}ge' \
    | sed -E 's/\[\[([^]|]+)\]\]/[\1](\/missions\/\1\/)/g' \
    | sed -E 's/\[\[([^]|]+)\|([^]]+)\]\]/[\2](\/missions\/\1\/)/g' \
    > "$CONTENT/missions/$filename"
done

find "$VAULT/01_결과물갤러리/" -name "*.md" -exec cp {} "$CONTENT/gallery/" \; 2>/dev/null
find "$VAULT/02_인사이트/" -name "*.md" -exec cp {} "$CONTENT/insights/" \; 2>/dev/null
find "$VAULT/03_스킬_플러그인/" -name "*.md" -exec cp {} "$CONTENT/tools/" \; 2>/dev/null
find "$VAULT/_분석/주차별분석/" -name "*.md" -exec cp {} "$CONTENT/analysis/" \; 2>/dev/null
find "$VAULT/_제안/" -name "*.md" -exec cp {} "$CONTENT/proposals/" \; 2>/dev/null

echo "동기화 완료: $(find "$CONTENT" -name '*.md' | wc -l)개 파일"
