### 결과물

### **과제1. 23(월) 자정까지  (완료)**

https://www.linkedin.com/feed/update/urn:li:activity:7441832655765004289/?originTrackingId=QPsbUyfdExiU1R1qIc79sw%3D%3D

### **과제2. 아래 내용 중 택 1로 진행해주세요(꼭 아래 유튜브 아니여도 되나, 레퍼런스 가지고 진행해주세요)**

### **2.2** 원소스 멀티유즈 하기

https://content-marketing-team.vercel.app/


### **과제3. 위의 과제를 하시면서, 오마이오픈코드 or 오마이클로드코드 중에 하나를 사용해주세요**

오마이 클로드 다운후 기본베이스로 활용가능


추가기능

비용관리 (영수증을 업로드하면 자동으로 비용처리로 들어가게 (메타광고도 됩니다)



### 만든과정 및 삽질

1. 폴더를 제작후 그폴더로 경로를 설정한다
2. 이후 git에서 AI 자동생성 소스코드를 클론해서 가져온다
    
    
3. 프로젝트 구조 생성후 웹사이트 형식으로 요청
    1. 깃허브와 버셀은 계정에 공식으로 연결되어있는 github 계정과 vercel 계정을 활용해서 자동배포진행완료


1. 유튜브 API키가 필요해서 생성후 전달\
    
    
2. 작동테스트완료


### 인사이트

- OMC 사용시 아래 툴팁
    
    
    - 5H : 5시간 사용가능량  (업데이트 남은시간)
    - WK (주간 사용량)
    - thinking → 현재 사용중인 스킬
    - session : 터미널 사용시간
    - CTX : 사용한 컨텍스트 양 (한번에 클로드 코드가 이해할수있는 양) 많아지면 속도느려짐
    - T :나와 대화한 텍스트 수
    - A : 사용중인 에이전트 수
    - S: 사용중인 스킬의 수
    - 중간중간 작업시 shift + Tab 사용시 폴더권환 외에 자동승인 기능
    
    
- /plugin  을 활용해서 마켓플레이스에서 다양한 플러그인을 다운받을수 있음 (클로드 공식)


- omc사용시 아래 CTX가 뜨게되는데 컨텍스트 사용량이며 70%이상일 경우 토큰소모 및 작업속도가 늦어질가능성 높음 일정량 초과시 알아서 클로드가 Clear 를 진행함 
(에밀리의 대화내용삭제되는게 이거인것같아요)
    - 중간중간 작업완료시 깃허브에 배포하고 /clear 을 통해 대화를 줄여가면서 작업하면 토큰소모를 줄일수 있을것 같음
- team 5를 활용해서 5개의 에이전트에게 일을시키니 토큰소모는 엄청났지만 보다 빠른 결과를 얻을수 있엇음
- 터미널 클로드코드에서 프리뷰요청시 클로드 코드앱에서 볼수있게해주었다
- 터미널 클로드 코드 기본 모델은 high effort로 되어있지만
    - /model을 통해서 Fegault 값을 Max effort로 변경가능하다 (보다 깊이 있는 생각 제한없는 리미트)


클로드 디스패치 기능 활용해보기

1. 최신버전의 클로드코드앱 설치 
2. 모바일에 동일한 계정의 클로드 앱 설치
3. 앱에서 디스패치 기능에서 채팅입력 (컴퓨터가 켜져있어야함 ( 절전모드 해제도 필수)
4. 대화는 모바일과 데스크탑에서 모두 확인이 가능하고 입력가능
    
    
5. 코드작업의 경우 폴더권한을 승인요청함
    
    
6. 폴더 권한요청을 끝낸후에는 코워크와 연결을통해 작업진행

7. 폴더의 정확한 경로를 알고있으면 일을 시키기 편리함 
    1. 예 ) "C:\Users\yesun\growthlink pj”
    2. 밥먹으러 갈때 진행상황이나 작업한내용을 확인하거나, 분석할때는 좋아보임
    
    


- OMC team 기능 사용시?
    - `omc team 3`  : OMC가 알아서 역할 배정
        
        OMC가 작업 내용을 분석해서 적절한 에이전트를 **자동으로 섞어서** 배치해요:
        
        - 에이전트 1 → `architect` (설계)
        - 에이전트 2 → `executor` (구현)
        - 에이전트 3 → `test-engineer` (테스트)
    - `omc team 3:executor`  : 전부 같은 역할로 고정
        
        3개 에이전트가 **전부 executor(구현)**으로 고정:
        
        - 에이전트 1 → `executor` (구현)
        - 에이전트 2 → `executor` (구현)
        - 에이전트 3 → `executor` (구현)
- 옵시디언 활용해보기
    
    step 1. 옵시디언 설치 → 버전업데이트 확인 필수
    
    - 옵시디언에서 설정 → 일반 → 명령줄 인터페이스 기능 활성화 (터미널에서 옵시디언 활성화 하는법)
    
    
    - 터미널에서  `obsidian` 입력시 활성화 완료
    
    step 2. 클로드코드에서 옵시디언 공식 SKILL 설치진행
    
    
    - https://github.com/kepano/obsidian-skills
    
    /plugin marketplace add kepano/obsidian-skills
    /plugin install obsidian@obsidian-skills
    
    완료후 클로드에게 obsidian CLI 사용가능한지 확인요청
    
    
    - 활용후 프롬프트로 브리핑 노트 제작
    
    ```jsx
    현재 14일간 생성 및 수정된 노트 읽어서 내 현재 상황과 앞으로 뭘하면 좋을지 브리핑을 한 후
    노트로 만들어주는 스킬을 만들어줘
    ```
    
    
    - 결과물
    
    
    - step 3.  브리핑 토대로 미션 /과제 해결하기
        - (team 3활용) 미해결한 미션 해결해줘 :
            - 제작된브리핑을 읽고 미션해결 진행
    
    
    - 해결된 사항은 옵시디언 브리핑에 자동업데이트 (완료 확인)
        - 후기 : 가시성이 있어서 좋고 완료되면 자동업데이트 되는것도 좋네요!
    
    

플러그인 추천

**claude-md-management** (Plugin · claude-plugins-official)
CLAUDE.md 파일을 관리하는 플러그인. 프로젝트별 컨텍스트 파일을 생성·편집·최적화하는 슬래시 커맨드 제공.

**context7** (Plugin + MCP · connected ✅)
라이브러리 공식 문서와 코드 예제를 실시간으로 가져오는 플러그인. MCP가 정상 연결되어 있어서 Claude Code가 최신 API 문서를 직접 참조 가능.

**discord** (Plugin · enabled) — 단, MCP는 ❌ failed
Discord 서버/채널 관리 및 메시지 자동화 플러그인. MCP 연결이 실패한 상태라 도구 기능은 작동 안 함.

**feature-dev** (Plugin · claude-plugins-official)
기능 개발 워크플로우를 자동화하는 플러그인. 이슈 → 기획 → 구현 → PR 흐름을 에이전트로 처리.

**firecrawl** (Plugin · claude-plugins-official)
웹 스크래핑·크롤링 도구. URL을 주면 Claude Code가 웹 콘텐츠를 읽어서 분석 가능.

**frontend-design** (Plugin · claude-plugins-official)
UI 컴포넌트 생성, 디자인 시스템 적용, 프론트엔드 코드 품질 개선을 위한 스킬/에이전트 번들.

**obsidian** (Plugin · obsidian-skills)
Obsidian 노트앱 연동. 노트 생성·검색·링크 관리를 Claude Code에서 직접 수행.

**playground** (Plugin · claude-plugins-official)
Claude Code 기능 테스트·실험용 샌드박스 플러그인.

**ralph-loop** (Plugin · claude-plugins-official)
반복적인 작업을 루프 형태로 자동 실행하는 플러그인. 자기 참조적 AI 루프 구현.

**security-guidance** (Plugin · claude-plugins-official)
코드 보안 검토, 취약점 스캔, 보안 가이드라인 적용을 도와주는 플러그인.

**skill-creator** (Plugin · claude-plugins-official)
새로운 Claude Code 스킬/플러그인을 만들고 최적화하는 메타 플러그인.

claude md 작성시

기존 클로드 가이드라인, 오마이클로드코드 기능 help 등 가이드라인 링크를 참고하라고하면 보다 잘 작성해줍니다. → claude md는 300txt 이상 넘어가면 잘 작동 안한다고 합니다.

### 다시 한다면?

언제나 같은내용인것 같습니다

- 마음이 급해서 PRD는 초반용으로 만 제작하고 바로 진행을하는데 , PRD작성에 시간을 2~4시간정도 소요해서 보다 퀄리티 높은 기획이 필요할것같습니다.
- 처음 작업할때는 스킬이나 플러그인을 활용을 못햇었는데 필요한 기능을 미리 알고있어도 좋을듯합니다! (공식 마켓플레이스에서 내가 연결하고싶은 앱 있는 지 확인하기)
- CLI방식의 코딩과 연결형식이 많이 보이는데 다양하게 작업해보고싶네요!