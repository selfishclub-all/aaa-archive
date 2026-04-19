**하네스란?**
- AI에게 공간, 학습, 기억을 어떻게 줄 것인지
	- 클로드가 일하는 방식을 따라 내가 설계하는 장치

**기억 (feedback/prd/agent.md)**
  **→ AI가 읽고 작업**
       **↓**
**학습 (verifier/에밀리 승인/삽질 박제)**
  **→ 실수 감지 → 기억으로 박제**
       **↓**
**공간 (린터/hook/외부 API)**
  **→ 박제된 규칙이 기술적으로 강제됨**
       **↓**
**다시 기억이 누적돼서 AI가 더 똑똑하게 일함**


어떻게 적용했는가?
1. **공간(안전한 작업환경)**->**기술적으로 강제**
	- 린터 실패 시 커밋 자체 거부
	- 승인된 템플릿 9종만 발송 가능
	- 규격 틀린 이미지 거부 (800×600, 1080×1080)
	- 에밀리 Slack 승인 안 하면 발송 안 됨
	- 버전 안 맞으면 자동 차단 (중복 발송 방지)
	- 취소 플래그 걸리면 자동 스킵
	- 발송 직전 재조회해서 미신청자 자동 제외
	- `main` 직접 push 불가
	- feedback 활성화 누락 차단
	-  "90% 할인" 같은 금지어 자동 차단
	- MEMORY.md 인덱스 누락 차단(안맞으면 깃 푸시안됨)

2. **학습(피드백 루프)**-> **실수 → 박제 → 자동 회피**
	- 삽질 박제 — 크론 타임존, n8n PUT 이스케이프, Wait 중 deactivate 등 6건
	- 에밀리 교정 박제 — 카피 규칙, 가격 표현 금지
	- 성공 원리 박제 — 버전 카운터 동작, 발송직전 조회
	- n8n 백업 8개 — 망가지면 롤백
	- **Slack 승인 모달** — 에밀리 교정 → feedback 박제 → 다음 공유회 자동 반영
	- **n8n 실행 로그** — 실패 감지 → 수정 → 재실행
	- **발송직전 DB 재조회** — 승인 후 변경사항 자동 보정
	- **verifier 반려** ✨NEW — AI 산출물이 규칙 위반 시 작성 에이전트에 반려

	### **루프가 실패 시 박제**
	- 3회 연속 같은 실패 → verifier가 feedback 박제 제안
	- `session-retro.py`가 세션별 정합성 측정 → 구멍 자동 탐지


3. **기억(**AI가 세션마다 까먹어도 파일이 대신 기억**)**
	**프로젝트 입구**
	- `CLAUDE.md` — 세션마다 자동 로드 (30줄 + 에이전트 맵 + 스크립트 맵)
	### **규칙 원본 (SSOT) — `prd/*.md` 10개**
	- 00 overview / 01 알림톡 / 02 카플친 / 03 오픈채팅 / 04 이메일
	- 05 인스타 / 06 온드 / 07 UTM / 08 database / 09 아티팩트

	### **역할 정의 — `.claude/agents/*.md` 9개**
	실무 라인
	- director / timeline-planner / data-collector / copywriter / media-ops / dispatcher
	검수 라인
	- verifier / code-reviewer / session-retro

	### 파이프라인 — `.claude/skills/`
	- sharing-crm-team/SKILL.md — CRM 전체 (검수 라인 포함 ✨NEW)
	- sharing-post-mortem/SKILL.md — 사후분석
	
	### 도구 연결 — MCP Supabase / Slack / n8n / Notion / Gemini
	### 세션 연결
	- memory/progress.md — 매 세션 업데이트
	- 인덱스 (린터로 정합성 자동 검증)
	- 정합성 검증기, n8n 스냅샷,세션 스냅샷,민감정보 마스킹


### 루프 A — 실무 루프

```
에밀리 승인 모달에서 "이거 아닌데" 지적  → dispatcher 반려  → copywriter 재실행  → 반복
```

### 루프 B — 검수 루프 

```
verifier가 규칙 위반 감지 (lint-copy.py 결과)  → 작성 에이전트에 반려  → 자동 재작업
```

### 루프 C — 박제 루프

```
동일 실수/교정 3회 반복  → verifier가 feedback 박제 제안  → memory/feedback_*.md 생성  → 에이전트 md에 참조 연결  → lint-agent-refs.py 통과 확인  → 다음 세션부터 자동 회피
```

### 루프 D — 정합성 루프 
```
파일 만들고 커밋 시도  → pre-commit hook이 린터 실행  → 누락 감지 시 커밋 차단  → 강제로 연결 작업 완료 후 재시도
```

