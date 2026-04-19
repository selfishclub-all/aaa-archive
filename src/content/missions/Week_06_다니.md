# 하네스 엔지니어링 & 오케스트레이션 정리

## 1. 하네스 엔지니어링

### 개념

- AI에게 목줄을 채우는 기술임
- 강아지 산책할 때 하네스 채우는 것과 같은 원리, 똑똑해도 차도로 뛰어들면 안 되니까 물리적으로 제어하는 것
- AI도 똑똑해질수록 "자기 마음대로 일하는 문제"가 생김
- 프롬프트에 "빨간색 쓰지 마" 적어놔도 AI는 무시함
- 그래서 **말로 부탁하지 말고, 어기면 시스템이 강제로 멈추게 만들자**가 핵심 철학임

### 왜 지금 뜨는가

- OpenAI가 5개월간 개발자가 코드 한 줄 안 치고 AI만으로 서비스 만든 사례를 문서로 공개함
- 이들의 결론 = **"생산성의 병목은 인간이다"**
- AI는 코드를 초 단위로 뽑는데 인간은 테스트하느라 하루씩 걸림
- 답은 하나, 인간을 빼야 함

### 어떻게 적용하는가 — 3가지 축

**① AI에게 "눈" 달아주기 (가시성)**

- 예전엔 로그 지우는 게 일이었지만 이제는 반대임
- 로그, 스크린샷, DOM 스냅샷까지 다 남김
- AI가 자기 결과물을 "보고" 스스로 판단해서 고치게 하려는 것

**② 컨텍스트를 목차처럼 주기**

- 신입사원에게 500페이지 매뉴얼 한 번에 던지면 앞부분만 대충 봄
- AI도 똑같음
- 지침을 **목차화**해서 "필요할 때 네가 찾아가서 읽어" 방식으로 바꿈
- `CLAUDE.md`는 목차만 제공, 실제 규칙은 `/document` 폴더에 쪼개놓는 구조임

**③ CI/CD로 강제 제동 걸기 (진짜 하네스)**

- 이게 핵심임
- 말로 "하지 마"가 아니라 **어기면 코드가 에러 뱉고 멈추게** 만듦
- 계획 문서 없이 코드 작성 시도 → Husky pre-commit hook이 차단
- 메인 브랜치 직접 푸시 시도 → 훅에서 reject
- 테스트 통과 못 한 코드 커밋 시도 → `verify-task` 스크립트가 막음
- 커밋 메시지 형식 안 맞음 → commitlint가 거부

### 실전 적용 플로우 (OpenAI 방식)

- AI에게 "기능 추가해줘" 한마디면 시스템이 5단계를 강제함
- **① 플랜 문서 작성** — 계획 없이 코드 금지
- **② Git 워크트리 생성** — 메인 브랜치 보호하고 복사본에서 작업
- **③ 테스트 코드 먼저 작성** — TDD 방식
- **④ 린트·빌드·단위 테스트 강제 검증** — verify-task 스크립트가 돌림
- **⑤ 통과 시 자동 커밋 후 머지** — 커밋 메시지까지 AI가 정해진 형식대로 작성
- 인간은 처음에 요청만 하고 끝임

### 자율 피드백 루프

- AI가 중간에 "귀찮으니 워크트리 없이 바로 할래" 시도함
- 훅이 걸려서 "워크트리 없음, 다시 해"라고 튕겨냄
- AI가 워크트리 다시 만들어서 재시작함
- 이게 진짜 자율 피드백 루프임

---

## 2. 오케스트레이션

### 개념

- 오케스트라에 지휘자가 없으면 그냥 소음임
- 바이올린·첼로·트럼펫이 각자 잘해도 조율 없으면 망함
- **여러 AI 에이전트·도구·작업을 하나의 지휘 체계 아래 조율하는 기술**임

### 하네스 vs 오케스트레이션

|구분|하네스|오케스트레이션|
|---|---|---|
|핵심 질문|"이 AI가 선 안 넘게 하려면?"|"여러 AI를 어떻게 협업시키지?"|
|주 역할|제약(Constraint)|조율(Coordination)|
|비유|강아지 목줄|오케스트라 지휘자|
|주요 도구|Git hooks, linter, verify scripts|MCP, 에이전트 라우팅|

- 두 개념은 배타적이지 않고 **상호 보완적**임
- 잘 만든 시스템 = 하네스로 각 에이전트 가두고 + 오케스트레이션으로 합주시킴

### 어떻게 적용하는가

**① 역할 분리 (Agent Specialization)**

- "만능 AI 하나"보다 "전문가 AI 여러 명"이 훨씬 나음
- 플래너는 계획만, 코더는 구현만, 리뷰어는 검증만
- 각자 컨텍스트가 좁아져서 실수가 줄어듦

**② 작업 라우팅 (Task Routing)**

- 들어온 요청을 분석해서 어디로 보낼지 판단하는 "교통정리" 레이어를 둠
- "이미지 만들어줘" → 이미지 MCP
- "DB 조회해줘" → Supabase MCP
- "캘린더 확인" → Google Calendar MCP

**③ 상태 전달 (Context Handoff)**

- A 에이전트 결과를 B에게 넘길 때 **B가 필요한 것만 요약해서 전달**함
- 안 그러면 컨텍스트 윈도우 터지거나 B가 엉뚱한 거 참고해서 헛짓함

**④ 실패 복구 (Fallback & Retry)**

- A가 실패하면 B로 넘기거나 다른 방식으로 재시도
- 오케스트레이터의 책임임

---

## 3. 오케스트레이션에 탁월한 도구/플러그인

- **MCP (Model Context Protocol)** — Anthropic이 만든 표준, 오케스트레이션의 사실상 업계 표준임. Gmail·Slack·Notion·Supabase·Google Drive를 Claude가 네이티브 도구처럼 쓰게 해줌. 지금 쓰는 Claude 환경도 MCP 기반임
- **OMC (Orchestrator-Manager-Coder) 패턴** — 오케스트레이터가 매니저에게 계획 시키고, 매니저가 여러 코더에게 병렬로 일 분배하는 3-tier 구조임. 대형 작업에 특히 효과적임

---

## 최종 정리

- **하네스** = AI가 **"선 넘지 않게"** 하는 기술
- **오케스트레이션** = 여러 AI·도구가 **"같이 연주하게"** 만드는 기술
- 하네스 없는 오케스트레이션 = 무법지대
- 오케스트레이션 없는 하네스 = 혼자 똑똑한 외톨이 AI
- **둘 다 있어야** 진짜 "인간 개입 없이 돌아가는 시스템"이 만들어짐

# 인스타 캐러셀 에디터 하네스 엔지니어링 적용 현황 & 로드맵

## 🎯 프로젝트 개요

**젬마 캐러셀 에디터** ([https://zemma-carousel.vercel.app](https://zemma-carousel.vercel.app)) — 인스타그램 4:5 캐러셀을 React + Babel CDN 기반으로 제작하는 단일 HTML 에디터. AI 이미지 생성, MP4 다운로드, 멀티 플랫폼 캡션까지 통합된 개인용 툴.

**문제 인식:** index.html 1500줄 한 덩어리, 디자인 시스템 규칙이 코드에 흩어져 있음, AI가 수정할 때마다 어디를 봐야 할지 모르고 헤매는 상태. 하네스 없는 "바이브 코딩" 상태였음.

---

## 📍 현재 상태 진단

### 기존 워크플로우의 병목

- **AI가 수정할 때 매번 1500줄 전체 스캔** → 비효율
- **디자인 시스템 위반을 눈으로 검사** → 놓침
- **배포 전 검증 없음** → 배포 후 버그 발견
- **메인 브랜치 직접 수정** → 실수하면 복구 어려움
- **API 키 클라이언트 하드코딩** → 보안 리스크

### 적용 기준점

OpenAI의 하네스 엔지니어링 4축을 적용 기준으로 삼음:

1. **Legibility** — AI가 읽을 수 있는 지도
2. **Mechanical Enforcement** — 말이 아닌 코드로 강제
3. **Verification Loops** — 숫자로 명확한 검증 기준
4. **Docs as Map** — 목차 구조로 점진적 컨텍스트 공개

---

## ✅ Phase 1 — 문서 구조화 (진행 예정/오늘 실행)

**목표:** AI에게 지도를 쥐여주기. 코드 자동화 전에 최소한의 구조만 먼저.

### 실행 내용

|작업|결과물|효과|
|---|---|---|
|Git Worktree 도입|`../Carousel-harness-phase1`|메인 브랜치 보호|
|CLAUDE.md 목차 작성|100줄 이하 지도 파일|AI 진입점 확보|
|docs/ 폴더 분리|4개 규칙 문서|점진적 컨텍스트 공개|
|.gitignore 점검|API 키 노출 방지|보안 최소선|
|CHECKLIST.md|수동 검증 항목|Phase 2 자동화 전 브릿지|

### 생성할 파일 구조

```
carousel/
├── CLAUDE.md                 ← AI가 가장 먼저 읽는 목차
├── CHECKLIST.md              ← 커밋 전 수동 체크
├── docs/
│   ├── design-system.md      ← 색상/폰트/크기 규칙
│   ├── element-types.md      ← 11개 슬라이드 요소 타입
│   ├── export-rules.md       ← PNG/MP4 다운로드 규칙
│   └── api-contracts.md      ← Gemini API 호출 규약
├── .gitignore
└── index.html (건드리지 않음)
```

### 실행 방법

Claude Code에게 마스터 프롬프트 전달 → worktree에서 문서 작업만 수행 → 검증 후 메인 머지.

### 소요 시간

**약 1시간~1시간 30분**

---

## 🔜 Phase 2 — 자동 린터 + Git Hook (이번 주 내)

**목표:** Phase 1에서 문서화한 규칙을 **코드로 강제**. "말로 부탁하기"에서 "어기면 막기"로 전환.

### 실행 내용

**① Husky + Pre-commit Hook 설치**

bash

```bash
npm init -y
npm install --save-dev husky
npx husky init
```

**② 커스텀 린터 4종 작성** (`scripts/` 폴더)

|린터|검사 항목|실패 시|
|---|---|---|
|`lint-colors.js`|허용 외 색상 (`#000000` 등 5개 외)|커밋 차단|
|`lint-font-size.js`|허용 외 폰트 크기|커밋 차단|
|`lint-canvas-size.js`|1080×1350 변경 여부|커밋 차단|
|`lint-export-ignore.js`|`<button>`에 `data-export-ignore` 누락|커밋 차단|

**③ verify-task.sh 통합 스크립트**

bash

```bash
#!/bin/bash
# scripts/verify-task.sh
node scripts/lint-colors.js || exit 1
node scripts/lint-font-size.js || exit 1
node scripts/lint-canvas-size.js || exit 1
node scripts/lint-export-ignore.js || exit 1
node scripts/check-file-size.js || exit 1  # index.html 2000줄 초과 시 차단
```

**④ Pre-commit Hook 연결**

bash

```bash
# .husky/pre-commit
./scripts/verify-task.sh
```

### 기대 효과

- AI가 `#111111` 같은 임의 색상 쓰면 커밋 단계에서 자동 차단
- 새 버튼 추가 시 `data-export-ignore` 누락되면 커밋 실패
- 캔버스 크기 실수로 변경하면 즉시 감지

### 소요 시간

**약 2~3시간**

---

## 🔜 Phase 3 — 시각 회귀 테스트 + 로그 시스템 (2~3주 내)

**목표:** AI에게 "눈" 달아주기. 변경사항이 UI를 부수지 않았는지 자동 검증.

### 실행 내용

**① Puppeteer 기반 시각 회귀 테스트**

javascript

```javascript
// scripts/visual-regression.js
1. Puppeteer로 index.html 띄우기
2. 각 슬라이드 타입별 자동 스크린샷
3. 기준 이미지와 픽셀 diff (threshold 2%)
4. 체크 항목:
   ✓ 1080×1350 정확한 사이즈
   ✓ 워터마크 존재 여부
   ✓ Export 시 버튼 UI 숨김 여부
   ✓ Before/After 비율 보존
```

**② 성능 임계값 설정** (OpenAI 방식)

|항목|임계값|초과 시|
|---|---|---|
|첫 슬라이드 렌더|< 500ms|테스트 실패|
|전체 PNG 다운로드 (8장)|< 30s|테스트 실패|
|MP4 생성|< 60s|테스트 실패|
|AI 이미지 생성 실패 시 피드백|< 10s|테스트 실패|

**③ Debug 로그 시스템**

javascript

```javascript
// index.html 내부에 추가
window.__CAROUSEL_DEBUG__ = {
  logs: [], snapshots: [],
  log(event, data) { /* ... */ }
};

// 주요 액션마다 로깅
- 슬라이드 생성/삭제
- 이미지 업로드 (성공/실패)
- Gemini API 호출/응답/에러
- PNG/MP4 다운로드 진행 상황
```

**④ AI 자율 디버깅 연계** 테스트 실패 시 `logs/YYYYMMDD-HHMM.json` 자동 저장 → Claude Code가 읽고 스스로 원인 분석 가능.

### 소요 시간

**약 1~2주 (분산 작업)**

---

## 🔮 Phase 4 — 자율 개선 시스템 (장기)

**목표:** AI가 스스로 하네스를 유지보수하고 개선하는 단계.

### 실행 내용

**① Architecture Decision Records (ADR) 축적**

```
docs/adr/
├── 001-single-html-file.md        ← 왜 빌드 도구 안 씀
├── 002-html2canvas-choice.md      ← 왜 이 라이브러리
├── 003-flex-shrink-zero.md        ← 비율 왜곡 방지 이유
├── 004-gemini-flash-image.md      ← 왜 이 모델
└── 005-vercel-static-deploy.md    ← 배포 전략
```

결정의 배경을 남겨서 AI가 "왜 그렇게 되어있는지" 이해하고 작업하게 함.

**② Doc-Gardening 자동화** 주기적으로 문서와 실제 코드가 어긋났는지 감지 → 업데이트 PR 자동 생성.

bash

```bash
# GitHub Actions 또는 cron
weekly → scripts/doc-gardening.js → 불일치 발견 시 이슈 등록
```

**③ AI 자율 피드백 루프 완성**

```
1. 기능 요청 → Claude Code가 worktree 생성
2. 계획 문서 작성 (docs/plans/active/)
3. 코드 구현
4. verify-task.sh 실행
5. 시각 회귀 테스트 실행
6. 로그 자동 분석
7. 문제 발견 시 스스로 수정 재시도 (최대 3회)
8. 통과 시 자동 커밋 + 머지
9. 계획 문서 → completed/ 자동 이동
```

**④ 하네스 자체 개선 루프** AI가 실수할 때마다 그 실수를 **영구적으로 막는 새 린터 규칙** 추가. 예: AI가 `data-export-ignore` 누락 실수 → 해당 실수 기반 자동 린터 추가.

---

## 📊 단계별 기대 효과

|단계|AI 작업 시간|인간 개입|버그 발견 시점|
|---|---|---|---|
|**현재**|빠름|매번 검수|배포 후|
|**Phase 1**|빠름|수동 체크리스트|커밋 전 수동|
|**Phase 2**|비슷|커밋 시 자동 차단|커밋 전 자동|
|**Phase 3**|약간 느려짐|UI 변경만 승인|푸시 전 자동|
|**Phase 4**|빨라짐 (재시도 자동화)|최종 결과만 확인|AI가 스스로 해결|

---

## 🎯 Phase별 실행 타임라인

```
Week 1 (지금)
├── Day 1 (오늘)  → Phase 1 실행 (문서 구조화)
├── Day 2-3       → Phase 1 실사용하며 CLAUDE.md 보정
└── Day 4-7       → Phase 2 시작 (Husky + 린터 4종)

Week 2
├── Phase 2 완성 (Git hook 안정화)
└── Phase 3 설계 (Puppeteer 환경 세팅)

Week 3-4
├── Phase 3 실행 (시각 회귀 테스트)
└── Debug 로그 시스템 구축

Month 2 이후
├── Phase 4 시작 (ADR 축적)
├── Doc-gardening 자동화
└── AI 자율 피드백 루프 완성
```

---

## 💡 핵심 원칙 (OpenAI 방식 계승)

1. **한 번에 다 하지 말 것** — 실수 터지면 그걸 막는 하네스 하나 추가. 반복.
2. **말 아닌 코드로 강제** — "하지 마" 프롬프트 대신 pre-commit hook으로 차단.
3. **숫자 임계값 사용** — "빠르게"가 아니라 "500ms 이하"처럼 측정 가능하게.
4. **실패는 환경 문제** — AI가 못 하면 AI 탓 아닌 하네스 구멍 탓.
5. **문서는 목차, 규칙은 코드** — 읽게 할 건 짧게, 강제할 건 자동화.

---

## 🚀 지금 당장 시작

### Step 1 (오늘, 5분)

bash

```bash
cd /Users/songda-eun/Desktop/ClaudeProjects/Carousel/
claude
```

### Step 2 (오늘, 1시간)

이전 답변의 **Phase 1 마스터 프롬프트**를 Claude Code에 통째로 붙여넣기.

### Step 3 (이번 주)

Phase 1 실제 사용해보면서 부족한 점 기록 → Phase 2 린터에 반영할 규칙 수집.

### Step 4 (다음 주)

Phase 2 실행. 이때는 "AI가 자주 어기는 규칙 Top 5"를 먼저 린터로 만듦 (모든 규칙이 아니라 **실수가 반복되는 것부터**).

---

## 📝 요약

- **지금**: 하네스 없는 상태 → **Phase 1 (오늘)**: 문서 지도 제공 → **Phase 2 (이번 주)**: 자동 차단 시스템 → **Phase 3 (3주 내)**: AI의 눈(시각 검증) → **Phase 4 (장기)**: 자율 개선 루프
- **최종 목표**: "기능 추가해줘" 한마디에 AI가 계획→구현→검증→수정→배포까지 스스로 하는 시스템. 인간은 요청만 하고 결과만 확인.
- **핵심 철학**: OpenAI처럼 _"Humans always remain in the loop, but work at a different layer of abstraction."_ 코드를 쓰는 게 아니라 **코드를 쓰게 만드는 환경을 설계**하는 방향으로 작업 레이어를 이동.