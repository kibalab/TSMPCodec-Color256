[한국어](README.ko.md) | [English](README.en.md) | **日本語**

# TSMP Codec Color256

Color256 は制限された色セットを TSMP シンボルとして使用して payload を記録する codec です。Luma4 より高い密度を提供しつつ、高密度 RGB codec よりシンボル判定を明確にしやすい構成です。

## 特徴

- 256-color 系 TSMP シンボル
- Luma4 より高い payload 密度
- standard、robust、refine デコード shader を含む
- 強い色圧縮や後処理がないストリーム経路に適合
- `TSMPSetup` の Codec タブで自動検出

## 要件

- TSMP Core: https://github.com/kibalab/TSMP-Core
- `com.kibalab.tsmp.core` 0.0.1 以降
- VRChat Worlds SDK 3.9.0 以降

## インストール

VRChat Creator Companion で VPM リポジトリを追加します。

```text
https://vpm.kiba.red/
```

その後、`TSMP Core` と `TSMP Codec Color256` をインストールします。

## 使い方

1. Core パッケージの `Packages/com.kibalab.tsmp.core/Samples/TSMPController.prefab` をシーンに配置します。
2. `TSMPSetup` の Codec タブで `Refresh Codecs` を押します。
3. `Color256` を選択します。
4. `Apply Setup` を実行します。

## リリース状態

このパッケージは beta 段階で、`v0.0.x-beta.x` 形式のタグを使用します。

## ライセンス

MIT License. Copyright (c) 2026 KIBA_Labs.
