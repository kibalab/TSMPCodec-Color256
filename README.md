**한국어** | [English](README.en.md) | [日本語](README.ja.md)

# TSMP Codec Color256

TSMP의 Color256 코덱 패키지입니다.

이 패키지는 TSMP Core와 함께 사용되며, `TSMPSetup`의 Codec 탭에서 자동으로 발견되는 Color256 codec handler, decode shader, material, prefab, catalog asset을 제공합니다.

## 설치

VRChat Creator Companion에서 VPM 저장소를 추가합니다.

```text
https://vpm.kiba.red/
```

그 다음 `TSMP Codec Color256` 패키지를 설치합니다.

## 요구 사항

- `com.kibalab.tsmp.core` 0.0.1 이상
- VRChat Worlds SDK 3.9.0 이상

## 사용 방법

1. 씬에 TSMP Core의 `TSMPController.prefab` 또는 동등한 TSMP 구성요소를 배치합니다.
2. `TSMPSetup`의 Codec 탭을 엽니다.
3. `Refresh Codecs`를 누릅니다.
4. `Color256`이 목록에 표시되는지 확인하고 선택합니다.
5. `Apply Setup`을 실행합니다.

Color256은 Luma4보다 높은 색상 용량을 제공하는 코덱입니다. 더 많은 payload를 담고 싶고, 더 높은 시각적/디코드 비용을 감수할 수 있을 때 사용합니다.

## 배포

이 저장소는 태그를 푸시하면 GitHub Actions가 release artifact와 VPM 등록을 수행하도록 구성되어 있습니다.

태그 이름은 `package.json`의 `version`과 같아야 합니다.

예:

```bash
git tag v1.0.0
git push origin v1.0.0
```
