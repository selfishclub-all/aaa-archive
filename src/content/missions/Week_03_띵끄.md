### 결과물

### **과제1. YFLOW 프로젝트 전체 감사 및 개선**

Team 5 (5개 전문 에이전트) 동시 투입으로 전체 프로젝트 감사 후 5개 스프린트로 나눠서 순차 수정 → 자동 커밋 → 깃허브 푸시 → 버셀 배포까지 완료

https://github.com/growththink/flowops-dashboard

### 스프린트 요약

| Sprint | 주제 | 핵심 변경 |
|--------|------|-----------|
| 1 | 보안 기반 | API 키 URL 노출 제거, 미들웨어 활성화, 보안 헤더 추가 |
| 2 | API 안전성 | Zod 입력 검증 6개 라우트, Rate Limiting 7개 라우트, SSRF 방어 4곳 |
| 3 | 안정성 | Error Boundary 2개, Loading/404 UI, alert→toast 9개 |
| 4 | 성능 | select('*') 최적화 24개 파일, 랜딩 SSR 전환, God Component 분리 (2,188줄→186줄) |
| 5 | 접근성+테스트 | Label-Input 연결 16개, ARIA 속성 5개 컴포넌트, Vitest 31개 테스트 |

### **과제2. Obsidian 볼트로 문서화**

감사 결과를 Obsidian 볼트로 정리해서 깃허브에 업로드 완료

- `docs/audit-vault/` 에 9개 문서 + Obsidian 설정
- wikilink 연결로 그래프 뷰에서 스프린트 간 관계 시각화 가능

### 만든 과정 및 삽질

1. `team 5` 명령으로 5개 에이전트(Security, Performance, Code Review, A11y, Architecture) 동시 투입해서 전체 프로젝트 분석
2. 감사 결과를 우선순위별(CRITICAL → HIGH → MEDIUM)로 정리한 후 스프린트 분배
3. 각 스프린트마다: 에이전트 작업 → 빌드 검증 → 테스트 → 커밋 → 푸시 → 버셀 배포
4. **Zod v4 이슈**: `z.record(z.unknown())` 가 v4에서 안 됨 → `z.record(z.string(), z.unknown())` 으로 수정 (3개 파일)
5. **ai-report 타입 불일치**: `z.array(z.unknown())` 가 `unknown[]` 타입 생성 → 전체 캠페인 오브젝트 스키마를 명시적으로 정의해서 해결
6. **God Component 분리**: expenses 페이지 2,188줄을 6개 컴포넌트로 쪼개는 과정에서 상태 공유/이벤트 핸들러 전달이 복잡했음
7. **병렬 에이전트 실행**: Sprint 5에서 접근성(a11y-worker)과 테스트(test-worker) 2개를 동시에 백그라운드로 돌려서 시간 절약

### 인사이트

- **team N 활용법**: `team 5`로 5개 에이전트를 동시에 돌리면 각자 다른 관점(보안/성능/품질/접근성/구조)에서 분석 → 사람이 놓치기 쉬운 부분 발견
    - 예) API 키가 URL 파라미터에 노출되는 건 보안 에이전트가, select('*')는 성능 에이전트가, Label-Input 미연결은 접근성 에이전트가 각각 찾음
- **스프린트 분배의 중요성**: CRITICAL → HIGH → MEDIUM 순서로 하니까 가장 위험한 것부터 해결됨
    - Sprint 1(보안)이 가장 급해서 먼저 처리 → Sprint 5(접근성/테스트)는 상대적으로 여유
- **빌드 검증 필수**: 매 스프린트마다 `next build` 돌려서 TypeScript 에러 0개 확인 후 커밋
    - Zod v4 이슈처럼 빌드 안 돌리면 놓칠 수 있는 타입 에러가 있음
- **테스트 도입 타이밍**: Sprint 2에서 만든 유틸리티(validate-url, validations, rate-limit)를 Sprint 5에서 테스트 → 코드 작성과 테스트를 분리하면 테스트가 더 객관적
- **Obsidian 볼트 활용**: 감사 결과를 wikilink로 연결하면 그래프 뷰에서 전체 구조를 한눈에 볼 수 있음
- **백그라운드 에이전트**: `run_in_background: true`로 독립적인 작업을 병렬 실행하면 대기 시간 대폭 감소

### 다시 한다면?

- 감사 전에 프로젝트의 핵심 비즈니스 로직을 먼저 정리했으면 우선순위 판단이 더 정확했을 것
- E2E 테스트(Playwright)도 Sprint 5에 포함했으면 좋았을 텐데, 시간 관계상 유닛 테스트만 진행
- God Component 분리 시 상태 관리 라이브러리(Zustand 등) 도입을 검토했으면 props drilling이 줄었을 것
- 각 스프린트 작업 전에 브랜치를 분리해서 PR로 관리했으면 리뷰/롤백이 편했을 것
