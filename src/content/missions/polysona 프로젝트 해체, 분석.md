# Polysona — Juice Note (Deep)

## 스킬 개요
- 이름: Polysona (Multi-Persona AI Agent Framework)
- 목적: 심리학 기반 인터뷰로 사용자의 무의식 패턴까지 추출해 다중 페르소나를 구축하고, 5개 에이전트 파이프라인으로 플랫폼별 콘텐츠를 생성·검증·발행하는 오케스트레이션 시스템
- 규모: 레포 전체 약 30+ 파일, agents 5개, skills 8개, hooks 4개, personas 템플릿 3개
- frontmatter: agents에 `name`, `description`, `tools` 필드. skills에 `name`, `description`, `agent`, `context` 필드
- 구조: `agents/` (에이전트 스펙), `skills/` (스킬 프로토콜), `personas/{id}/` (페르소나 데이터), `content/` (drafts/qa/trends/published), `hooks/` (라이프사이클 가드)

---

## 1. 설계 철학

**"기능이 아닌 정체성에서 콘텐츠가 나온다"**

Polysona의 핵심 전제는 콘텐츠 생성의 병목이 "글쓰기 능력"이 아니라 "자기 이해의 깊이"라는 것이다. 대부분의 AI 콘텐츠 도구가 "톤과 스타일을 설정하세요"에서 시작하는 반면, Polysona는 10개 심리학 프레임워크로 사용자의 무의식까지 파헤친 뒤 그 데이터를 콘텐츠의 원료로 쓴다.

> "10-framework interview flow"과 "defense-bypass prompts"로 의식적 목표와 무의식적 패턴, 그리고 **그 사이의 괴리(GAP)**까지 추출한다.

이 설계의 근본 문제의식: 사람은 자신이 누구인지 정확히 알지 못한다. "나는 미니멀리스트"라고 말하면서 압박 속에서 복잡성을 축적하는 모순 — 이 모순이야말로 진짜 콘텐츠의 원천이다.

**두 번째 원칙: "추측 없음, 증거만"**

> "uncertain claims are blocked until grounded by evidence"

시스템 전체에 "추측 금지" 원칙이 관통한다. Profiler는 추론하지 않고 기록만 하고, Admin은 파일 저장을 증명해야 하며, 모든 에이전트가 Write → Read 검증을 강제당한다. "했다고 말하지 말고, 했다는 걸 증명해라"가 시스템 전체의 태도다.

## 2. 시스템적 사고

### 2-1. 5 Ego Layer 모델 — 모순을 구조화하는 프레임

Polysona의 가장 독창적인 시스템 설계는 사람의 정체성을 5개 레이어로 분리한 것이다:

| 레이어 | 설명 | 소스 프레임워크 |
|--------|------|----------------|
| others-see-me | 남이 보는 나 | Johari, 五倫 |
| want-to-be-seen | 보여주고 싶은 나 | Goffman front stage |
| conscious-ideal | 의식적 이상 | 직접 입력 |
| rolemodel | 구체적 벤치마크 | 롤모델 분석 |
| unconscious-self | 무의식적 자아 | McAdams, IFS, Zen Koan |

핵심은 레이어 간 **GAP 감지**다:
> `~YYYY-MM-DD: GAP: conscious-ideal(minimal clarity) vs unconscious-self(complexity accumulation under pressure)`

이 GAP이 콘텐츠의 긴장감이 되고, Virtual Follower의 "rolemodel-gap scoring"의 기준이 된다. 단순히 "좋은 콘텐츠"가 아니라 "이 사람의 모순이 드러나는 진짜 콘텐츠"를 만드는 구조.

### 2-2. Append-Only + Single Source of Truth

> "each fact belongs to one owner document with references elsewhere"

데이터 아키텍처가 Git 위의 Markdown이라는 점이 흥미롭다. `persona.md`는 interview-log 섹션에 append-only로만 기록되고, 과거 기록을 수정하지 않는다. 교정은 새 타임스탬프 엔트리로 추가된다. 이것은 심리학적 관찰의 시계열적 특성을 존중하는 설계다 — 3월에 한 말과 6월에 한 말이 다르다면, 그 변화 자체가 데이터다.

### 2-3. Setup Phase → Loop Phase 분리

시스템이 두 개의 명확한 페이즈로 나뉜다:
- **Setup**: Profiler가 인터뷰 → persona.md/nuance.md/accounts.md 생성
- **Loop**: Trendsetter → Content-Writer → Virtual-Follower → Admin 순환

Setup은 한 번(또는 가끔) 실행되고, Loop는 반복된다. 이 분리가 중요한 이유: 페르소나 데이터가 콘텐츠 생성과 독립적으로 축적되므로, 콘텐츠를 만들 때마다 "당신은 누구세요?"를 다시 묻지 않는다.

### 2-4. 피드백 루프: Published → Nuance 역류

> "When engagement data is later added, update `nuance.md` platform patterns."

Admin 에이전트가 발행 후 성과 데이터를 수집하면, 그것이 `nuance.md`의 플랫폼 패턴을 업데이트한다. 즉 "LinkedIn에서 이 톤이 먹혔다"가 다음 콘텐츠 생성에 반영되는 폐쇄 루프. 대부분의 콘텐츠 시스템이 "생성 → 끝"인 반면, Polysona는 "생성 → 발행 → 성과 → 보이스 조정 → 재생성" 사이클을 설계했다.

## 3. 엔지니어링 테크닉

### 3-1. Write-then-Read 검증 패턴

모든 에이전트에 동일한 패턴이 강제된다:

> "MUST use the Write tool to save... MUST immediately use the Read tool on the saved file to confirm it exists... Only after successful Read verification, return results."

이것은 LLM 에이전트의 근본적 약점 — "했다고 거짓말하기" — 에 대한 방어 패턴이다. Write 후 Read로 실제 파일 존재를 검증하고, 검증 실패 시 성공을 주장하지 못하게 막는다.

> "If the write fails, say it failed. Do not pretend the file was saved."

**적용 가능성**: 우리 파이프라인의 QA Validator가 `NAVER_OUTPUT_PATH`에 저장할 때도 이 패턴을 적용할 수 있다. Write 후 Read로 파일 존재/내용 검증을 명시적으로 강제하는 것.

### 3-2. PLOON 테이블 포맷 — 기계 읽기 가능한 Markdown

> `[table#1](field,value)` 형식으로 구조화 데이터를 Markdown 안에 임베드

Markdown의 인간 가독성과 기계 파싱 가능성을 동시에 확보하는 커스텀 포맷. JSON이나 YAML 대신 Markdown 안에 테이블을 인라인하므로, LLM이 자연스럽게 읽고 쓸 수 있으면서도 구조화 질의가 가능하다.

### 3-3. `!` 셸 프리로드 패턴 (Context Injection)

스킬 파일에서 `!` 프리픽스로 셸 명령을 실행해 컨텍스트를 주입한다:

```
!`ACTIVE=$(cat personas/_active.md 2>/dev/null || echo "default"); cat "personas/$ACTIVE/persona.md"`
```

에이전트 실행 전에 관련 페르소나 데이터를 자동으로 로드하는 패턴. 사용자가 "내 페르소나를 먼저 읽어"라고 말할 필요 없이, 스킬이 실행되는 순간 필요한 컨텍스트가 자동으로 주입된다.

### 3-4. Graceful Fallback with Local Data

Trendsetter에서:
> "If live search is unavailable or slow, fall back immediately to persona/account-derived topic angles from local files."

외부 API 실패를 대비한 로컬 폴백. 트렌드를 웹에서 못 가져오면, 페르소나 데이터에서 "이 사람이 관심 가질 만한 주제"를 역추론한다. 완벽한 데이터 없이도 유용한 결과를 내는 degradation 패턴.

## 4. 프롬프트 설계

### 4-1. 역할을 "하지 않는 것"으로 정의

Profiler 에이전트의 핵심:
> "extraction only: it elicits raw material and records it faithfully"
> "does not rewrite existing blocks, merge historical logs destructively, or infer unsupported traits"

"무엇을 하라"보다 "무엇을 하지 말라"가 더 많다. 이것은 LLM의 기본 성향(요약하기, 추론하기, 구조화하기)을 적극적으로 억제하는 프롬프트 설계다. Profiler가 "이 사람은 이런 사람인 것 같다"고 추론하면 원본 데이터가 오염되므로, 기록만 하게 강제한다.

### 4-2. 구체적 출력 형식 강제

모든 에이전트에 정확한 파일 템플릿이 제공된다:
- Trendsetter: "Return exactly 5 numbered items"
- Content-Writer: "Generate exactly 3 draft variations"  
- Virtual-Follower: "Return TOP 5 recommendations"

숫자를 정확히 명시하고, 템플릿을 마크다운으로 제공함으로써 LLM의 "적당히" 경향을 차단한다.

### 4-3. 심리학 프레임워크의 Theory of Mind 활용

10개 프레임워크 중 특히 주목할 것:

- **Clean Language**: "사용자의 표현을 그대로 사용, 인터뷰어 오염 최소화" — LLM이 자기 어휘로 바꿔 말하는 습관을 억제
- **Zen Koan**: "역설적 질문으로 개념 이전의 반응 패턴 접근" — 의식적 답변을 우회하는 프롬프트 기법
- **IFS**: "내면의 파트들을 탐색하되 병리화하지 않음" — LLM이 판단하지 않도록 가드레일

이 프레임워크들 자체가 "LLM에게 어떻게 인터뷰하게 할 것인가"에 대한 고도의 프롬프트 설계다. 특히 방어 메커니즘을 우회하는 프롬프트("defense-bypass prompts")라는 개념은, 사용자가 스스로 인식하지 못하는 패턴을 끌어내기 위한 의도적 설계.

### 4-4. 플랫폼별 톤 매트릭스

nuance.md의 플랫폼 테이블:
> `x | 짧고 날카로운 | 솔직히 ~ | 낮음`
> `brunch | 에세이형, 감성적 | ~ 라는 생각이 들었다 | 없음`

플랫폼별로 톤, 훅 패턴, 이모지 밀도까지 구조화된 매트릭스. Content-Writer가 이 데이터를 읽고 플랫폼에 맞는 콘텐츠를 생성한다. 우리 파이프라인의 brand-voice 체크리스트와 유사하지만, 여기서는 **페르소나 데이터에서 자동 추출된 보이스**라는 점이 다르다.

## 5. 사용자 경험

### 5-1. 활성 페르소나 자동 감지

> `ACTIVE=$(cat personas/_active.md 2>/dev/null || echo "default")`

사용자가 매번 "내 페르소나는 X야"라고 말할 필요 없다. `_active.md` 파일 하나로 현재 활성 페르소나를 추적하고, 모든 스킬이 자동으로 해당 페르소나를 로드한다. 다중 페르소나 전환은 이 파일 하나만 바꾸면 된다.

### 5-2. 에러 시 투명한 실패

> "If no draft file exists, report that QA is blocked instead of inventing an evaluation."
> "If the write fails, say it failed. Do not pretend the file was saved."

모든 에이전트가 "실패 시 솔직히 말해라" 원칙을 따른다. LLM의 "대충 만들어서라도 답하기" 습성을 명시적으로 차단. 사용자 입장에서는 거짓 성공보다 투명한 실패가 훨씬 낫다.

### 5-3. Hooks로 안전장치 자동화

`pre-tool-use.sh`가 persona 파일에 Write 시도 시 경고를 자동 발생:
> "WARNING: Writing to persona file... Ensure you have Read this file first to avoid overwriting PLOON data."

사용자나 에이전트가 실수로 페르소나 데이터를 덮어쓰는 것을 hooks 레벨에서 방지. `session-start.sh`는 세션 시작 시 활성 페르소나 요약과 핵심 규칙을 자동 출력해서, 에이전트가 "지금 누구의 콘텐츠를 만들고 있는지"를 항상 인지하게 한다.

### 5-4. 커맨드 인터페이스 이중화

같은 기능을 Codex(`$interview`, `$trend`)와 Claude Code(`/interview`, `/trend`)에서 모두 사용 가능. `scripts/sync-codex-skills.mjs`로 두 환경 간 스킬을 동기화한다. 플랫폼 종속 없이 동일한 워크플로우를 유지하는 설계.

## 6. 내 작업에 적용

### 6-1. Write-then-Read 검증을 네이버 파이프라인에 도입

현재 `qa-validator` 에이전트가 `NAVER_OUTPUT_PATH`에 파일을 저장하지만, 저장 후 실제 파일을 다시 읽어 검증하는 단계가 명시적이지 않다. Polysona의 "Write → Read → 검증 실패 시 명시적 실패 보고" 패턴을 `qa-validator.md`에 추가하면 hallucination 방지에 효과적일 것이다.

### 6-2. 플랫폼별 톤 매트릭스의 구조화

현재 우리의 brand-voice는 체크리스트 형태인데, Polysona의 `nuance.md`처럼 플랫폼별 톤/훅패턴/이모지밀도를 **테이블 형태로 구조화**하면 Content Strategy 단계에서 더 정밀한 플랫폼 맞춤이 가능할 것이다. 특히 LinkedIn과 네이버 블로그의 톤 차이를 데이터로 명시하는 것.

### 6-3. GAP 개념의 콘텐츠 적용

Polysona의 5 Ego Layer GAP 감지는 "사람의 모순에서 콘텐츠가 나온다"는 통찰이다. 흐민의 콘텐츠에서도 "전문가적 관점 vs 개인적 경험의 긴장", "체계적 접근 vs 직관적 발견의 괴리" 같은 GAP을 의도적으로 드러내면 콘텐츠 깊이가 달라질 수 있다. content-strategy 에이전트에 "소재의 내적 긴장/모순을 찾아라"는 지시를 추가하는 것을 고려할 만하다.

### 6-4. Hooks를 활용한 파이프라인 가드레일

Polysona의 `pre-tool-use.sh`처럼, 우리 파이프라인에서도 VAULT_PATH에 Write 시도를 감지해 차단하는 hook을 추가할 수 있다. 현재 CLAUDE.md에 "Obsidian 소스 볼트 읽기 전용"이라고 명시되어 있지만, hook 레벨에서 강제하면 에이전트의 실수를 시스템적으로 방지할 수 있다.

### 6-5. 셸 프리로드 패턴의 스킬 적용

`!` 셸 프리로드로 에이전트 실행 전에 필요한 컨텍스트를 자동 주입하는 패턴은, 우리의 source-reader가 하는 일을 스킬 레벨에서 더 가볍게 구현한 것이다. 특히 네이버 파이프라인의 photo-analyzer가 실행될 때 이전 세션의 사진 분석 결과를 자동으로 프리로드하는 데 이 패턴을 활용할 수 있다.
