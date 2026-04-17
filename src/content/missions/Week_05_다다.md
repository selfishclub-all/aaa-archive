---
member: 다다
week: 4
date: 2026-04-12
tags:
  - 과제
  - 웹사이트
  - 어드민
---

## 결과물

### 1. AAA TEAM 공식 홈페이지

🔗 [aaa-homepage.vercel.app](https://aaa-homepage.vercel.app)

Obsidian vault에 멤버들이 작성한 과제, 인사이트, 도구 정보를 외부에 공개하는 웹사이트를 만들었다.(Vercel로 배포) 

![homepage-screenshot.png](/images/homepage-screenshot.png)

**주요 페이지:**
- 메인 랜딩 — 슬로건 + 최근 주간 미션 + 컨택 폼
- 주간 미션 — 주차별 멤버 과제 카드, 클릭하면 상세 내용 모달
- 인사이트 — 멤버들이 발견한 생각과 아이디어 (키워드 필터)
- 도구 모음 — 실전에서 검증한 스킬/플러그인 (카테고리 필터)
- 갤러리 — 배포된 프로젝트 쇼케이스
- AI 분석 — 주간 분석 리포트
- 팀소개 — 9명 멤버 카드

### 2. 어드민 페이지

🔗 [aaa-homepage.vercel.app/admin/](https://aaa-homepage.vercel.app/admin/)

#### frontmatter란?

마크다운 파일 맨 위에 `---`로 감싼 영역을 frontmatter라고 한다. 본문 내용이 아니라, 그 파일에 대한 **메타 정보**(이름, 카테고리, 작성자 등)를 적어두는 곳이다. 웹사이트가 이 정보를 읽어서 필터, 정렬, 카드 표시 등에 활용한다.

```markdown
---
name: "Sullivan"
category: "분석"
type: "Claude Code 스킬"
difficulty: "고급"
added_by: "흐민"
---

여기부터가 본문 내용...
```

위 예시에서 `---` 안쪽이 frontmatter, 바깥이 본문이다. 웹사이트의 도구 모음 페이지에서 "분석" 카테고리 필터를 누르면 이 파일이 걸러져서 보이는 식이다.

이걸 멤버들이 직접 텍스트로 수정하기에는 형식이 까다롭고 실수가 나기 쉽다.

그래서 운영자가 웹 브라우저에서 드롭다운, 입력 폼으로 편하게 수정할 수 있는 어드민 페이지를 만들었다. 보통 이런 관리 페이지를 만들려면 별도 서버가 필요하고 비용이 드는데, 이 어드민은 **브라우저가 직접 GitHub에 파일 수정 요청을 보내는 방식**(GitHub API)이라 서버가 필요 없다. 비용 0원.

![admin-screenshot.png](/images/admin-screenshot.png)

**동작 방식:**
1. GitHub Personal Access Token 입력 (최초 1회)
2. 갤러리 / 도구 모음 / 인사이트 탭 선택
3. 파일 클릭 → frontmatter 편집 폼
4. 저장 → GitHub에 직접 커밋 → Vercel이 자동 재배포

### 3. 슬래시 명령어로 운영 자동화

Claude Code에서 `/명령어`를 입력하면 자동으로 실행되는 커스텀 명령어 5개를 만들었다. 이 명령어들이 vault의 콘텐츠를 분석하고, 가공하고, 웹사이트까지 자동으로 배포해준다.

| 명령어          | 역할             | 실행 결과                   |
| ------------ | -------------- | ----------------------- |
| `/analyze N` | N주차 통합 분석      | `_분석/` 폴더에 AI 분석 리포트 생성 |
| `/propose`   | 스킬 제안 + 봇 인사이트 | `_제안/` 폴더에 제안 문서 생성     |
| `/ln N`      | N주차 링크드인 초안    | `_링크드인초안/`에 멤버별 포스트 생성  |

### 명령어들이 웹사이트 배포까지 연결되는 흐름

```
 ┌──────────────────────────────────────────────────────┐
 │  멤버들이 Obsidian에서 과제를 작성한다                    │
 │  (00_주차별미션/, 02_인사이트/, 03_스킬_플러그인/)          │
 └──────────────────────┬───────────────────────────────┘
                        │
                        ▼
 ┌──────────────────────────────────────────────────────┐
 │  운영자가 Claude Code에서 명령어를 실행한다                │
 │                                                      │
 │  /analyze 4  →  멤버 과제를 AI가 분석해서 리포트 생성      │
 │  /propose    →  분석 데이터로 새로운 스킬/프로젝트 제안     │
 │  /ln 4       →  각 멤버의 과제를 링크드인 포스트로 변환     │                      │
 └──────────────────────┬───────────────────────────────┘
                        │
                        ▼
 ┌──────────────────────────────────────────────────────┐
 │  /publish  →  모든 걸 웹사이트에 한 번에 배포              │
 │                                                      │
 │  ① frontmatter 자동 정리                               │
 │  ② 메인 페이지 최신 주차 반영                             │
 │  ③ vault 공개 폴더 → Astro 프로젝트로 복사                │
 │     (비공개 폴더는 복사하지 않음 — 출석/벌금/링크드인 초안 등) │
 │  ④ 빌드 (마크다운 → HTML 변환)                          │
 │  ⑤ GitHub push → Vercel 자동 재배포                    │
 └──────────────────────┬───────────────────────────────┘
                        │
                        ▼
 ┌──────────────────────────────────────────────────────┐
 │  🌐 aaa-homepage.vercel.app 에 반영 완료!               │
 │                                                      │
 │  /archive/   ← 주간 미션 (멤버 과제)                     │
 │  /insights/  ← 인사이트                                │
 │  /tools/     ← 도구 모음                               │
 │  /analysis/  ← AI 분석 리포트  ← /analyze로 생성한 것     │
 │  /gallery/   ← 결과물 갤러리                             │
 └──────────────────────────────────────────────────────┘
```

**핵심:** 멤버들은 Obsidian에서 과제만 쓰면 된다. 명령어는 누구나 쓸 수 있지만, 주로 운영자가 실행한다.

### 요약, 태그, 분석은 어떻게 자동으로 만들어지나?

멤버들이 해야 할 일은 **Obsidian에서 글을 쓰는 것뿐**이다. 나머지는 AI가 내용을 읽고 자동으로 처리한다.

#### 주차별 분석 요약 (`/analyze N`)

`/analyze 4`를 실행하면 Claude가 해당 주차 멤버 과제를 전부 읽고, AI 분석 리포트를 자동 생성한다. 이렇게 생성된 리포트가 웹사이트의 "AI 분석" 페이지에 표시된다:

![analysis-screenshot.png](/images/analysis-screenshot.png)

```
/analyze 4 실행
    │
    ▼
Week_04/ 폴더의 멤버 과제 전부 읽기
    │
    ▼
Claude가 내용 분석
    │
    ├── "이번 주 핵심 발견" 한 줄 요약
    ├── 멤버별 인사이트 정리 (닉네임 없이, 에디토리얼 톤)
    ├── 주간 트렌드 도출
    └── 다음 주 제안
    │
    ▼
_분석/주차별분석/Week_04_분석.md 에 저장
    │
    ▼
/publish 하면 → 웹사이트 "AI 분석" 페이지에 표시
```

#### 인사이트 요약 + 키워드 자동 태깅 (`/publish` Step 0)

멤버가 `02_인사이트/` 폴더에 글을 쓸 때, frontmatter 없이 본문만 써도 된다. `/publish` 실행 시 Claude가 자동으로 처리해준다.

```
멤버가 인사이트 글 작성 (frontmatter 없이 본문만)
    │
    ▼
/publish 실행 → Step 0: frontmatter 자동 정리
    │
    ▼
Claude가 본문을 읽고 자동 생성:
    │
    ├── keywords: ["디자인", "Stitch", "UI/UX"]  ← 본문에서 핵심 키워드 추출
    ├── summary: "Google Stitch로 디자인하고..."   ← 한 줄 요약 생성
    └── frontmatter를 파일 상단에 추가
    │
    ▼
웹사이트 "인사이트" 페이지에서 키워드 필터로 검색 가능
```

**예시 — 멤버가 쓴 원본:**
```markdown
AI와 코딩을 처음 시작하면 누구나 같은 경험을 한다.
기능은 잘 나오는데 디자인이 어색하다...
DESIGN.md라는 해법이 나왔다...
```

**`/publish` 후 자동 추가된 frontmatter:**
```markdown
---
keywords: ["DESIGN.md", "AI 디자인", "프레임워크", "Google Stitch", "디자인 시스템"]
summary: "AI가 만든 결과물의 디자인 완성도를 높이는 DESIGN.md 프레임워크 소개."
---

AI와 코딩을 처음 시작하면 누구나 같은 경험을 한다.
(이하 원본 그대로 유지)
```

#### 스킬/도구 자동 분류 (`/publish` Step 0)

`03_스킬_플러그인/` 폴더에 도구 정보를 아무 형식으로 적어도, `/publish` 시 Claude가 내용을 읽고 자동으로 분류한다.

```
멤버가 도구 정보 작성 (형식 자유)
    │
    ▼
/publish → Claude가 자동 판단:
    │
    ├── name: "Sullivan"              ← 도구 이름
    ├── category: "분석"              ← 내용 기반 (자동화/콘텐츠/분석/생산성/디자인)
    ├── type: "Claude Code 스킬"      ← 도구 유형
    ├── difficulty: "고급"            ← 난이도
    └── link: "https://github.com/..." ← 본문에서 URL 추출
    │
    ▼
웹사이트 "도구 모음" 페이지에서 카테고리별 필터로 표시
```

**한 줄 정리:** 멤버는 내용만 쓰면 된다. 요약, 태그, 분류는 `/publish` 할 때 Claude가 자동으로 붙여준다.

#### 자동 생성된 내용을 수정하고 싶다면? → 어드민

AI가 자동으로 붙여준 키워드나 카테고리가 마음에 안 들 수도 있다. 예를 들어 "이 도구는 '분석'이 아니라 '자동화'로 분류해야 하는데?" 같은 경우다.

이때 마크다운 파일을 직접 열어서 frontmatter를 텍스트로 고치는 건 번거롭고 실수하기 쉽다. 그래서 **어드민 페이지**를 만들었다.

> **GUI란?** Graphical User Interface의 약자로, 텍스트 코드를 직접 수정하는 대신 **버튼, 드롭다운, 입력 폼 같은 시각적 화면**으로 조작하는 방식을 말한다. 우리가 매일 쓰는 앱, 웹사이트가 다 GUI다.

어드민 페이지에서는 이렇게 수정한다:

```
❌ 텍스트로 직접 수정 (어렵고 실수 가능)
---
category: "분석"        ← 이걸 "자동화"로 바꿔야 하는데
difficulty: "고급"         형식 틀리면 사이트가 깨진다
---

✅ 어드민 GUI로 수정 (쉽고 안전)
┌─────────────────────┐
│ 카테고리: [자동화 ▾]    │  ← 드롭다운에서 선택만 하면 됨
│ 난이도:   [고급  ▾]    │
│ [저장]               │  ← 클릭하면 자동 반영
└─────────────────────┘
```

어드민 주소: [aaa-homepage.vercel.app/admin/](https://aaa-homepage.vercel.app/admin/)
| `/publish`   | **웹사이트 배포**        | vault → 빌드 → Vercel 자동 배포 |

### /publish 로 웹사이트가 배포되는 과정

```
/publish 입력
    │
    ▼
Step 0: frontmatter 없는 파일 자동 정리
    │   (스킬/인사이트 폴더 스캔, 태그/요약 자동 생성)
    ▼
Step 0.5: 메인 페이지 최신 주차 업데이트
    │   (index.astro의 latestWeek 데이터 갱신)
    ▼
Step 1: sync-content.sh 실행
    │   (vault의 공개 폴더 6개만 → Astro 프로젝트로 복사)
    │   (이미지 파일명 공백→언더스코어 변환)
    │   (Obsidian  → 표준 마크다운 이미지 변환)
    ▼
Step 2: npm run build
    │   (Astro가 마크다운을 HTML로 변환, 정적 사이트 생성)
    ▼
Step 3: git push selfishclub main
    │   (selfishclub/aaa-admin 레포에 push)
    ▼
Vercel이 push를 감지 → 자동 재배포
    │
    ▼
aaa-homepage.vercel.app 에 반영 완료!
```

즉, 멤버들은 Obsidian에서 과제만 작성하면 되고, 운영자가 `/publish` 한 번 실행하면 웹사이트에 자동 반영된다.

---

## 삽질 과정: 무료로 배포하기까지의 여정

### GitHub Pages로 시작했다가 Vercel로 옮긴 이유

처음에는 GitHub Pages로 배포했다. Organization 레포(`selfishclub-all/aaa-archive`)에서 바로 배포하니까 간단했다. 하지만 어드민 페이지를 추가하려고 보니 문제가 생겼다. Vercel로 옮기려 했지만, Vercel Hobby(무료) 플랜에서는 Organization 레포를 1개만 배포할 수 있는데 이미 다른 프로젝트가 그 자리를 쓰고 있었다. 결국 개인 계정(`selfishclub`)에 레포를 복사해서 Vercel에 배포하는 방식으로 우회했다.

**어드민은 Vercel이 필요했다.**

> **순수 정적 파일이란?** HTML, CSS, 이미지처럼 한 번 만들어 놓으면 그대로 보여주기만 하는 파일이다. 서버가 뭔가 계산하거나 외부에 요청을 보내는 건 못 한다. GitHub Pages는 이런 정적 파일만 서빙(전달)할 수 있다.

비유하면 이렇다:
- **GitHub Pages** = 전단지를 출력해서 나눠주는 것. 이미 인쇄된 종이라서 내용을 바꿀 수 없다. 누가 "이거 수정해줘"라고 해도 "나는 나눠주기만 해"라고 밖에 못 한다.
- **Vercel** = 직원이 있는 안내 데스크. 손님이 요청하면 뒤에서 전화도 걸고(GitHub API 호출), 서류도 수정하고(파일 편집), 결과를 돌려줄 수 있다.

어드민 페이지는 GitHub에 있는 파일을 수정해야 하니까, "전단지"인 GitHub Pages로는 불가능하고 "안내 데스크"인 Vercel이 필요했다.

### Organization에서 Vercel 배포가 안 되는 문제

Vercel 무료 플랜에서는 **Organization 레포 중 1개만 배포 가능**한데, 우리 Organization(`selfishclub-all`)에서 이미 다른 프로젝트가 그 자리를 쓰고 있었다.

```
selfishclub-all (Organization)
├── aaa          ← vault (배포 불필요)
├── aaa-archive  ← 웹사이트 (Vercel 배포하고 싶은데 못함!)
└── 다른 프로젝트   ← 이미 Vercel 연결됨
```

### 해결: 개인 계정으로 레포 복사

Organization이 아닌 개인 계정(`selfishclub`)에 레포를 복사하면 Vercel 무료 배포가 가능하다.

```bash
# 개인 계정에 레포 생성
gh repo create selfishclub/aaa-admin --private

# 기존 히스토리 전체 복사
git remote add selfishclub https://github.com/selfishclub/aaa-admin.git
git push selfishclub main
```

### 개인 계정도 잘못 골랐다

처음에는 내 개발용 계정(`tomost-dada`)에 레포를 만들었다. 하지만 Vercel 프로젝트를 `selfishclub` 계정으로 만들었기 때문에, `tomost-dada` 레포에서 push하면 Vercel이 "이 레포는 내 프로젝트가 아닌데?"라고 인식하는 문제가 생겼다.

결국 `selfishclub` 계정에 레포(`selfishclub/aaa-admin`)를 다시 만들고, 기존 히스토리를 전부 복사해서 옮겼다. `tomost-dada/aaa-archive`는 예비용으로 남겨두었다.

```
처음:  tomost-dada/aaa-archive     ← Vercel 소유자와 불일치
최종:  selfishclub/aaa-admin       ← Vercel 소유자와 일치 ✓
```

### 또 다른 함정: 커밋 작성자 제한

push까지 성공했는데 Vercel이 배포를 거부했다.

> "The Deployment was blocked because the commit author does not have contributing access to the project on Vercel."

**원인:** Vercel Hobby(무료) 플랜에서는 "커밋한 사람 = Vercel 프로젝트 소유자"여야 배포가 된다. 내가 `tomost-dada` 계정으로 커밋했는데 Vercel 프로젝트 소유자는 `selfishclub`이라서, Vercel이 "이 커밋은 우리 팀 사람이 아닌데?"라고 판단하고 배포를 막은 것이다. 유료(Pro) 플랜이면 팀 협업이 가능해서 이런 제한이 없지만, 무료에서는 1인 1계정만 허용된다.

**해결:** 해당 레포의 git config를 Vercel 소유자 계정과 일치시켰다. 이렇게 하면 커밋할 때 작성자가 `selfishclub`으로 기록되어 Vercel이 정상 배포한다.

> **git config란?** Git으로 코드를 저장(커밋)할 때마다 "누가 이걸 저장했는지" 이름과 이메일이 자동으로 기록된다. 비유하면 택배 보낼 때 보내는 사람 이름을 적는 것과 같다. `git config`는 그 "보내는 사람 이름"을 설정하는 명령어다. Vercel은 택배에 적힌 이름이 자기가 아는 사람이 아니면 수거를 거부한다 — 그래서 이름을 맞춰야 했다.

```bash
cd selfish-aaa-site-astro
git config user.name "selfishclub"
git config user.email "public.selfishclub@gmail.com"
```


---

## 최종 구조

![repo-architecture.png](/images/repo-architecture.png)

**레포 2개로 운영:**
- `selfishclub-all/aaa` (Private) — Obsidian Vault, 멤버 작업 공간
- `selfishclub/aaa-admin` (Public) — 홈페이지 + 어드민, Vercel 배포

vault의 공개 폴더(주차별미션, 갤러리, 인사이트, 도구, 분석, 제안)만 홈페이지에 반영되고, 비공개 폴더(현황, 링크드인초안, 기타, 회의)는 반영되지 않는다.

---

## 인사이트

### Vercel vs GitHub Pages

| 항목           | GitHub Pages         | Vercel                  |
| ------------ | -------------------- | ----------------------- |
| 가격           | 무료                   | 무료 (Hobby)              |
| 빌드           | GitHub Actions 설정 필요 | 자동 감지                   |
| 서버사이드        | 불가 (순수 정적만)          | Serverless Functions 가능 |
| Organization | 제한 없음                | 무료 1개만                  |
| 커스텀 도메인      | 지원                   | 지원                      |
| 배포 속도        | 1~3분                 | 30초~1분                  |

> **정적 사이트란?** 모든 방문자에게 똑같은 페이지를 보여주는 사이트다. 비유하면 **PDF 문서** — 한 번 만들어 놓으면 누가 열어도 같은 내용이 보인다. 반대로 네이버에 로그인하면 내 메일함이 보이는 건 **동적 사이트**다. 우리 홈페이지는 모두에게 같은 과제/인사이트를 보여주니까 정적 사이트로 충분하다. 다만 어드민처럼 "파일을 수정하는 기능"이 붙으면 서버가 필요해진다.

**결론:** 정적 사이트(모두에게 같은 페이지)는 GitHub Pages로 충분하지만, 어드민이나 API가 필요하면 Vercel이 낫다. 다만 Organization 레포를 쓸 거면 Vercel 무료 플랜의 제한을 미리 파악해야 한다.

### Obsidian 이미지 문법은 웹에서 안 된다

Obsidian에서 이미지를 붙여넣으면 `` 형태로 삽입된다. 이건 Obsidian 앱 안에서만 통하는 전용 문법이다. 웹 브라우저는 이 문법을 모르기 때문에 홈페이지에서는 이미지가 안 보이고 깨진 텍스트만 나온다.

비유하면, 카카오톡에서 보낸 이모티콘이 이메일에서는 안 보이는 것과 같다 — 플랫폼마다 이미지를 표시하는 방식이 다르기 때문이다.

이 문제를 해결하기 위해 `/publish` 할 때 자동으로 처리되도록 만들었다:
1. Obsidian의 이미지 파일을 웹사이트 폴더로 복사
2. Obsidian 전용 문법을 웹 브라우저가 이해하는 형식으로 자동 변환

멤버들은 신경 쓸 필요 없이, Obsidian에서 평소처럼 이미지를 붙여넣으면 된다.

**교훈:** 이미지 파일명에 한글이나 공백이 들어가면 웹에서 깨질 수 있다. 가능하면 파일명은 영어로 쓰는 게 안전하다.

### 무료 플랜의 숨겨진 제약을 미리 파악하라

이번에 마주친 무료 플랜 제약 목록:
- **Vercel**: Organization 레포 1개만 배포 가능
- **Vercel**: 커밋 작성자 ≠ 프로젝트 소유자이면 배포 차단
- **GitHub Pages**: private 레포는 무료 배포 불가 (Pro 필요)
- **Vercel**: 무료 플랜에서 팀 협업(Hobby team) 불가

이걸 미리 알았으면 레포를 3개나 만들 필요가 없었다. **새로운 서비스를 쓸 때는 "무료 플랜 제한사항"을 먼저 검색하자.**

### GitHub 계정이 여러 개면 헷갈린다

이번에 3개 계정을 오갔다: `selfishclub-all`(Organization), `tomost-dada`(개인 개발), `selfishclub`(개인 서비스). 레포 소유자, Vercel 소유자, git 커밋 작성자가 각각 다른 계정이라 배포가 안 되는 원인을 찾는 데 시간이 걸렸다.

**교훈:** 프로젝트 시작 전에 "어떤 계정으로 레포를 만들고, 어떤 계정으로 배포할지" 먼저 정하자. 나중에 옮기면 히스토리 복사, 리모트 재설정, git config 변경 등 삽질이 배로 늘어난다.

---

## 다시 한다면

1. **Organization 레포를 쓰지 않겠다** — Vercel 무료 플랜에서 Organization은 1개 제한이 있어서, 처음부터 개인 계정 레포로 만들면 이런 삽질을 안 해도 된다.

2. **어드민까지 고려해서 처음부터 기획하겠다** — 웹사이트만 만들고 나중에 어드민을 붙이려니 레포 구조를 바꿔야 했다. 처음부터 "홈페이지 + 어드민"을 한 레포에서 운영할 계획으로 시작했으면 레포가 3개까지 늘어나는 일은 없었을 것이다.

3. **Vercel 배포를 먼저 선택하겠다** — GitHub Pages는 설정이 간단하지만, 나중에 기능을 추가하려면 결국 Vercel로 옮기게 된다. 처음부터 Vercel로 가면 마이그레이션 비용이 없다.

4. **무료 플랜 제약을 먼저 조사하겠다** — "되겠지"하고 시작하면 중간에 막혀서 구조를 바꿔야 한다. 10분 조사가 3시간 삽질을 아껴준다.
	  이번에 마주친 무료 플랜 제약 목록:
	- **Vercel**: Organization 레포 1개만 배포 가능
	- **Vercel**: 커밋 작성자 ≠ 프로젝트 소유자이면 배포 차단
	- **GitHub Pages**: private 레포는 무료 배포 불가 (Pro 필요)
	- **Vercel**: 무료 플랜에서 팀 협업(Hobby team) 불가

 **새로운 서비스를 쓸 때는 "무료 플랜 제한사항"을 먼저 검색하자.

---

**투입 시간:** 약 8~10시간 (웹사이트 6~7시간 + 배포 삽질 2~3시간)
**기술 스택:** Astro + Tailwind CSS v4 + Vercel + GitHub API
**슬래시 명령어:** /publish (sync → build → push → 자동 배포)
