**한국어** | [English](README.en.md) | [日本語](README.ja.md)

# TSMP Codec Color256

Color256은 제한된 색상 집합을 TSMP 심볼로 사용해 payload를 기록하는 코덱입니다. 색상 팔레트 기반 경로를 사용하므로 Luma4보다 높은 밀도를 제공하면서도 RGB 고밀도 코덱보다 디코딩 판정이 명확한 구성을 만들 수 있습니다.

## 특징

- 256-color 계열 TSMP 심볼
- Luma4보다 높은 payload 밀도
- 일반 decode, robust decode, refine decode shader 포함
- 색상 압축이나 후처리가 강하지 않은 송출 경로에 적합
- `TSMPSetup` Codec 탭에서 자동 검색

## 요구 사항

- TSMP Core: https://github.com/kibalab/TSMP-Core
- `com.kibalab.tsmp.core` 0.0.1 이상
- VRChat Worlds SDK 3.9.0 이상

## 설치

VRChat Creator Companion에서 VPM 저장소를 추가합니다.

```text
https://vpm.kiba.red/
```

그 다음 `TSMP Core`와 `TSMP Codec Color256`을 설치합니다.

## 사용 방법

1. Core 패키지의 `Packages/com.kibalab.tsmp.core/Samples/TSMPController.prefab`을 씬에 배치합니다.
2. `TSMPSetup`의 Codec 탭에서 `Refresh Codecs`를 누릅니다.
3. `Color256`을 선택합니다.
4. `Apply Setup`을 실행합니다.

## 배포 상태

현재 beta 단계이며 패키지 버전과 Git 태그는 `v0.0.x-beta.x` 형식을 사용합니다.

## 라이선스

MIT License. Copyright (c) 2026 KIBA_Labs.
