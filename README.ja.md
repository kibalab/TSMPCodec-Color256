[한국어](README.md) | [English](README.en.md) | **日本語**

# TSMP Codec Color256

TSMP の Color256 コーデック パッケージです。

このパッケージは TSMP Core と一緒に使用します。`TSMPSetup` の Codec タブで自動検出される Color256 codec handler、decode shader、material、prefab、catalog asset を提供します。

## インストール

VRChat Creator Companion に VPM リポジトリを追加します。

```text
https://vpm.kiba.red/
```

その後、`TSMP Codec Color256` パッケージをインストールします。

## 要件

- `com.kibalab.tsmp.core` 0.0.1 以降
- VRChat Worlds SDK 3.9.0 以降

## 使い方

1. TSMP Core の `TSMPController.prefab`、または同等の TSMP 構成をシーンに追加します。
2. `TSMPSetup` の Codec タブを開きます。
3. `Refresh Codecs` を押します。
4. `Color256` が一覧に表示されていることを確認して選択します。
5. `Apply Setup` を実行します。

Color256 は Luma4 より高い色容量を提供するコーデックです。より多くの payload を入れたい場合や、より高い表示/デコード負荷を許容できる場合に使用します。

## リリース

このリポジトリは、バージョンタグを push すると GitHub Actions が release artifact を作成し、VPM backend にパッケージを登録するように設定されています。

タグ名は `package.json` の `version` と一致している必要があります。

例:

```bash
git tag v1.0.0
git push origin v1.0.0
```
