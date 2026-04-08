---
---
# 다니_2주차 과제

week: 2주차
작성자: 다니
제출일: March 29, 2026

### 결과물

원소스 멀티유즈하기

**URL 하나를 입력하면 인스타 캐러셀 + 스레드 + 링크드인 콘텐츠를 자동으로 생성하는 시스템을 Claude Code + oh-my-claudecode로 구축**


[요즘 다들 클로드코드 말고 이거 쓴다면서요? | OpenCode 코딩 에이전트](https://www.youtube.com/watch?v=y5cze4tAXZU)







```markdown
# 링크드인 포스팅

---

Claude Code 월 구독료, 솔직히 부담되지 않으셨나요? 🤔

저도 그랬습니다. 그래서 찾아본 오픈소스 대안이 하나 있습니다.

바로 **OpenCode**라는 터미널 기반 AI 코딩 에이전트인데요.

Claude Code처럼 CLI 환경에서 코드 작성, 수정, 디버깅을 해주지만
오픈소스라서 무료로 사용할 수 있습니다.

사용해보면서 느낀 핵심 포인트 3가지를 공유드립니다.

—

**1. 비용 장벽이 사라집니다.**
Claude Code는 월 구독료 + API 비용이 발생하지만, OpenCode는 오픈소스 기반이라 도구 자체는 무료입니다. OpenAI, Anthropic, 심지어 로컬 모델까지 원하는 LLM 백엔드를 직접 골라 쓸 수 있어서 비용을 내가 컨트롤할 수 있습니다.

**2. 특정 모델에 종속되지 않습니다.**
가장 마음에 들었던 부분입니다. GPT-4o를 쓰다가 Claude로, 다시 로컬 모델로 자유롭게 전환할 수 있습니다. 하나의 도구에서 멀티 모델을 운용할 수 있다는 건, 각 모델의 강점을 상황에 맞게 활용할 수 있다는 뜻이죠.

**3. 설치가 놀라울 정도로 간단합니다.**
터미널에서 몇 줄이면 설치 끝. 복잡한 환경 세팅 없이 바로 코딩 에이전트를 사용할 수 있어서, 진입 장벽이 정말 낮습니다. 학생이나 사이드 프로젝트 개발자분들에게 특히 추천드립니다.

—

물론 Claude Code 대비 아직 생태계나 안정성 면에서 차이가 있을 수 있습니다.
하지만 오픈소스 커뮤니티의 발전 속도를 생각하면, 충분히 주목할 가치가 있다고 봅니다.

AI 코딩 도구 시장이 점점 다양해지고 있는 지금,
중요한 건 "어떤 도구를 쓰느냐"가 아니라 "내 워크플로우에 맞는 도구를 선택하는 것"이라고 생각합니다.

여러분은 AI 코딩 에이전트로 어떤 도구를 사용하고 계신가요?
Claude Code, Cursor, Copilot, 아니면 또 다른 대안이 있으신가요? 아래 댓글로 공유해 주세요! 👇

—

#OpenCode #코딩에이전트 #ClaudeCode #AI코딩 #오픈소스 #터미널코딩 #바이브코딩 #개발생산성 #LLM #개발자도구 #AIAgent #개발동생
```

```markdown
 🧵 Threads 게시물

---

**클로드코드 너무 비싸서 대안 찾다가 이거 발견함** 😮

---

OpenCode라고, 터미널에서 돌아가는 오픈소스 AI 코딩 에이전트인데
쉽게 말하면 **Claude Code의 무료 버전**이라고 보면 돼

---

뭐가 좋냐면 👇

✅ 오픈소스라 **무료**
✅ OpenAI, Anthropic, 로컬 모델 등 **LLM 골라서** 쓸 수 있음
✅ 설치도 터미널에서 한 줄이면 끝
✅ 코드 작성, 수정, 디버깅 다 됨

---

솔직히 Claude Code 월 구독료 + API 비용 내면서 쓰기엔
개인 개발자나 학생한테 부담이 꽤 크잖아 💸

OpenCode는 그 진입장벽을 확 낮춰줌

---

물론 단점도 있어.
Claude Code만큼의 **완성도나 안정성**은 아직 부족할 수 있고
커뮤니티 기반이라 **업데이트 속도**가 들쑥날쑥할 수도 있음

근데 오픈소스의 힘이 뭐냐면
사람들이 모이면 **미친 속도로 발전**한다는 거지 🚀

---

특히 멀티 모델 지원이 핵심인 게,
하나의 AI에 종속되지 않고 **상황에 따라 모델을 바꿔가며** 쓸 수 있어
→ 비용 최적화도 되고, 성능 비교도 가능

---

AI 코딩 도구 비용 때문에 고민 중이라면
일단 OpenCode 한번 깔아보고 써봐 🛠️

써본 사람은 댓글로 후기 남겨줘!

---

`#OpenCode` `#코딩에이전트` `#ClaudeCode대안` `#AI코딩` `#오픈소스` `#터미널코딩` `#바이브코딩` `#개발생산성`
```

[SNS 콘텐츠 생성기](https://content-marketing-sepia.vercel.app/)

### 만든과정 및 삽질

참고 유튜브

[요즘 다들 클로드코드 말고 이거 쓴다면서요? | OpenCode 코딩 에이전트](https://www.youtube.com/watch?v=y5cze4tAXZU)

## 🎯 목표

- 리서치한 내용(URL)을 바탕으로
- 인스타 캐러셀 7장 (Gemini 이미지 포함)
- 스레드 게시물 1개
- 링크드인 포스팅 1개
- 세 가지를 동시에 자동 생성
- 검토 후 수동 업로드

---

## 🛠 사용한 도구

| 도구 | 역할 |
| --- | --- |
| Claude Code | 터미널 기반 AI 에이전트 |
| oh-my-claudecode | 멀티 에이전트 오케스트레이션 플러그인 |
| Gemini API (나노바나나2) | 캐러셀 이미지 생성 |
| Mac 터미널 | 실행 환경 |

---

### oh-my-claudecode란?

Claude Code에 멀티 에이전트 오케스트레이션을 얹는 플러그인. 단일 에이전트 대신 **전문화된 에이전트 팀**이 병렬로 일하도록 만든다.

`일반 Claude Code = 혼자 다 하는 알바생
oh-my-claudecode = 카피라이터 + 디자이너 + 검수자가 동시에 일하는 팀`

---

### oh-my-claudecode 플러그인 설치 방법

Claude Code 실행 후 `/plugins` 입력 → 플러그인 UI 진입

`# 마켓플레이스 추가
/plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode

# 플러그인 설치
→ Marketplaces 탭 이동 (→ 방향키)
→ omc 마켓플레이스 선택
→ oh-my-claudecode 선택
→ Install for you (user scope) 선택`

### Step 5. 초기 셋업

`/oh-my-claudecode:omc-setup`

완료되면 하단 상태바에 `[OMC#4.9.3]` 표시 확인


### Step 6. Gemini API 키 발급

1. [aistudio.google.com](https://aistudio.google.com/) 접속
2. `Get API Key` → `Create API Key`
3. 키 복사 (외부 유출 절대 금지)
4. Claude Code 대화창에 입력:

`Gemini API 키를 환경변수로 설정하고
gemini-3.1-flash-image-preview 모델로
이미지를 생성하는 파이썬 스크립트를 만들어줘.
API 키: [여기에 붙여넣기]`

### Step 7. CLAUDE.md 세팅 (최초 1회)

`CLAUDE.md 파일을 만들어줘.

역할: SNS 콘텐츠 마케터
기본 작업: URL을 받으면 아래 3가지를 output 폴더에 저장

캐러셀 스타일:
- 다크 배경 (#0a0a0f)
- 노란 하이라이트 박스로 핵심 문구 강조
- 1장에 픽셀 아트 캐릭터 이미지 (Gemini로 생성)
- 구체적인 숫자/결과 포함한 카피
- 7장 구성 (1장 훅/2~6장 인사이트/7장 CTA)

스레드: threads.md (게시물 1개, 단락 나눠서)
링크드인: linkedin.md (포스팅 1개, 해시태그 포함)
언어: 한국어
톤: 전문적이지만 친근하게`

---

## 🚀 실제 워크플로우

`URL: https://youtube.com/watch?v=...

이 URL 분석해서
인스타 캐러셀 7장 (Gemini 이미지 포함),
스레드 1개, 링크드인 1개 만들어줘.
output 폴더에 저장해줘.`

결과 확인:

bash

`open ~/Desktop/content-marketing/output`

---

## 📁 생성되는 파일 구조

`content-marketing/
├── CLAUDE.md              # 에이전트 설정 (최초 1회)
├── .env                   # Gemini API 키 (절대 공유 금지)
├── generate_image.py      # 이미지 생성 스크립트
└── output/
    ├── carousel/          # PNG 이미지 7장
    │   ├── slide_01.png
    │   ├── slide_02.png
    │   └── ...
    ├── threads.md          # 스레드 게시물
    └── linkedin.md         # 링크드인 포스팅`

---

## ⚠️ 트러블슈팅

| 문제 | 원인 | 해결 |
| --- | --- | --- |
| `EACCES` 오류 | 권한 부족 | `sudo` 붙이기 |
| `Unknown skill` | 플러그인 미반영 | Claude Code 재시작 |
| 이미지 한국어 깨짐 | 구버전 모델 | `gemini-3.1-flash-image-preview`로 변경 |
| API 크레딧 부족 | API 별도 과금 | Claude Max 구독으로 터미널에서 사용 (API 키 불필요) |
| `No plugins match` | 마켓플레이스 미등록 | Marketplaces 탭에서 omc 확인 |

## 🚧 자동 업로드까지 안 되는 이유

### 인스타그램 캐러셀

**기술적 장벽이 가장 높다.**

| 문제 | 내용 |
| --- | --- |
| 비즈니스 계정 필수 | 개인 계정으로는 API 접근 불가 |
| Meta Graph API 심사 | 앱 승인까지 수일~수주 소요 |
| 이미지 업로드 방식 | 이미지를 공개 URL로 올려야 함 (로컬 파일 직접 전송 불가) |
| 캐러셀 포맷 복잡 | 슬라이드마다 media container 생성 후 묶어서 publish |

`결론: 인스타 캐러셀 자동 업로드는
      서버 + 공개 URL + Meta 앱 심사 통과가 전제조건
      → 현실적으로 수동 업로드가 맞다`

---

### 스레드 (Threads)

**API는 공개됐지만 토큰 문제가 있다.**

| 문제 | 내용 |
| --- | --- |
| 토큰 수명 1시간 | 기본 발급 토큰은 1시간만 유효 |
| 장기 토큰 연장 필요 | 2개월짜리 장기 토큰으로 교체하는 별도 작업 필요 |
| Meta 개발자 앱 등록 | Facebook 개발자 포털에서 앱 생성 + Threads API 제품 추가 |
| OAuth 인증 흐름 복잡 | 브라우저 인증 → 코드 발급 → 토큰 교환 과정 필요 |

`결론: 셋업 난이도 중간
      장기 토큰만 해결하면 자동화 가능
      → n8n으로 토큰 자동 갱신까지 구현하면 완성`

---

### 링크드인 (LinkedIn)

**API는 있지만 포스팅 권한이 제한적이다.**

| 문제 | 내용 |
| --- | --- |
| OAuth 2.0 인증 | 브라우저 로그인 → 토큰 발급 과정 필요 |
| Share on LinkedIn 제품 신청 | Developer Portal에서 별도 신청 (즉시 승인) |
| 리디렉션 URI 설정 | 로컬 개발 환경에서 설정 까다로움 |
| 토큰 만료 | 60일마다 재발급 필요 |

`결론: 셋업 난이도 중간
      Share on LinkedIn 신청 후 OAuth만 해결하면 가능
      → 3가지 중 가장 현실적으로 자동화하기 좋음`

### 인사이트

1. oh-my-claudecode의 진짜 가치는 병렬 처리
    
    일반 Claude Code는 순서대로 하나씩. oh-my-claudecode는 에이전트들이 동시에 작업 → 시간 단축.
    
2. CLAUDE.md가 핵심
    
    한 번 잘 세팅해두면 매번 길게 설명할 필요 없다. 브랜드 톤, 포맷, 스타일을 여기에 저장.
    

### 다시 한다면?

- [ ]  Threads API 연동 → 자동 업로드
- [ ]  LinkedIn API 연동 → 자동 업로드
- [ ]  n8n으로 전체 파이프라인 자동화
