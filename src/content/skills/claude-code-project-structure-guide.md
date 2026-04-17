---
title: "claude-code-project-structure-guide"
author: "AAA Team"
summary: "Claude Code 프로젝트를 6개 레이어로 분리해 컨텍스트 80%를 절감하는 범용 구조 가이드"
link: ""
keywords: ["Claude Code", "프로젝트 구조", "CLAUDE.md", "PRD", "에이전트"]
category: "생산성"
---

# Claude Code 프로젝트 구조 가이드

어떤 프로젝트든 바로 적용할 수 있는 범용 구조. 셀피쉬클럽 공유회 CRM 자동화에서 검증됨.

---

## 1. 왜 이 구조가 필요한가

Claude Code는 매 세션마다 `CLAUDE.md`를 전부 읽습니다. 이 파일이 길면 컨텍스트 낭비가 심해지고, 실제 작업에 쓸 공간이 줄어듭니다. 프로젝트가 커질수록 스펙, 진행상태, 결정사항이 한 파일에 뒤섞여서 관리가 힘들어집니다.

해결책: 역할별로 파일을 분리하고, 각 파일이 언제 로드되는지 명확히 구분하세요.

**검증된 성과:**
- CLAUDE.md 353줄 → 64줄 축소 (컨텍스트 80% 절감)
- PRD 8개 + DB PRD 1개 = 도메인별 SSOT 확보
- 에이전트 6개 + 스킬 2개로 독립적 실행
- 메모리 5개로 진행상태 한눈에 추적

---

## 2. 6개 저장 레이어 (이대로 구분하세요)

| 레이어 | 위치 | 로드 시점 | 내용 | 변경 빈도 |
|--------|------|----------|------|----------|
| **CLAUDE.md** | 프로젝트 루트 | 매 세션 자동 | 프로젝트 정체성 + 안전규칙 + 어디 보면 되는지 | 거의 안 바뀜 |
| **prd/*.md** | `prd/` | 에이전트가 필요할 때 | 도메인별 스펙 (SSOT) | 스펙 변경 시만 |
| **agents/*.md** | `.claude/agents/` | 스킬 실행 시 | 역할 정의 + PRD 참조 | 거의 안 바뀜 |
| **memory/** | 프로젝트별 메모리 | 세션 시작 시 인덱스만 | 결정/피드백/진행상태/참조 | **매 세션** |
| **rules/*.md** | `.claude/rules/` | 매 세션 자동 | 코딩 스타일/보안/워크플로우 | 거의 안 바뀜 |
| **skills/** | `.claude/skills/` | 트리거 시 | 업무 파이프라인 (독립 워크플로우) | 거의 안 바뀜 |

---

## 3. 각 레이어 상세 설명

### CLAUDE.md (50~100줄 권장)

매 세션 전부 로드되므로 **최소한으로 유지하세요.**

**반드시 포함:**
- 프로젝트 목표 (3줄)
- PRD 목록 테이블
- 구조 원칙
- 안전 규칙
- 작업 습관
- 연동 정보 (한줄씩)
- 세션 루틴

**절대 포함하면 안 됨:**
- 구체적 스펙 (→ PRD로)
- 진행 상태 (→ memory로)
- API 키 상세 (→ .env로)
- 에이전트 역할 상세 (→ agents/로)

**기준:** "이 파일만 읽으면 프로젝트가 뭔지 + 뭘 하면 안 되는지 + 어디 보면 되는지 알 수 있다"

---

### PRD (도메인별 분리)

**SSOT(Single Source of Truth)** = 스펙의 단일 진실 공급원입니다.

- 하나의 PRD = 하나의 도메인/채널/기능
- 에이전트가 **참조만** 하는 규칙 원본
- `00-overview.md` 는 필수 (전체 플로우 + 아키텍처)

**예시:**

**CRM 프로젝트:**
- `prd/00-overview.md` — 전체 A-Z 플로우 + Phase 구조
- `prd/01-알림톡.md` — 템플릿 9종, 변수 매핑, n8n 크론
- `prd/02-카플친.md` — 배너 디자인, SOLAPI 발송
- `prd/03-오픈채팅.md` — 3방 규칙, 카피 톤

**SaaS 프로젝트:**
- `prd/00-overview.md` — 아키텍처
- `prd/01-auth.md` — 인증/인가
- `prd/02-billing.md` — 결제
- `prd/03-dashboard.md` — UI 규칙

---

### 에이전트 (.claude/agents/)

재사용 가능한 역할 정의입니다.

```markdown
# {에이전트명} — {한줄 역할}

## 참조 PRD
- prd/01-{}.md — {왜 참조하는지}
- prd/02-{}.md — {왜 참조하는지}

## 역할
{구체적으로 뭘 하는지}

## 도구
{사용하는 도구/API}

## 출력
{산출물 형식}
```

**모델 선택:**
- **Haiku** — 빠른 조회, 가벼운 에이전트, 반복 호출
- **Sonnet** — 코딩/카피, 다중 에이전트 오케스트레이션
- **Opus** — 복잡한 아키텍처, 최종 검수

---

### 메모리 (memory/)

바뀌는 정보는 메모리에, 안 바뀌는 정보는 CLAUDE.md에 저장하세요.

**memory/MEMORY.md (인덱스)**
```markdown
- [진행 상태](progress.md) — 완료/진행중/남은작업
- [미팅 결정](meeting_0405_crm_v2.md) — 주요 결정사항
- [세션 기록](session_0405_n8n_test.md) — 작업 내역
```

**memory/progress.md (매 세션 업데이트)**
```markdown
## 완료된 것
- ✅ 알림톡 템플릿 9종 확정
- ✅ n8n 크론 재설계

## 진행중
- 🔲 인스타 캐러셀 생성

## 남은 작업
- 🔲 Stibee 이메일 API 연동

## 주의사항
- ⚠️ testMode=true 유지 (A-Z 테스트 미완료)
```

---

### 룰 (.claude/rules/)

프로젝트 전체에 자동 적용되는 코딩 규칙입니다.

```
.claude/rules/
├── coding-style.md          # 코드 스타일
├── security.md               # 보안 체크리스트
├── git-workflow.md           # 커밋/PR 규칙
├── testing.md                # 테스트 커버리지
├── performance.md            # 모델 선택
└── karpathy-guidelines.md    # 코딩 훈련
```

에이전트가 아닌 **모든 코드 작업**에 자동 적용됩니다.

---

### 스킬 (.claude/skills/)

독립적인 워크플로우만 스킬로 분리하세요.

```
.claude/skills/
└── {스킬명}/
    ├── SKILL.md              # 스킬 정의
    ├── agents/               # 스킬 전용 에이전트
    ├── lib/                  # 유틸리티
    └── test/                 # 테스트
```

**스킬 분리 기준:**
- 독립적으로 실행 가능
- 여러 세션에서 재사용
- 트리거 패턴 정의 가능

---

## 4. 범용 프로젝트 폴더 템플릿

```
project-root/
├── CLAUDE.md                          # 프로젝트 정체성 (50~100줄)
├── README.md                          # 프로젝트 소개 (선택)
├── prd/                               # 도메인별 스펙 (SSOT)
│   ├── 00-overview.md                 # 전체 플로우 + 아키텍처
│   ├── 01-{도메인A}.md
│   ├── 02-{도메인B}.md
│   └── ...
├── .claude/
│   ├── agents/                        # 재사용 역할 정의
│   │   ├── {역할A}.md
│   │   ├── {역할B}.md
│   │   └── ...
│   ├── skills/                        # 독립 워크플로우
│   │   └── {스킬명}/
│   │       ├── SKILL.md
│   │       ├── agents/
│   │       ├── lib/
│   │       └── test/
│   └── rules/                         # 코딩 규칙 (자동 적용)
│       ├── coding-style.md
│       ├── security.md
│       ├── git-workflow.md
│       ├── testing.md
│       ├── performance.md
│       └── karpathy-guidelines.md
├── memory/                            # 진행상태/결정사항
│   ├── MEMORY.md                      # 인덱스
│   ├── progress.md                    # 현재 상태 (매번 업데이트)
│   ├── meeting_MMDD.md
│   └── session_MMDD.md
├── scripts/                           # 실행 스크립트
├── outputs/                           # 생성물
├── .env                               # 환경변수 (git ignore)
└── .gitignore
```

---

## 5. CLAUDE.md 작성 가이드 (복사해서 쓰세요)

```markdown
# {프로젝트명}

## 프로젝트 목표
{한 줄로 요약}

## 상세 스펙 (PRD)
| 파일 | 내용 |
|------|------|
| prd/00-overview.md | 전체 플로우 + 아키텍처 |
| prd/01-{}.md | ... |
| prd/02-{}.md | ... |

## 구조 원칙
- 스킬 = 업무 파이프라인 (독립 워크플로우만)
- 에이전트 = 재사용 역할 (여러 스킬에서 공유)
- PRD = 규칙 원본 (SSOT, 에이전트가 참조만)

## 안전 규칙
- {절대 하면 안 되는 것 1}
- {절대 하면 안 되는 것 2}

## 작업 습관
- 커밋: `[영역] 내용` 형식
- 메모리: 결정/피드백은 memory/에 저장
- 변경 시: PRD 수정 → 에이전트도 함께 업데이트

## 연동 정보
- Slack: 채널 ID + 봇
- Supabase: URL + 키
- n8n: 워크플로우 ID + API 키

## 현재 진행 상태
→ memory/progress.md 참조

## 세션 종료 루틴
1. 중요 결정사항 → memory/meeting_{MMDD}.md
2. 진행상태 업데이트 → memory/progress.md
3. PRD/에이전트 변경 → 둘 다 함께 반영
4. 커밋 + 푸시
```

---

## 6. PRD 작성 가이드

```markdown
# {번호} — {도메인명} PRD

## 개요
{이 도메인이 뭔지, 핵심 규칙 3줄}

## 스펙
### 템플릿 / 규칙
{구체적인 ID, 변수, 형식, 규칙 등}

### 플로우
{실행 순서, 조건, 선택지}

## 참조
- {관련 다른 PRD}
- {외부 문서 링크}
```

---

## 7. 에이전트 작성 가이드

```markdown
# {에이전트명} — {한줄 역할}

모델: {haiku/sonnet/opus}

## 참조 PRD
- prd/01-{}.md — {구체적으로 뭘 참조하는지}
- prd/02-{}.md

## 역할
{이 에이전트가 정확히 뭘 하는지 (문장 3~5개)}

## 도구
- {API/도구 1}
- {API/도구 2}

## 입력
{받는 정보 형식}

## 출력
{산출물 형식, 예시 포함}

## 주의사항
- {프로세스에서 주의할 점}
```

---

## 8. 메모리 관리 가이드

### 인덱스 (MEMORY.md)

세션 시작 시 이것만 로드합니다. 한 줄씩만.

```markdown
- [진행 상태](progress.md) — 완료/진행중/남은작업
- [4/5 CRM v2 미팅](meeting_0405_crm_v2.md) — 카카오모먼트 전환
- [4/5 n8n 테스트](session_0405_n8n_test.md) — ①~⑤ 성공, ⑥~⑨ 남음
```

### progress.md (매 세션 끝에 업데이트)

```markdown
## 완료된 것
- ✅ PRD 8개 분리
- ✅ 에이전트 7개 업데이트
- ✅ n8n 크론 재설계

## 진행중
- 🔲 인스타 캐러셀 생성

## 남은 작업
- 🔲 Stibee API 연동

## 주의사항
- ⚠️ testMode=true (A-Z 테스트 완료 후 false로)
- ⚠️ iid_999 = 테스트용 (나중에 삭제)
```

---

## 9. 판단 기준: 어디에 저장할지

| 이 정보는... | 저장 위치 |
|-------------|----------|
| 프로젝트가 뭔지 설명하는 것 | `CLAUDE.md` |
| 특정 도메인의 구체적 스펙 | `prd/{도메인}.md` |
| 에이전트의 역할과 참조 | `agents/{역할}.md` |
| **매 세션 바뀌는** 진행 상태 | `memory/progress.md` |
| 미팅에서 결정된 사항 | `memory/meeting_{날짜}.md` |
| 코딩 스타일/보안 규칙 | `.claude/rules/` |
| 독립적인 워크플로우 | `.claude/skills/{스킬}/` |
| API 키/비밀 정보 | `.env` |
| 절대 하면 안 되는 것 | `CLAUDE.md` 안전 규칙 |

---

## 10. 적용 예시

### 예시 A: CRM 자동화 (실제 적용)

**검증된 구조:**
- PRD 9개 (00-overview + 알림톡/카플친/오픈채팅/이메일/인스타/온드미디어/UTM/DB)
- 에이전트 6개 (director-opus, data-collector-haiku, copywriter-sonnet, media-ops-sonnet, dispatcher-sonnet, timeline-planner-lib)
- 스킬 2개 (sharing-crm-team, sharing-post-mortem)
- 메모리 5개 (진행상태, 미팅결정, 세션기록, 과제규칙, 참조정보)

**성과:**
- CLAUDE.md 353줄 → 64줄 (80% 축소)
- 매 세션 컨텍스트 절감 → 실제 작업에 20% 더 쓸 공간 확보

---

### 예시 B: SaaS 대시보드

```
prd/
├── 00-overview.md      (전체 아키텍처)
├── 01-auth.md          (인증/인가)
├── 02-billing.md       (결제)
├── 03-dashboard.md     (UI 규칙)
├── 04-api.md           (API 스펙)
└── 05-deploy.md        (배포 프로세스)

agents/
├── frontend-dev.md     (sonnet)
├── backend-dev.md      (sonnet)
├── db-admin.md         (sonnet)
└── tester.md           (haiku)

skills/
├── feature-ship/       (기능 개발 파이프라인)
└── hotfix/             (긴급 수정)
```

---

### 예시 C: 콘텐츠 마케팅

```
prd/
├── 00-overview.md      (전체 콘텐츠 전략)
├── 01-blog.md          (블로그 스펙)
├── 02-social.md        (SNS 톤앤매너)
├── 03-newsletter.md    (뉴스레터 형식)
└── 04-seo.md           (SEO 규칙)

agents/
├── writer.md           (sonnet)
├── designer.md         (sonnet)
├── analyst.md          (haiku)
└── publisher.md        (haiku)

skills/
├── content-pipeline/   (콘텐츠 생성→게시)
└── analytics-report/   (성과 분석)
```

---

## 11. 핵심 원칙 요약

1. **CLAUDE.md는 짧게**
   - 50~100줄만 유지
   - "뭔지 + 뭘 하면 안 되는지 + 어디 보면 되는지" 만

2. **PRD = SSOT**
   - 스펙은 한 곳에만 저장
   - 에이전트는 참조만 (복사하지 말 것)

3. **바뀌는 것 ↔ 안 바뀌는 것 분리**
   - 진행상태 → `memory/`
   - 규칙/원칙 → `CLAUDE.md`

4. **에이전트 상단에 참조 PRD 명시**
   - 의존성 추적 가능
   - PRD 수정 후 에이전트도 함께 업데이트

5. **스킬은 독립 워크플로우만**
   - 공유되는 로직 → 에이전트
   - 하나의 파이프라인 → 스킬

6. **세션 끝에 반드시 저장**
   - `memory/progress.md` 업데이트
   - 필요 시 PRD/에이전트 반영
   - 커밋 + 푸시

---

## 12. 체크리스트: 새 프로젝트 시작하기

```
프로젝트 설정
- [ ] CLAUDE.md 작성 (50~100줄)
- [ ] prd/00-overview.md 작성
- [ ] .claude/agents/ 디렉토리 생성
- [ ] .claude/rules/ 복사 (templates 사용)
- [ ] memory/MEMORY.md + progress.md 생성

규칙 정하기
- [ ] 안전 규칙 정의 (CLAUDE.md에)
- [ ] 커밋 형식 정의 (rules/git-workflow.md)
- [ ] 모델 선택 규칙 (rules/performance.md)
- [ ] 테스트 커버리지 (rules/testing.md)

첫 번째 작업
- [ ] PRD 1개 → 에이전트 1개 작성
- [ ] 스킬 트리거 정의
- [ ] memory/progress.md에 진행상태 기록
```

---

## 13. 추천 도구/워크플로우

**oh-my-claudecode 스킬 활용:**
- `/oh-my-claudecode:plan` — PRD/에이전트 구조 기획
- `/oh-my-claudecode:ultraqa` — 정합성 검증 (PRD ↔ 에이전트 ↔ CLAUDE.md)
- `/oh-my-claudecode:team` — 다중 에이전트 작업 조율

**추천 습관:**
- 매 작업 시작 전: `memory/MEMORY.md` 확인
- 매 작업 끝: `memory/progress.md` 업데이트
- 매 스펙 변경: PRD → 에이전트 함께 수정
- 매 주 1회: 전체 정합성 검증 (`/ultraqa`)

---

**이 가이드는 실전에서 검증된 구조입니다. 프로젝트 크기와 복잡도에 맞게 조정하세요.**
