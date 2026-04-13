Remotion은 React 코드로 영상을 만드는 프레임워크


# 터미널에서 Claude Code로 영상 만들기 🎬
http://localhost:3000/TutorialVideo
![TutorialVideo.mp4](/images/TutorialVideo.mp4)
> **Remotion + Claude Code 실전 가이드**  
> 영상 편집 툴 없이, 코드도 직접 안 짜고, 자연어로 AI랑 대화하면서 영상 만드는 법.  
> 실제 해보니까 **총 30~40분** 정도면 첫 영상까지 뽑을 수 있어요.

---

## 🎯 이게 뭔가요?

**Remotion** = React로 영상을 만드는 프레임워크 (프레임 = React 컴포넌트)  
**Claude Code** = 터미널에서 돌아가는 AI 코딩 어시스턴트  
**둘이 만나면** → 자연어로 "이런 영상 만들어줘" 하면 AI가 코드를 짜고, 브라우저에서 실시간으로 미리보기 확인하면서 수정 가능.

After Effects나 프리미어 없이, 코드 한 줄도 안 건드리고 영상을 뽑을 수 있습니다.

---

## ✅ 사전 준비 (한 번만)

1. **Node.js 18 이상** 설치 (이미 있으면 스킵)
    - 확인: 터미널에 `node -v` → v18 이상이면 OK
2. **Claude Code 설치 & 로그인**
    - 설치: `npm i -g @anthropic-ai/claude-code`
    - 로그인: 터미널에서 `claude` 실행 후 `/login` 입력 → 브라우저 인증
3. **작업 폴더 위치 정하기** (예: `~/Desktop/ClaudeProjects/`)

---

## 🚀 전체 과정 (4단계)

### 1단계. Remotion 프로젝트 생성

터미널 열고 작업 폴더로 이동:

bash

```bash
cd ~/Desktop/ClaudeProjects
```

프로젝트 생성:

bash

```bash
npx create-video@latest
```

- 프로젝트 이름 묻는데 원하는 이름 입력 (예: `video`)
- 템플릿 선택 → **Blank** 추천 (가장 깔끔)
- 템플릿 복사 완료되면 폴더 안으로 이동:

bash

```bash
cd video
```

---

### 2단계. 패키지 설치 & 서버 실행

bash

```bash
npm install
```

- 316개 패키지가 설치됨 (1~3분 소요)
- 중간에 warning 떠도 무시 OK, error만 없으면 정상

서버 실행:

bash

```bash
npm run dev
```

- **`Server ready - Local: http://localhost:3000`** 뜨면 성공
- 브라우저에서 [http://localhost:3000](http://localhost:3000) 열기 → **Remotion Studio** 등장
- 🚨 **이 터미널 창은 절대 끄지 마세요** (끄면 미리보기도 꺼져요)

---

### 3단계. Remotion 스킬 설치 (핵심)

**새 터미널 탭 열기** (`Cmd + T`) → 같은 프로젝트 폴더로 이동:

bash

```bash
cd ~/Desktop/ClaudeProjects/video
```

Claude Code용 Remotion 스킬 설치:

bash

```bash
npx remotion skills add
```

- `remotion-best-practices` 스킬이 `.agents/skills/` 폴더에 설치됨
- 이 스킬이 설치되어 있으면 Claude Code가 Remotion 문법·베스트프랙티스를 **자동으로** 참고해서 코드를 짜줌
- 한 번만 설치하면 됨, **31개 에이전트(Claude Code, Cursor 등) 공통으로 인식**

---

### 4단계. Claude Code로 영상 제작

같은 탭에서 Claude Code 실행:

bash

```bash
claude
```

이제 자연어로 요청하면 됩니다:

> "1분짜리 제품 소개 영상을 만들어줘. 다크 배경에 옐로우 포인트, 터미널 타이핑 애니메이션이랑 체크리스트 씬 넣어줘."

Claude Code가:

1. 씬별로 파일(`src/scenes/Intro.tsx` 등)을 만들고
2. `spring()`, `interpolate()`, `TransitionSeries` 같은 Remotion 기법으로 애니메이션 코드를 짜고
3. 저장할 때마다 **브라우저 미리보기가 실시간으로 업데이트**됨

수정도 자연어로:

- "인트로 더 천천히 해줘"
- "옐로우를 더 진하게 바꿔줘"
- "Scene 3에 배경음악 넣어줘"

---

## 🖥️ 동시에 봐야 할 3개 화면

|창|역할|주의사항|
|---|---|---|
|🖥️ **터미널 탭 1**|`npm run dev` 서버|끄면 안 됨|
|💬 **터미널 탭 2**|Claude Code 대화|여기서 요청 보냄|
|🌐 **브라우저**|[http://localhost:3000](http://localhost:3000) (Remotion Studio)|실시간 미리보기|

---

## 🎞️ 최종 영상 파일로 뽑기 (렌더링)

Claude Code에서 영상 완성되면:

bash

```bash
npx remotion render
```

- 또는 Claude Code에 "영상 렌더링해줘" 라고 하면 자동 실행
- 완성된 MP4는 `out/` 폴더에 저장됨
- 재생: `open out/video.mp4` (맥 QuickTime 자동 실행)

---

## 🎵 음악 / 효과음 넣기 (옵션)

### 음원 준비

무료 사이트에서 다운:

- **Pixabay Music** — [https://pixabay.com/music/](https://pixabay.com/music/) (BGM)
- **Mixkit** — [https://mixkit.co/free-stock-music/](https://mixkit.co/free-stock-music/) (BGM)
- **Freesound** — [https://freesound.org](https://freesound.org) (효과음)

### 파일 배치

프로젝트 안 `public/` 폴더에 넣기:

```
video/public/
├── bgm.mp3         ← 배경음악
├── typing.mp3      ← 타이핑 효과음
└── ding.mp3        ← 체크 효과음
```

### Claude Code에 요청

> "public/bgm.mp3를 전체 영상에 볼륨 30%로 깔아줘. 끝나기 1초 전부터 페이드아웃."

---

## 💡 꿀팁 & 주의사항

### ✅ 이렇게 하세요

- **씬 하나씩** 만들면서 확인 → 한 번에 다 만들면 수정 어려움
- **브랜드 컬러 팔레트**를 프롬프트 앞부분에 정의해두기 (우리 셀피쉬 컬러처럼)
- 애니메이션은 반드시 **`useCurrentFrame()` 기반** (CSS transition 금지 — 렌더링 시 깨짐)
- `interpolate()` 쓸 때 꼭 `extrapolateLeft: 'clamp', extrapolateRight: 'clamp'` 붙이기

### ⚠️ 자주 나오는 에러

|에러|원인|해결|
|---|---|---|
|`API Error: 401`|Claude Code 로그인 만료|`/login` 재실행|
|`npx: command not found`|Node.js 미설치|Node 18+ 설치|
|미리보기가 안 뜸|`npm run dev` 종료됨|첫 터미널에서 다시 실행|
|`Stop hook error`|`say-summary` 플러그인 에러|**무시해도 됨** (영상엔 영향 없음)|

---

## 📝 실제 소요 시간 (우리 팀 테스트 기준)

|단계|시간|
|---|---|
|프로젝트 생성 + npm install|3분|
|스킬 설치|1분|
|Claude Code로 1분 30초 튜토리얼 영상 제작|**5~6분**|
|수정 & 폴리싱|10~15분|
|최종 렌더링|1~2분|
|**총계**|**약 20~30분**|

---

## 🎬 처음 해보는 팀원용 꿀팁 프롬프트

이 문장을 Claude Code에 그대로 붙여넣으면 튜토리얼 영상 하나가 뚝딱 나옵니다:

```
1분짜리 튜토리얼 영상을 만들어줘. 1920×1080, 30fps.

스타일: 다크 배경 #1A1A1A + 옐로우 포인트 #FFD84D + 코랄 CTA #FF6B5A

씬 구성:
1. 인트로 — 타이틀 spring 등장
2. 터미널 타이핑 애니메이션 (명령어 한 줄씩 타이핑 효과)
3. 체크리스트 씬 (✓ 체크 팝업)
4. 아웃트로 CTA 버튼

기법: useCurrentFrame 기반, spring/interpolate/TransitionSeries 활용,
interpolate에는 extrapolate clamp 적용.

씬 하나씩 만들면서 localhost:3000으로 확인할 수 있게 해줘.
Step 1부터 시작!
```

---

## 🔗 참고 링크

- Remotion 공식 문서: [https://www.remotion.dev/docs


## 📱 휴대폰에서도 작업 이어가기 (Remote Control)

Claude Code에 **Remote Control** 기능이 있어서, 데스크탑에서 시작한 세션을 그대로 **휴대폰에서 이어받을 수 있어요**. 렌더링 걸어두고 자리 비울 때, 이동 중에 피드백 주고받을 때 진짜 편해요.

### 어떻게 작동하냐면

- 세션 자체는 **내 컴퓨터에서 계속 돌아감** (코드·파일은 클라우드로 안 올라감)
- 휴대폰/브라우저는 그냥 "원격 창" 역할
- Claude 앱(iOS/Android) 또는 `claude.ai/code` 웹에서 접속 가능

### 사용법 (3단계)

1. **Claude Code 세션 안에서 명령어 입력**

```
   /remote-control
```

2. 터미널에 **QR 코드 + 세션 URL**이 뜸
    - QR 코드를 휴대폰 카메라로 스캔 → Claude 앱에서 바로 열림
    - 또는 URL을 브라우저에 붙여넣기
3. 이제 휴대폰에서 명령 입력하면 데스크탑 Claude Code가 실행!
    - 데스크탑·휴대폰·브라우저 **전부 실시간 동기화**
    - 어느 기기에서든 메시지 보낼 수 있음

### 활용 시나리오

- ☕ 렌더링 돌려놓고 카페에서 진행 상황 확인
- 🚶 산책하면서 "인트로 타이틀 좀 더 크게 해줘" 요청
- 🛋 소파에서 수정사항 보내고 다시 책상으로 돌아왔을 때 이어서 작업



----------

## 기존에 만들어 둔 캐러셀 편집기 수정
https://zemma-carousel.vercel.app/

### 1. 슬라이드 MP4 영상 다운로드 기능

**기능:** 슬라이드에 비디오가 포함된 경우, 슬라이드 전체를 MP4로 녹화 다운로드

**동작 방식:**

1. 슬라이드 내 비디오 요소 위치 계산
2. html2canvas로 배경(텍스트, 이미지, 워터마크) 캡처 (비디오 제외)
3. 2160x2700 출력 캔버스 생성
4. 비디오 재생 → requestAnimationFrame으로 매 프레임 배경+비디오 합성
5. canvas.captureStream(30fps) + MediaRecorder로 녹화
6. 가장 긴 비디오 기준으로 녹화 후 파일 저장


### 2. 이미지/비디오 영역 높이 리사이즈 기능

**기능:** 모든 이미지/비디오 영역 하단에 드래그 핸들 추가 → 높이 자유 조절

**적용 영역:** 일반 미디어 영역 + Before/After 비교 이미지 영역

**조작:** 하단 노란색 핸들을 마우스 드래그 (최소 120px ~ 최대 900px)

**구현:** onResize 콜백 → slides 상태의 element.height 실시간 업데이트 → PNG/MP4 다운로드 시에도 반영

---

## 3. 다운로드 시 비율 찌그러짐 수정

**문제:** PNG/MP4 다운로드 시 이미지/비디오가 찌그러져 보이는 현상

**원인:** 슬라이드가 `display: flex; height: 1350px` 고정인데, 콘텐츠 총 높이가 1350px 초과 시 flexbox의 기본 `flex-shrink: 1`이 이미지 박스 높이를 강제 축소 → 비율 왜곡

**해결:**

- `.slide-canvas > *` 및 하위에 `flex-shrink: 0` CSS 적용
- MediaUpload, Before/After 래퍼에 `flexShrink: 0` 인라인 추가
- 슬라이드 컨테이너에 `overflow: hidden` 추가
