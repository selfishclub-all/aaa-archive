# iCloud EDEADLK 근본 해결 — 로컬 저장소 + Git 동기화 전환

## 요약

Sullivan 봇이 iCloud Drive 파일에 접근할 때 영구적 EDEADLK(errno 11)가 발생하여 캡처 읽기 실패 + 브리핑 저장 크래시가 반복됐다. 재시도, subprocess fallback 등 3차례 우회 시도가 모두 실패한 뒤, iCloud를 critical path에서 완전히 제거하고 로컬 저장소 + Git 동기화 아키텍처로 전환하여 해결했다.

---

## 1. 현상 발견

- 저녁 회고에서 "오늘 포착된 것 없음" 출력. 실제로는 4개의 캡처 파일이 존재.
- `/morning` 명령 시 `OSError: [Errno 11] Resource deadlock avoided`로 크래시.
- 에러 로그에서 확인: 캡처 파일 4개 전부 EDEADLK로 8회 재시도 소진 후 스킵 → `read_captures()` 빈 문자열 반환.
- 브리핑 저장(`save_briefing`)에서도 동일 에러로 `_write_file()` 크래시.
- 터미널에서 동일한 Python으로 같은 파일을 읽으면 정상. **launchd로 실행된 봇 프로세스에서만 발생.**

## 2. 원인 분석

**원인 체인:**
- Sullivan 봇은 launchd LaunchAgent로 실행됨 (맥북 켜질 때 자동 시작, 장시간 상주)
- Obsidian vault가 iCloud Drive(`iCloud~md~obsidian` 앱 컨테이너) 안에 위치
- iCloud 데몬(`bird`)이 파일 동기화 중 POSIX advisory lock을 걸음
- 장시간 실행되는 launchd 프로세스에서 `open()` 시스템콜이 이 lock과 충돌 → EDEADLK
- 이 잠금은 **14시간 이상 지속** (3/31 20:13 저장 → 4/1 10:11에도 여전히 잠김)

**왜 기존 시스템에서 못 잡았나:**
- 기존 재시도 로직(8회, 최대 40초/파일)은 "일시적 잠금"을 전제로 설계됨
- EDEADLK가 영구적이라는 것은 장시간 운영 후에야 드러나는 현상
- 터미널 테스트에서는 재현 불가 (인터랙티브 세션은 iCloud 데몬과 다르게 동작)

## 3. 개선 방향 논의

### 시도 1: 재시도 횟수 조정 (8→3)
- 판단: 영구적 잠금이면 몇 번을 재시도해도 동일. 실패 시간만 단축될 뿐.
- 결과: **실패** — 문제 미해결.

### 시도 2: subprocess fallback (cat/cp)
- 가설: "Python open()의 fd 테이블 문제이므로 별도 프로세스(cat)면 우회 가능"
- 터미널에서 테스트: 성공 → 가설 유효해 보임
- 실제 배포 후: **실패** — launchd 컨텍스트에서는 subprocess도 동일하게 EDEADLK. 파일시스템 레벨 잠금이었음.

### 시도 3 (최종): 아키텍처 전환
- **판단 근거**: 3회 연속 우회 실패 → "iCloud를 통한 파일 접근" 자체가 잘못된 아키텍처.
- **결정**: iCloud를 critical path에서 완전 제거. 로컬 파일시스템을 primary 저장소로, Git을 동기화 수단으로.

### 대안으로 고려했지만 기각한 것들:
- **symlink (iCloud → 로컬)**: iCloud가 symlink을 안정적으로 처리하지 않는 알려진 이슈.
- **osascript로 GUI 세션 경유 파일 복사**: 해키하고 불안정.
- **Obsidian vault를 iCloud 밖으로 이동**: iOS 동기화가 깨짐 → Git 플러그인으로 대체 가능하다는 판단 후 수용.

## 4. 구현

**핵심 변경: 저장소 이원화 제거, 로컬 단일화**

- `config.py`: `VAULT`(iCloud 경로), `ICLOUD_SULLIVAN_ROOT` 완전 제거. `SULLIVAN_ROOT`를 로컬 경로(`/Users/hminn/Helen/sullivan`)로 단일화.
- `obsidian.py`: subprocess/retry/shutil 코드 전부 제거. 단순한 `open()` 읽기/쓰기로 축소. `_write_file()` 후 `_git_sync()`로 non-blocking commit+push.
- `find_related_notes()`: iCloud vault 탐색 → Sullivan 로컬 데이터 내 탐색으로 수정. (관련 노트 = Sullivan이 저장한 캡처/회고 내에서의 연결)
- GitHub 프라이빗 레포(`sullivan-notes`) 생성, 기존 데이터 마이그레이션.
- iOS Obsidian Git 플러그인으로 pull-only 동기화 구성.

**설계 의도:**
- 봇의 I/O가 외부 서비스(iCloud)에 절대 의존하지 않도록. 로컬 파일시스템은 실패하지 않음.
- 동기화 실패가 봇 동작에 영향을 주지 않도록 (Git push는 best-effort, non-blocking).
- 코드 복잡도 대폭 감소 (retry loop, subprocess fallback, iCloud mirror 모두 제거).

## 5. 검증

| 항목 | Before | After |
|---|---|---|
| `/morning` 실행 | OSError 크래시 | 정상 완료, 캡처 내용 반영 |
| `read_captures('2026-03-31')` | 빈 문자열 (EDEADLK 전부 실패) | 9082 bytes, 4개 캡처 정상 |
| `save_briefing()` | OSError 크래시 | 로컬 저장 성공 + Git push |
| 에러 로그 | EDEADLK WARNING 수십 건 | WARNING 0건 |
| obsidian.py 복잡도 | 92행 (retry/subprocess/mirror) | 30행 (단순 read/write + git sync) |
| 단위 테스트 | 48개 통과 | 48개 통과 |

## 6. 레슨런

- **우회가 3번 실패하면 아키텍처를 의심하라.** 재시도 횟수 조정, subprocess fallback, 에러 핸들링 개선 — 전부 "iCloud 접근이 작동한다"는 전제 위에 있었다. 전제 자체가 틀렸으면 그 위의 모든 최적화는 무의미하다.

- **터미널에서 된다고 프로덕션에서 되는 게 아니다.** 인터랙티브 셸과 launchd 데몬은 iCloud 데몬과의 관계가 다르다. 환경 차이를 과소평가하면 "내 컴퓨터에서는 되는데"의 함정에 빠진다.

- **외부 서비스를 critical path에 두지 마라.** iCloud, 클라우드 스토리지, 외부 API 등은 언제든 실패할 수 있다. 봇의 핵심 기능(읽기/쓰기)이 외부 서비스 가용성에 의존하면, 그 서비스의 장애가 곧 내 서비스의 장애가 된다. 로컬 우선 + 비동기 동기화가 올바른 패턴.

- **복잡한 fallback보다 단순한 아키텍처가 낫다.** retry loop + subprocess fallback + iCloud mirror를 합치면 코드가 92행이었다. 로컬 단일화 후 30행. 단순한 코드는 디버깅도 쉽고, 새로운 종류의 실패가 발생할 여지도 적다.
