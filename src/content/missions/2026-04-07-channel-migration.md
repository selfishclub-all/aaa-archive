# Sullivan Channel Migration Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sullivan을 Python bot + Anthropic API 구조에서 Claude Code Channel + 네이티브 추론 구조로 마이그레이션하여 API 비용을 제거한다.

**Architecture:** Telegram 인터페이스는 유지하되, 백엔드를 Python 데몬에서 Claude Code 세션으로 교체. 기존 `.claude/agents/*.md` 프롬프트를 Claude Code가 직접 읽고 따르는 구조. 스케줄링은 `CronCreate(durable=true)`로 세션 내 처리, 7일 만료 대응으로 세션 시작 시 자동 재등록.

**Tech Stack:** Claude Code Channel (Telegram plugin), CronCreate, Read/Write/Bash 도구, Obsidian vault (로컬 파일)

---

## File Structure

```
sullivan/
  CLAUDE.md                          ← 수정: 채널 라우팅 + 스케줄링 규칙 추가
  .claude/
    settings.json                    ← 생성: 채널 설정
    agents/
      morning-agent.md               ← 유지 (프롬프트 그대로)
      capture-agent.md               ← 유지
      reflection-agent.md            ← 유지
      insight-agent.md               ← 유지
    skills/
      tone-guide.md                  ← 유지
      questioning.md                 ← 유지
      weekly-report.md               ← 유지
      sullivan-channel.md            ← 생성: 채널 메시지 라우팅 스킬
      sullivan-scheduler.md          ← 생성: 스케줄 등록 스킬
  sullivan-bot/                      ← 유지 (fallback, 점진적 마이그레이션)
```

**핵심 원칙**: Python 봇은 즉시 삭제하지 않는다. 채널 방식이 안정화될 때까지 병행 운영 후 제거.

---

## Task 1: Telegram 채널 설정

**Files:**
- Modify: `~/.claude/channels/telegram/.env`
- Verify: `~/.claude/channels/telegram/access.json`

Sullivan 전용 채널은 기존 Telegram 봇 토큰을 사용하거나 새로 생성.
기존 Python 봇과 동시 실행 불가 (같은 토큰 polling 충돌)이므로, 마이그레이션 시 Python 봇을 중지해야 함.

- [ ] **Step 1: 현재 채널 설정 확인**

```bash
cat ~/.claude/channels/telegram/.env
cat ~/.claude/channels/telegram/access.json
```

기존에 다른 봇 토큰이 설정되어 있는지 확인.

- [ ] **Step 2: Sullivan 봇 토큰 결정**

옵션 A: 기존 Sullivan 봇 토큰 재사용 (Python 봇 중지 후)
옵션 B: BotFather에서 새 봇 생성 → 별도 `TELEGRAM_STATE_DIR` 사용

기존 채널 설정이 이미 다른 봇에 연결되어 있다면 옵션 B 선택:

```bash
mkdir -p ~/.claude/channels/telegram-sullivan
echo "TELEGRAM_BOT_TOKEN=<sullivan_token>" > ~/.claude/channels/telegram-sullivan/.env
```

- [ ] **Step 3: 채널 연결 테스트**

```bash
# 옵션 A (기존 토큰 재사용 시, Python 봇 먼저 중지)
launchctl stop sullivan.bot
claude --channels plugin:telegram@claude-plugins-official

# 옵션 B (별도 디렉토리)
TELEGRAM_STATE_DIR=~/.claude/channels/telegram-sullivan \
claude --channels plugin:telegram@claude-plugins-official
```

Telegram에서 봇에게 "test" 전송 → Claude Code 세션에 메시지 도착 확인.

- [ ] **Step 4: access 설정**

흐민의 Telegram user ID가 allowlist에 있는지 확인. 없으면 `/telegram:access` 스킬로 페어링.

---

## Task 2: 채널 라우팅 스킬 생성

**Files:**
- Create: `.claude/skills/sullivan-channel.md`

채널로 들어오는 메시지를 기존 agent 역할에 맞게 라우팅하는 핵심 스킬.

- [ ] **Step 1: sullivan-channel.md 작성**

```markdown
---
name: sullivan-channel
description: 텔레그램 채널 메시지를 받아 적절한 Sullivan 에이전트 역할을 수행한다. 모든 채널 메시지에 자동 적용.
---

## 메시지 라우팅

텔레그램 메시지가 도착하면 아래 순서로 판단한다:

### 1. 시스템 커맨드 확인

- `/morning` → morning-agent.md 역할 수행
- `/lunch` → reflection-agent.md 점심 체크인 모드
- `/night` → reflection-agent.md 자기 전 회고 모드
- `/weekly` → reflection-agent.md 주간 회고 모드
- `/insight` → insight-agent.md 역할 수행
- `/chat` → 자유 대화 시작 (tone-guide.md 참조)
- `/end` → 자유 대화 종료, 대화 요약을 Captures에 저장
- `?` → 도움말 출력

### 2. 활성 세션 확인

점심/자기전/주간/월간 회고가 진행 중이면 해당 에이전트 역할을 계속한다.
자유 대화 모드이면 대화를 이어간다.

### 3. 기본값: 캡처

커맨드 없는 일반 텍스트/URL → capture-agent.md 역할 수행.

## 응답 방식

- 텔레그램 reply 도구로 응답한다
- tone-guide.md를 참조한다
- 4096자 초과 시 자동 분할한다

## Obsidian 저장

모든 파일 저장은 아래 경로를 사용한다:
- Vault root: `/Users/hminn/Library/Mobile Documents/iCloud~md~obsidian/Documents/Helen`
- Captures: `Sullivan/Captures/YYYY-MM-DD/[제목].md`
- Reflections: `Sullivan/Reflections/YYYY-MM-DD.md`
- Briefings: `Sullivan/Briefings/YYYY-MM-DD.md`
- Insights: `Sullivan/Insights/YYYY-MM-DD.md`

파일 저장 후 git sync:
```bash
cd "<vault_root>" && git add -A && git commit -m "auto: <filename>" && git push
```

## 메모 리마인드

`/memo` 또는 `/메모`로 캡처 완료 후 "리마인드 해줄까?" 질문.
자연어 시간 응답 → CronCreate(recurring=false)로 1회성 리마인드 등록.

## 회고에서 메모 제외

Captures를 읽을 때 frontmatter의 `category: 메모`인 파일은 회고 컨텍스트에서 제외한다.
```

- [ ] **Step 2: 커밋**

```bash
git add .claude/skills/sullivan-channel.md
git commit -m "feat: add sullivan-channel routing skill for CC Channel migration"
```

---

## Task 3: 스케줄러 스킬 생성

**Files:**
- Create: `.claude/skills/sullivan-scheduler.md`

세션 시작 시 CronCreate로 스케줄을 등록하는 스킬.

- [ ] **Step 1: sullivan-scheduler.md 작성**

```markdown
---
name: sullivan-scheduler
description: Sullivan 스케줄 등록. 세션 시작 시 또는 /schedule 커맨드로 실행.
---

## 스케줄 목록

아래 스케줄을 CronCreate(durable=true, recurring=true)로 등록한다:

| 시간 | cron | 프롬프트 |
|------|------|---------|
| 매일 08:00 | `57 7 * * *` | morning-agent.md를 읽고 아침 브리핑을 생성하여 텔레그램으로 전송해줘. |
| 매일 13:00 | `3 13 * * *` | reflection-agent.md 점심 체크인 모드를 시작하여 텔레그램으로 전송해줘. |
| 매일 22:00 (일요일 제외) | `57 21 * * 1-6` | reflection-agent.md 자기 전 회고 모드를 시작하여 텔레그램으로 전송해줘. |
| 일요일 22:00 | `57 21 * * 0` | reflection-agent.md 주간 회고 모드를 시작하여 텔레그램으로 전송해줘. |

## 7일 만료 대응

CronCreate의 recurring 작업은 7일 후 자동 만료된다.
세션 시작 시 이 스킬을 실행하여 스케줄을 재등록한다.

## 월간 업데이트

매달 15일은 CronCreate로 등록하지 않고, 아침 브리핑 프롬프트 안에서 날짜를 확인하여 15일이면 월간 업데이트를 시작한다.
```

- [ ] **Step 2: 커밋**

```bash
git add .claude/skills/sullivan-scheduler.md
git commit -m "feat: add sullivan-scheduler skill for CronCreate scheduling"
```

---

## Task 4: CLAUDE.md 업데이트

**Files:**
- Modify: `sullivan/CLAUDE.md`

채널 모드 운영 규칙을 CLAUDE.md에 추가.

- [ ] **Step 1: 채널 운영 섹션 추가**

CLAUDE.md의 `## 시스템 설정` 섹션 아래에 추가:

```markdown
## 채널 모드 (Claude Code Channel)

Sullivan은 Claude Code Channel을 통해 텔레그램과 연결된다.
Python 봇(sullivan-bot/)은 fallback으로 유지하되, 기본 운영은 채널 모드.

### 세션 시작 시

1. 채널 연결 확인 — 텔레그램 메시지가 들어오는지 체크
2. 스케줄 등록 — sullivan-scheduler.md 스킬 실행
3. hminn-now.md 읽기 — 흐민 현재 상태 파악

### 메시지 처리

모든 텔레그램 메시지는 sullivan-channel.md 스킬을 따른다.
각 에이전트 역할은 `.claude/agents/*.md`를 직접 읽고 수행한다.

### 파일 경로

- Obsidian vault: `/Users/hminn/Library/Mobile Documents/iCloud~md~obsidian/Documents/Helen`
- 에이전트 프롬프트: `.claude/agents/*.md`
- 스킬: `.claude/skills/*.md`
- 흐민 상태: `.claude/hminn-now.md`
```

- [ ] **Step 2: 커밋**

```bash
git add CLAUDE.md
git commit -m "docs: add channel mode operation rules to CLAUDE.md"
```

---

## Task 5: Capture 에이전트 채널 동작 검증

**Files:**
- Reference: `.claude/agents/capture-agent.md`
- Reference: `.claude/skills/sullivan-channel.md`

채널 모드에서 캡처가 정상 동작하는지 E2E 검증.

- [ ] **Step 1: 텍스트 캡처 테스트**

텔레그램에서 일반 텍스트 전송 → Claude Code가 capture-agent.md를 따라 분류·요약·저장하는지 확인.

검증 항목:
- 카테고리 자동 분류
- Obsidian 파일 생성 (`Sullivan/Captures/YYYY-MM-DD/[제목].md`)
- frontmatter 형식 정확성
- 텔레그램 응답 형식 (`[분류] 제목\n\n요약`)

- [ ] **Step 2: URL 캡처 테스트**

일반 URL 전송 → WebFetch로 본문 추출 → 요약·저장 확인.

- [ ] **Step 3: YouTube 링크 테스트**

YouTube URL 전송 → 제목 추출 → 저장 확인.

- [ ] **Step 4: LinkedIn 링크 테스트**

LinkedIn URL 전송 → 본문 추출 확인.
주의: Voyager API는 쿠키 인증 필요 → Bash tool로 curl 호출 또는 Python 스크립트 실행.

- [ ] **Step 5: /memo + 리마인드 테스트**

`/memo 테스트 메모` → 캡처 후 "리마인드 해줄까?" → "10분 후" → CronCreate 등록 확인.

- [ ] **Step 6: 관련 노트 연결 테스트**

키워드가 기존 노트와 매치되는 텍스트 전송 → `관련: [노트](/missions/노트/)` 포함 확인.

---

## Task 6: Reflection 에이전트 채널 동작 검증

**Files:**
- Reference: `.claude/agents/reflection-agent.md`

- [ ] **Step 1: 점심 체크인 테스트**

`/lunch` 전송 → "오전 어땠어?" → 답변 → 에너지 질문 → 답변 → 오후 방향 제안.
멀티턴이 세션 컨텍스트로 자연스럽게 유지되는지 확인.

- [ ] **Step 2: 자기 전 회고 테스트**

`/night` 전송 → 맥락 기반 질문 → 답변 → 심화 질문 → 답변 → 리포트 생성 + Obsidian 저장.
검증: 오늘 Captures 읽기, 메모 카테고리 제외, frontmatter 정확성.

- [ ] **Step 3: 주간 회고 테스트**

`/weekly` 전송 → 7일치 데이터 기반 리포트 → [다음 주 한 가지] 질문 → 최종 리포트 저장.

- [ ] **Step 4: 세션 타임아웃 동작 확인**

회고 시작 후 응답 없이 방치 → 채널 모드에서는 타임아웃 없이 대기 (세션 컨텍스트가 유지되므로).
이것이 문제가 되는지 확인 — 오래된 회고 세션이 방치되면 다음 메시지에서 혼란 가능성.

---

## Task 7: Morning/Insight 에이전트 + 스케줄링 검증

**Files:**
- Reference: `.claude/agents/morning-agent.md`
- Reference: `.claude/agents/insight-agent.md`
- Reference: `.claude/skills/sullivan-scheduler.md`

- [ ] **Step 1: 스케줄 등록 테스트**

sullivan-scheduler.md 실행 → CronCreate 4개 등록 확인 → CronList로 목록 확인.

- [ ] **Step 2: Morning 브리핑 수동 테스트**

`/morning` 전송 → 어제 Captures + Reflections 읽기 → 브리핑 생성 → Obsidian 저장 + 텔레그램 응답.

- [ ] **Step 3: Insight 수동 테스트**

`/insight` 전송 → 21일치 데이터 읽기 → 연결고리 발견 → Obsidian 저장 + 텔레그램 응답.

- [ ] **Step 4: CronCreate 자동 트리거 테스트**

테스트용으로 3분 후 morning 트리거 등록:
```
CronCreate(cron="<3분후_minute> <현재_hour> <today> <month> *", recurring=false, prompt="morning-agent.md를 읽고 아침 브리핑을 생성하여 텔레그램으로 전송해줘.")
```
3분 후 자동으로 브리핑이 텔레그램에 도착하는지 확인.

---

## Task 8: LinkedIn 콘텐츠 추출 방안

**Files:**
- Reference: `sullivan-bot/agents/capture.py` (기존 Voyager API 로직 참고)

LinkedIn은 Voyager API + 세션 쿠키가 필요하여 채널 네이티브로 처리 불가. 두 가지 방안:

- [ ] **Step 1: 방안 A — Python 헬퍼 스크립트 호출**

기존 `capture.py`의 `_fetch_linkedin_content()` 함수를 독립 스크립트로 추출:

```python
#!/usr/bin/env python3
"""LinkedIn 본문 추출 헬퍼. Claude Code Channel에서 Bash로 호출."""
import sys, json
sys.path.insert(0, "/Users/hminn/claude_projects/sullivan/sullivan-bot")
from agents.capture import _fetch_linkedin_content
from config import LINKEDIN_COOKIE

url = sys.argv[1]
title, content, error = _fetch_linkedin_content(url, LINKEDIN_COOKIE)
print(json.dumps({"title": title, "content": content, "error": error}, ensure_ascii=False))
```

Claude Code에서 호출:
```bash
python3 sullivan-bot/tools/fetch_linkedin.py "<url>"
```

- [ ] **Step 2: 방안 B — WebFetch 도구 테스트**

Claude Code의 WebFetch 도구가 LinkedIn Voyager API에 접근 가능한지 확인.
(쿠키 헤더 전달이 안 되면 방안 A 사용)

- [ ] **Step 3: 선택 및 sullivan-channel.md 업데이트**

LinkedIn 처리 방식을 sullivan-channel.md에 명시.

---

## Task 9: Python 봇 중지 및 전환

**Files:**
- Modify: `sullivan-bot/sullivan.bot.plist`

모든 검증이 완료된 후 실행.

- [ ] **Step 1: Python 봇 중지**

```bash
launchctl stop sullivan.bot
launchctl unload ~/Library/LaunchAgents/sullivan.bot.plist  # 자동 재시작 방지
```

- [ ] **Step 2: 채널 세션 시작**

```bash
# 기존 토큰 재사용 시
cd /Users/hminn/claude_projects/sullivan
claude --channels plugin:telegram@claude-plugins-official

# 별도 토큰 사용 시
TELEGRAM_STATE_DIR=~/.claude/channels/telegram-sullivan \
cd /Users/hminn/claude_projects/sullivan && \
claude --channels plugin:telegram@claude-plugins-official
```

- [ ] **Step 3: 스케줄 등록**

세션 시작 후 sullivan-scheduler.md 스킬 실행하여 CronCreate 등록.

- [ ] **Step 4: 24시간 모니터링**

하루 동안 운영하면서 확인:
- 08:00 아침 브리핑 자동 발송
- 13:00 점심 체크인 자동 시작
- 22:00 자기 전 회고 자동 시작
- 캡처/채팅 정상 동작
- Obsidian 파일 정상 저장 + git sync

- [ ] **Step 5: 안정화 후 Python 봇 코드 보관**

```bash
# 삭제하지 않고 브랜치로 보관
git checkout -b archive/python-bot
git checkout main
```

---

## 마이그레이션 롤백 플랜

채널 모드에서 문제 발생 시:

```bash
# 1. Claude Code 세션 종료 (Ctrl+C)
# 2. Python 봇 복원
launchctl load ~/Library/LaunchAgents/sullivan.bot.plist
launchctl start sullivan.bot
```

Python 봇 코드는 그대로 유지되므로 즉시 롤백 가능.

---

## 비용 비교 (예상)

| 항목 | Python 봇 (현재) | 채널 모드 (이후) |
|------|------------------|------------------|
| 캡처 1건 | Sonnet API ~$0.01 | $0 (구독 내) |
| 아침 브리핑 | Haiku API ~$0.003 | $0 |
| 회고 1회 | Sonnet API x2~3 ~$0.03 | $0 |
| 월간 예상 | $5~15 | $0 추가 |
| 인프라 | launchd 데몬 | 터미널 세션 유지 |
