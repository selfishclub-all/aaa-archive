## 결과물
### Personal OS 레이어
![selforge-abstract.png](/images/selforge-abstract.png)

- **Personal OS**
    - Karpathy [LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f) + [Graphify](https://github.com/safishamsi/graphify) 리서치 및 적용
    - 3 레이어 아키텍처 설계
        - 사고 레이어
        - 지식 레이어
        - 퍼블리싱 레이어
    - 포트폴리오 웹사이트 설계 및 구현
    - OmC Deep-Interview 통한 요구사항 구체화
        - 방향성 구체화 및 리브랜딩
- **Sullivan Project**
    - Claude-Channel 기능으로 마이그레이션
        - 영속 세션 인프라 구축
            - 재부팅 후에도 Sullivan이 자동으로 살아나는 구조
        - 톤 가이드 개편 및 레거시 정리

## 만든 과정 & 인사이트
- 설리반의 동작 구조를 Claude-Channel 기능으로 마이그레이션
	- 마이그레이션 과정 - [[2026-04-07-channel-migration]]
	- 영속 세션 인프라 구축 - [[2026-04-08-persistent-session-infrastructure]]
		- 재부팅 후에도 Sullivan이 자동으로 살아나는 구조
			- Sullivan에 연결되어 있는 클로드 코드 세션이 계속 유지가 되도록 하기 위함
- [[2026-04-11-selforge-identity]]
- [[2026-04-12-graphify-token-efficiency-test]]