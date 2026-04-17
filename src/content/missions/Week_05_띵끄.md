1# Week 04 — 이기적공유회 발표

## 왜 AAA에 참여했는가

에이전시/고가 서비스 사업을 운영하면서 매일 들어가는 툴이 5~6개
- Stripe (결제), Calendly (예약), GoHighLevel (CRM), Meta (광고), n8n (자동화)
- 각각 로그인하고, 각각 확인하고, 데이터가 파편화
- **"하나의 대시보드에서 다 보고싶다"** → 직접 만들어보자
- 코딩 전문가가 아닌 상태에서 **Claude Code로 실제 SaaS를 만들어보겠다**는 도전

---

## 어떤걸 만들었는가 — GrowthLink (구 YFLOW)

**비즈니스 통합 대시보드 SaaS**

| 항목 | 내용 |
|------|------|
| 개발 기간 | **약 1개월** (3/13 ~ 4/12) |
| 총 커밋 수 | **148개** |
| 대시보드 페이지 | **26개** |
| API 엔드포인트 | **67개** |
| 외부 연동 서비스 | **5개** (Stripe, Calendly, GHL, Meta, n8n) |
| DB 테이블 | **20개+** |
| 기술스택 | Next.js 16 + Supabase + Vercel + Tailwind CSS |

### 핵심 기능
- 결제/예약/CRM/광고/워크플로우 통합 대시보드
- AI 인스타그램 캐러셀 생성기
- High-Ticket OS (시장조사 → 오퍼설계 → 콘텐츠 → 세일즈)
- 멀티테넌트 팀 관리 (owner/admin/member 역할)
- 한국어/영어 다국어, 다크모드 지원
- OAuth 연동 (Stripe Connect, Calendly, GHL, Meta)
- 보안 5단계 스프린트 (RLS, Rate Limit, SSRF 방어, 암호화)

---

## 왜 만들었는가

- 매번 Stripe 들어가서 매출 확인, Calendly 들어가서 예약 확인, GHL 들어가서 폼 제출 확인... **비효율의 반복**
- 기존 올인원 SaaS는 비싸거나 커스터마이징이 안 됨
- "내 사업에 딱 맞는 대시보드"를 직접 만들 수 있는 시대가 왔다는 걸 증명하고 싶었음

---

## 누구한테 도움이 될 것 같은지

- **에이전시 운영자** — 클라이언트별 매출/예약/파이프라인을 한눈에
- **고가 서비스 코치/컨설턴트** — High-Ticket OS로 영업 프로세스 체계화
- **1인/소규모 사업자** — 여러 SaaS 도구 데이터를 한 곳에서 관리
- **바이브코딩에 관심있는 사람** — "이 정도 서비스를 코딩 경험 없이 만들 수 있구나" 증명 사례

---

## 삽질과정 — Claude Code로 서비스 만들 때 다들 겪을 것들

> 148커밋 중 상당수가 **fix:** 로 시작한다. 이게 현실이다.

### 삽질 1: "한방에 다 해줘" 증후군

```
커밋 히스토리:
2d4ca37 feat: 대규모 기능 확장 — 파이프라인, 인보이스, 결제링크, 서비스...
00466ef Revert "feat: 대규모 기능 확장 — ..."   ← 바로 다음 커밋에서 전체 되돌림
```

- Claude Code에게 한번에 10개 기능을 요청 → 전부 꼬여서 리버트
- 리버트 후 `파이프라인 칸반 보드`처럼 하나씩 분리해서 다시 작업 → 성공
- **교훈: 한번에 하나의 기능만 요청하고, 확인 후 다음으로 넘어가야 한다**
- 큰 작업 전에 반드시 커밋해두면 리버트라는 안전망이 생긴다

---

### 삽질 2: AI 모델 버전 지옥 — 4번 갈아탐

```
커밋 히스토리:
464d2cc feat: AI reporting with Google Gemini (2.0 Flash)
96cb92a Switch to 1.5 Flash (free tier 쿼타 초과)
bef5a33 Switch to 2.5 Flash (1.5 Flash가 API에서 제거됨)
8fad718 refactor: AI 기능 Anthropic → Gemini 다시 전환
aaa3084 fix: Gemini 2.5 Flash thinking 비활성화로 파싱 문제 해결
```

- Gemini 2.0 Flash → 1.5 Flash → 2.5 Flash, 중간에 Anthropic 갔다가 다시 Gemini
- 2.5 Flash가 "thinking" 응답을 같이 보내서 JSON 파싱이 깨짐
- **교훈: Claude Code가 알고 있는 모델명이 이미 deprecated일 수 있다**
- AI API 연동 시 **반드시 공식 docs URL을 Claude에게 확인시켜야** 함

---

### 삽질 3: Supabase RLS가 내 코드를 다 막음

```
커밋 히스토리:
f63d061 fix(ghl/sync): use serviceClient to bypass RLS
26bab05 fix(calendly/sync): bypass RLS for full historical bookings
bdeed54 fix: 멀티테넌트 데이터 격리 — UNIQUE 제약을 테넌트별 복합키로 변경
4e59034 fix: payments RLS 강화 — 사용자 INSERT 정책 제거
```

- 외부 API에서 데이터를 가져와서 DB에 넣으려는데 RLS가 전부 차단
- Claude Code는 RLS 정책이 있는지 모르고 일반 클라이언트로 코드를 짜줌
- **교훈: Supabase `service_role` vs `anon` 클라이언트 구분이 핵심**
- Claude에게 **"우리 DB에 이런 RLS 정책이 있다"고 컨텍스트를 줘야** 한다

---

### 삽질 4: OAuth 연동 — 디버그 엔드포인트 6개 만들어가며

```
커밋 히스토리:
58fb907 chore(ghl): add diagnostic endpoint to inspect GHL API responses
a12d512 fix(ghl/sync): remove endAt param causing empty responses
8a9637d chore(ghl): test page param variations in debug endpoint
67b15b5 chore(ghl/debug): test startAt param and expose meta
```

- GoHighLevel OAuth 연동에서 데이터가 계속 빈 배열로 옴
- Claude Code가 API 문서 없이 추측으로 파라미터를 넣어줌 → 전부 실패
- 디버그용 엔드포인트를 만들어서 실제 응답을 눈으로 확인한 뒤에야 해결
- **교훈: 외부 API 연동 시 API 문서를 직접 붙여넣기하거나, 디버그 엔드포인트를 먼저 만들어달라고 요청해야 한다**

---

### 삽질 5: Rate Limit이 내 서비스를 차단

```
커밋 히스토리:
f8e78fd chore(rate-limit): raise sync limit from 2 to 10/min
d0f742e chore(rate-limit): raise sync limit from 10 to 30/min
1551b0c chore(sync): remove rate limit from manual sync endpoints
6af823d fix: Upstash Redis 미설정 시 rate limit이 모든 요청 차단
```

- 보안 강화를 위해 Rate Limit을 넣었는데, 내 동기화 API를 스스로 차단
- Redis 미설정 환경에서 **모든 요청이 거부되는** 치명적 버그
- 2→10→30→제거로 4번이나 조정
- **교훈: Claude Code가 "보안 강화"해주면 반드시 직접 테스트해야 한다**
- 보안은 한번에 빡세게 X → 느슨하게 시작해서 점진적으로 강화

---

### 삽질 6: Vercel 배포에서만 터지는 에러

```
커밋 히스토리:
b1bbe9f fix: wrap useSearchParams in Suspense boundary for Vercel build
fea7cfe fix: 크론 주기를 매일 1회로 변경 (Vercel Hobby 플랜 호환)
0b843c6 fix: en.ts clientHub 중복 정의 제거 (빌드 에러 수정)
```

- 로컬에서 완벽하게 돌아가는데 Vercel 빌드에서 실패
- `useSearchParams`는 Suspense로 감싸야 하는 건 Claude Code가 모름
- Hobby 플랜의 cron 제한(하루 1회)도 모름
- **교훈: 배포 환경의 제약조건(플랜, 빌드 모드)을 Claude에게 미리 알려줘야 한다**

---

### 삽질 7: 브랜드를 3번 바꿈

```
커밋 히스토리:
254a9d8 chore: rename product from FlowOps to YFLOW
7b838f4 chore: YFLOW → GrowthLink 브랜드 전환
```

- 코드 곳곳에 하드코딩된 브랜드명, 메타데이터, 이메일 템플릿 전부 수정
- **교훈: 처음부터 프로덕트명은 상수/설정파일로 관리하자고 Claude에게 요청할 것**

---

## 가져갈 수 있는 것 — Claude Code 실전 원칙 7가지

| # | 원칙 | 핵심 |
|---|------|------|
| 1 | **작게 나눠서 요청** | 한번에 10개 기능 X → 1기능씩 확인하며 진행 |
| 2 | **컨텍스트를 줘라** | DB 정책, API 문서, 배포 환경 제약 → Claude는 안 보이면 모른다 |
| 3 | **공식 문서를 확인시켜라** | AI 모델명, API 버전 등 학습 데이터가 이미 옛날일 수 있다 |
| 4 | **보안은 점진적으로** | 한번에 강화 X → 하나씩 적용하고 테스트 |
| 5 | **디버그 엔드포인트가 생명줄** | 외부 API 연동 시 실제 응답을 볼 수 있는 루트를 먼저 만들어라 |
| 6 | **배포 환경을 미리 알려줘라** | Vercel Hobby 제약, Suspense 요구사항 등 로컬과 다른 점 명시 |
| 7 | **커밋은 자주, 작게** | 큰 변경 전 반드시 커밋 → 실패 시 리버트로 복구 가능 |

---

## 전체 구조 — 이걸 가져가세요

```
Claude Code로 SaaS 만드는 흐름:

1. PRD(기획서) 먼저 작성 → Claude에게 전체 그림을 보여주기
2. 기능 단위로 쪼개서 요청 (1커밋 = 1기능)
3. 외부 API 연동은 디버그 엔드포인트부터
4. DB 정책(RLS)과 배포 환경 제약을 Claude에게 공유
5. 보안은 별도 스프린트로 분리해서 점진 적용
6. 매 작업마다 커밋 → 안전망 확보
7. 공식 문서 확인은 선택이 아니라 필수
```

**한 줄 요약:**
> Claude Code는 엄청 똑똑한 주니어 개발자다. 시키면 잘하는데, **맥락을 안 주면 추측으로 코드를 짜고, 그 추측이 틀리면 삽질이 시작된다.** 내가 PM/시니어 역할을 해야 한다.

---

## 인사이트

- 코딩을 못해도 서비스를 만들 수 있는 시대는 맞지만, **"뭘 만들지"와 "어떤 순서로 만들지"를 결정하는 건 여전히 사람의 몫**
- Claude Code의 진짜 가치는 코드를 써주는 것이 아니라, **내 아이디어를 빠르게 프로토타입으로 검증할 수 있게 해주는 것**
- 보안, 배포, 외부 API 연동 같은 **"코드 바깥의 문제"**에서 가장 많이 삽질함
- 삽질을 줄이는 핵심은 **Claude에게 얼마나 좋은 컨텍스트를 주느냐**에 달려있음

---

## 다시 한다면?

- 처음부터 **PRD + DB 스키마 + API 문서를 Claude에게 통째로 공유**하고 시작할 것
- 기능 요청은 절대 한번에 3개 이상 안 함
- 외부 API는 무조건 **디버그 엔드포인트 먼저** 만들고 실제 응답 확인 후 본격 개발
- 보안은 기능 개발과 별개 트랙으로 분리
- 브랜드명, 설정값은 처음부터 **환경변수/상수 파일**로 관리
