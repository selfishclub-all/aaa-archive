# Week 03 미션 — 비비안

## 미션: 셀피쉬클럽 v4.0 자체 플랫폼 초기 셋업

### 한 줄 요약
Webflow 의존을 끊고 Next.js 기반 자체 플랫폼을 구축하기 위한 프로젝트 초기 셋업 완료.

---

### 작업 내용

#### 1. 프로젝트 기획 브리핑 (BRIEFING.md)
- 셀피쉬클럽 v4.0 리뉴얼 전체 기획을 Claude Code에게 전달하기 위한 브리핑 문서 작성
- 기술 스택, 아키텍처 원칙, 작업 단계(1~3차), 페이지 구조, 보안 체크리스트 정리

#### 2. Next.js 프로젝트 초기화
- Next.js 16 (App Router) + TypeScript + Tailwind CSS v4
- Vercel 배포 대응 구조
- SEO 301 리다이렉트 설정 (`/seminar/`, `/events/` → `/sharing/`)
- 한국어 설정 + OG 메타데이터

#### 3. CLAUDE.md (코딩 컨벤션 문서)
- 아키텍처 원칙: 프론트에서 Supabase 직접 호출 금지, API Routes 경유 필수
- 디렉토리 구조, 코딩 컨벤션, URL 구조 정의
- 기존 Supabase 테이블 보존 규칙

#### 4. DESIGN.md (디자인 시스템)
- 컬러 시스템: Black + Selfish Yellow 포인트
- 타이포: Pretendard(한글) + Geist(영문)
- 컴포넌트 스타일 가이드 (Button, Card, Badge, Input)
- 레이아웃 패턴 (Header, Footer, 히어로, 목록, 상세)
- 브랜드 톤앤매너 규칙

---

### 기술 스택

| 역할 | 선택 |
|---|---|
| 프론트엔드 | Next.js 16 (App Router) |
| 배포 | Vercel |
| DB | Supabase |
| Auth | BetterAuth + 카카오 소셜 로그인 |
| 결제 | 포트원 |
| 알림톡 | 솔라피 |
| AI | Claude API |
| 이미지 | Cloudflare R2 |

---

### GitHub 브랜치
- `vivien/과제제출` — Next.js 프로젝트 전체 코드

---

### 다음 단계
1. 대시보드 v1 구축
2. 카카오 소셜 로그인 + 기존 회원 매핑
3. 마이페이지 CX 개선 (Invalid Date, NaN원 버그 수정)
4. 포트원 결제 재연동
