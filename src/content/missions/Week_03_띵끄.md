오마이클로드 → 플러그인 (클로드 안에서 써~)

- **링크드인 스레드 유튜브 등에서 유용한 정보들 2회 이상 슬렉에 올리기**


링크드인 링크

[https://www.linkedin.com/feed/update/urn:li:activity:7445776271273357312/](https://www.linkedin.com/feed/update/urn:li:activity:7445776271273357312/)

영수증인식시 첨부된 사진도 같이 노출되도록 설정
![image - 2026-04-12T164731.202.png](/aaa-archive/images/image_-_2026-04-12T164731.202.png)
데이터토대로 분석진할수있는 대시보드 부분 추가(AI 미사용) → 결과값이 늘다르게 나오기때
![image - 2026-04-12T164729.244.png](/aaa-archive/images/image_-_2026-04-12T164729.244.png)
![image - 2026-04-12T164727.604.png](/aaa-archive/images/image_-_2026-04-12T164727.604.png)
![image - 2026-04-12T164726.095.png](/aaa-archive/images/image_-_2026-04-12T164726.095.png)
resend APi를 활용해 영수증 및 인보이스 발송탭 추가![image - 2026-04-12T164721.046.png](/aaa-archive/images/image_-_2026-04-12T164721.046.png)
![image - 2026-04-12T164724.519.png](/aaa-archive/images/image_-_2026-04-12T164724.519.png)
![image - 2026-04-12T164722.790.png](/aaa-archive/images/image_-_2026-04-12T164722.790.png)
작업이 완료되면 obsidian에 업데이트 파일을 제공하도록 클로드에게 요청진행

- 기본적인 부분은 클로드에게 보안점검을 요청하면 진행해주지만 클로드라고 완벽한것은 아니기때문에 보안관련해서 공부진행후 실제 놓친부분들은 없는지 확인이 필요해보임
![image - 2026-04-12T164718.603.png](/aaa-archive/images/image_-_2026-04-12T164718.603.png)
![image - 2026-04-12T164716.927.png](/aaa-archive/images/image_-_2026-04-12T164716.927.png)
보안점검시 이런오류들이 발생함


### 만든과정 및 삽질

기능강화

- 파이프라인 및 유저 갤러리 대시보드 제작해주라고 클로드 코드에게요청
- 영수증 발송 기능을 추가하고싶은데 메일발송기능 추가해달라고 요청
    - 활용은 resend API (일주일에 1000건 가능)
    - [https://resend.com/emails](https://resend.com/emails)
![image - 2026-04-12T164714.660 1.png](/aaa-archive/images/image_-_2026-04-12T164714.660_1.png)
보안강화![image - 2026-04-12T164712.324.png](/aaa-archive/images/image_-_2026-04-12T164712.324.png)
![image - 2026-04-12T164709.611.png](/aaa-archive/images/image_-_2026-04-12T164709.611.png)
- 최근 바이브 코딩앱들에 대해서 보안문제가 나타난다는 것을보고 실제 앱 출시를 위해서 보안쪽에대해서 공부를 진행함![image - 2026-04-12T164703.859.png](/aaa-archive/images/image_-_2026-04-12T164703.859.png)
- [https://lilys.ai/digest/8924886/10165771?s=1&noteVersionId=6654596](https://lilys.ai/digest/8924886/10165771?s=1&noteVersionId=6654596)

영상을 토대로 클로드와 대화를 통해 웹사이트 보안 분석 MD파일 제작
- 보다 나은 작업방식을위해 PRD형식의 MD파일로 제작 요청


- 사용한 MD파일
    
    [YFLOW_Security_Audit_PRD.md](attachment:74d8cdf5-c0a2-4a82-941a-6f8f28200175:YFLOW_Security_Audit_PRD.md)
    


제작한 홈페이지 내의 보안관련 문제 다시한번 점검 진행


### 인사이트

웹사이트 서비스에 supabase나 API연결시 프론트엔드 개발에 노출되어있는 경우가 많아 해킹, 토큰소모량 극대화 등 해외에서 이슈가 생긴다는 것을 확인

- 체크리스트도 클로드에게 요청해서 제작해보았습니다.


- 클로드에서 두개 계정으로 작업 시
    
    - 연결되어있는 supabsae, n8n, github, vercel 계정이다르면 CLI나 MCP가 작동을 하지않습니다.
    - 계정을옮기면서 작업시 기존에 연결해둔 계정의 토큰을 다소모하기전에 20%정도는 토큰을 남겨두고 다른계정에서 작업진행 후 다시 연결되어있는 계정으로 작업을 해야 실제 데이터에 접근및 수정이 가능합니다.
- 만우절 이벤트로 버디기능이 생겼습니다!
    
- /budy
    
![image - 2026-04-12T164659.902.png](/aaa-archive/images/image_-_2026-04-12T164659.902.png)
### 다시 한다면?

클로드코드를 통해서 바이브 코딩으로 웹서비스를 만들수있다는 것이 너무나 재미있지만

실제 서비스 출시를 위해서라면 보안점검을 필수적으로 진행해보는것이 필요해보입니다.

앞으로 서비스 설계시 보안쪽도 초반에 체크리스트 및 기초공부를 통해서 확인후 작업진행할것같습니다.

특히 데이터베이스 연결이나 서버 API연결시 필수적으로 필요해보입니다.