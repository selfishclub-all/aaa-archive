---
member: 다다
week: 1
date: 2026-03-29
tags:
  - 개념
keywords:
  - Agent Loop
  - Tool Use
  - CLI
---

## 핵심 개념

Agent Loop은 Claude Code의 핵심 실행 구조로, 사용자 입력을 받아 도구를 호출하고 결과를 반환하는 반복 사이클이다.

## 개념 설명

1. **사용자 입력** - 자연어로 작업 요청
2. **의도 분석** - Claude가 요청을 해석
3. **도구 선택/호출** - Read, Write, Edit, Bash 등 적절한 도구 실행
4. **결과 확인** - 도구 실행 결과를 확인하고 다음 단계 결정
5. **반복** - 작업이 완료될 때까지 2-4 반복

## 예시 / 코드
```
사용자: "index.html 파일을 읽어줘"
→ Claude: Read 도구 호출 → 파일 내용 반환
→ 사용자: "타이틀을 변경해줘"
→ Claude: Edit 도구 호출 → 수정 완료
```

## 참고 자료
- Claude Code 공식 문서
