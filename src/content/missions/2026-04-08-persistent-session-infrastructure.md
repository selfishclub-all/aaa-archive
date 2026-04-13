# 꺼지지 않는 Sullivan — 영속 세션 인프라 구축

## 요약

채널 모드 Sullivan이 재부팅 후에도 자동으로 살아나고, 장애 시 복구되며, CronCreate 스케줄이 만료되지 않는 인프라를 구축했다. tmux + launchd + watchdog + 스케줄 갱신 4개 레이어로 설계했다.

---

## 1. 현상 발견

- Claude Code Channel은 세션 기반이라 터미널을 닫거나 컴퓨터를 재부팅하면 Sullivan이 죽는다
- CronCreate로 등록한 스케줄(아침 브리핑, 점심 체크인 등)은 7일 후 자동 만료된다
- 기존에 다른 Claude Code 채널 프로젝트에서 launchd + tmux 패턴을 이미 쓰고 있었다 (cc alias)
- Sullivan도 동일한 수준의 영속성이 필요했다

## 2. 원인 분석

문제를 3개 레이어로 분해했다:

1. **세션 영속성**: 터미널 독립적으로 claude 프로세스가 계속 실행되어야 한다
2. **장애 복구**: claude가 비정상 종료되면 자동으로 재시작해야 한다
3. **스케줄 영속성**: CronCreate 7일 만료 → 아침 브리핑 cron이 만료되면 재등록을 트리거할 주체가 없다 (순환 의존)

특히 3번이 흥미로운 문제였다. 아침 브리핑 프롬프트에 "스케줄 만료되면 재등록해"를 넣어뒀지만, 그 아침 브리핑 cron 자체가 만료되면 재등록 명령을 보낼 수 없다.

## 3. 개선 방향 논의

### 세션 영속성
기존 cc 패턴(tmux + launchd)을 그대로 차용. 검증된 패턴이므로 새로 설계할 이유 없음.

### 장애 복구
기존 watchdog 패턴 차용 — 5분마다 Telegram pending_update_count를 확인하고, 2회 연속 밀리면 세션 재시작.

### 스케줄 갱신 — 여기서 설계 판단이 필요했다

| 선택지 | 장점 | 단점 |
|--------|------|------|
| 세션 주기적 재시작 (6일마다) | 단순 | 진행 중인 대화 끊김 |
| watchdog에 재등록 로직 추가 | 기존 인프라 활용 | watchdog 책임 비대화 |
| 별도 launchd로 재등록 명령 전송 | 관심사 분리, 대화 안 끊김 | 파일 하나 더 |

→ **별도 launchd 선택.** 5일마다 tmux send-keys로 스케줄 재등록 프롬프트를 세션에 전송. 세션은 그대로 유지되고, Claude가 프롬프트를 받아 CronCreate를 다시 실행한다.

## 4. 구현

### 아키텍처
```
[launchd: com.hminn.sullivan-channel]
  → start.sh
    → tmux 세션 생성 (send-keys 방식)
      → claude --channels ...

[launchd: com.sullivan-channel.watchdog]  (5분 간격)
  → watchdog.sh
    → Telegram API pending 확인
    → 2회 연속 밀림 → 세션 재시작

[launchd: com.sullivan-channel.renew-schedule]  (5일 간격)
  → renew-schedule.sh
    → tmux send-keys로 재등록 명령 전송
```

### 구현 과정의 삽질과 해결

**tmux 세션이 안 뜨는 문제.** 3번의 시행착오가 있었다:

1. **tmux 경로 문제**: plist에 `/usr/bin/tmux`로 썼는데 실제 경로는 `/opt/homebrew/bin/tmux` → exit code 78 (EX_CONFIG)
2. **--continue 플래그**: 이어갈 세션이 없는데 `--continue`를 쓰면 에러 → 제거
3. **tmux 명령어 전달 방식**: `tmux new-session -d -s name "command"` 방식으로 하면 claude가 즉시 종료되면서 세션도 사라짐 → `send-keys` 방식으로 전환 (빈 세션 생성 → 명령어 입력)

최종적으로 `tmux new-session -d` + `tmux send-keys` 조합이 안정적으로 동작했다.

### alias
`.zshrc`에 `alias sc="tmux attach -t sullivan-channel"` 추가. 기존 `cc` 패턴과 동일.

## 5. 검증

| 항목 | 결과 |
|------|------|
| tmux 세션 생성 | `sullivan-channel: 1 windows` 확인 |
| launchd 3개 등록 | launchctl list 전부 확인 |
| 기존 cc 세션과 공존 | 두 세션 동시 실행 확인 |
| sc alias | tmux attach 동작 확인 |
| 텔레그램 실사용 | 캡처/회고 정상 동작 |

## 6. 레슨런

- **순환 의존은 외부 트리거로 끊는다.** CronCreate 만료 → 재등록 cron도 만료 → 재등록 불가. 이런 순환을 시스템 레벨(launchd)의 외부 트리거로 끊는 것이 가장 안정적이다. 자기 자신을 갱신하는 구조는 신뢰하지 않는다.
- **tmux send-keys가 tmux 명령어 직접 실행보다 안정적이다.** `tmux new-session -d -s name "long command"` 방식은 명령어가 즉시 종료되면 세션도 사라진다. 빈 세션을 먼저 만들고 send-keys로 입력하면 셸이 살아있어서 명령어 실패 시에도 세션이 유지된다.
- **기존 패턴을 먼저 확인하고 차용한다.** cc 세팅(launchd + tmux + watchdog)이 이미 검증되어 있었기 때문에, 그 구조를 복사하고 Sullivan 특화 부분(스케줄 갱신)만 추가했다. 검증된 패턴 재사용이 가장 빠르고 안전하다.
- **삽질도 자산이다.** tmux 경로, --continue 플래그, send-keys 전환 — 이 3단계 디버깅 경험이 다음 채널 프로젝트 셋업 시간을 크게 줄여줄 것이다.
