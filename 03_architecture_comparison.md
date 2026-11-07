# 03 構成比較・費用・推奨構成

- 最終更新: 2026-11-07
- 状態: Phase 2（構成比較）。確度の凡例は [README.md](README.md) を参照。
- 前提: 追加購入を前提にしない。ROM や Bootloader の操作は行わない。依頼書の「共通要件」（ローカル動作、外部公開ポートなし、既存の SwitchBot と家庭内ネットワークを壊さない）を評価軸に含める。

## 1. 3構成の比較

### 構成A: 追加購入なし・Home Assistant なし

- Echo Show 8: Alexa アプリ + SwitchBot の Alexa 連携で、本体の標準機能として操作する。タイマーとフォトフレームも残る。
- Nest Hub: Google Home + SwitchBot の Google 連携で操作する。
- SwitchBot Hub の機能（シーン、IR 家電）をそのまま使う。

### 構成B: Windows PC + Home Assistant（VM）

- Windows PC 上の VM（VirtualBox、VMware Workstation、Hyper-V）で Home Assistant OS を動かす。
- SwitchBot は Cloud 連携（IR 家電用）と、必要なら Bluetooth 連携（Bot・カーテン・センサー用）を併用する。
- Nest Hub: 音声通知、標準の Google Home 操作。ダッシュボード表示は HTTPS 要件を満たす場合のみ。
- Echo Show 8: 当面は現状維持。改造は別ゲート（04 の Phase 7）。

### 構成C: Raspberry Pi または Home Assistant Green + Home Assistant

- 専用機で 24 時間稼働させる。それ以外は構成 B と同じ。

| 評価軸 | A | B | C |
|---|---|---|---|
| 追加費用 | なし | なし（任意で HA Cloud、Bluetooth ドングル） | 専用機の購入が必要（下表） |
| 導入の難易度 | 低い | 中（VM の知識が必要） | 中（Green は低い） |
| 統合ダッシュボード・自動化 | 各社アプリに分かれる | HA に統合できる | HA に統合できる |
| ローカル動作 | SwitchBot クラウド・Alexa・Google に依存 | HA 自体はローカル。IR 家電は SwitchBot クラウド依存 | 同左 |
| 常時稼働の信頼性 | 高い（各社クラウド） | **PC の電源・Windows 更新・再起動に左右される** | 高い |
| 外部公開ポート | 不要 | 不要。ただし HA Cast には HTTPS 到達性が要る | 同左 |
| Echo Show 改造の前提を満たすか | 満たさない（HA がない） | 満たす（HA がある） | 満たす |
| 既存設定を壊すリスク | 最小 | 小（VM は分離される） | 小 |
| 撤退のしやすさ | 容易 | 容易（VM を削除するだけ） | 容易 |

## 2. 費用

| 項目 | 金額・状況 | 確度 |
|---|---|---|
| 構成A | 0円 | － |
| 構成B | 追加費用なし。PC の電気代が増える（**実測が必要**。手段は 05 に記載） | － |
| Home Assistant Cloud（任意） | 有料。**金額は未取得**（公式の料金ページで要確認） | 【未確認】 |
| Raspberry Pi 5（4GB）の価格動向 | 米国の公式価格で、2025年12月に $60 → $70、2026年2月に +$15、2026年4月に +$25 と3回値上げ。合計すると約 $110 になる計算（資料に合計の明記はなく、**私の加算**）。メモリ価格が落ち着けば戻す予定と公式が説明。日本の実売価格は見つからなかった | 【検索要約】 |
| Home Assistant Green | 推奨小売価格 $199 / €179（米ドルは税別、ユーロは税込）。日本での販売・価格は**未確認** | 【確認済】公式ページ |
| 電源・ケース・ストレージ（Pi の場合） | **未見積**。日本の販売店で要確認 | 【未確認】 |

日本円の概算は、為替と販売店で大きく変わるため、ここでは出さない。購入を検討する段階で、販売店の実価格を取得して再見積する。

## 3. 推奨構成（1つ）

**構成B を段階導入する。構成A は、土台としてそのまま維持する。**

### 理由

1. **追加購入が要らない。** 依頼書の方針（購入を前提にしない）に合う。
2. **試して撤退できる。** VM は削除するだけで元に戻る。HA が役に立つか確かめてから、専用機の購入を判断できる。Raspberry Pi は 2025年12月から3回値上げされており、焦って買う理由がない。
3. **Echo Show の改造は HA が前提。** HA のない構成 A では、改造しても使い道がない。
4. **構成 A の機能を壊さない。** Alexa と Google の標準連携は、そのまま残す。

### 構成Bの弱点（受け入れる条件）

- PC が止まると HA も止まる。常時稼働が難しいなら、早い段階で構成 C へ移行する（HA のバックアップを復元できる）。
- **Nest Hub のダッシュボード表示には HTTPS が必要。** Home Assistant Cloud を使うか、外部から HTTPS で到達できる URL を作るかになる。後者は「外部公開ポートを作らない」方針に反するため、**Cloud を使わない場合、Nest Hub は音声通知と標準の Google Home 操作が中心になる。**
- IR 家電の操作は SwitchBot クラウド経由で、ローカルでは完結しない。状態も推定値になる。

### 表示端末の割り当て案

| 端末 | 役割 | 状態 |
|---|---|---|
| Nest Hub H1A | 標準の Google Home 操作 + HA からの音声通知。Cloud を採用する場合のみ HA ダッシュボードを Cast | 動作は Phase 5 で検証 |
| Echo Show 8 | 当面は現状維持（Alexa・タイマー・フォトフレーム）。改造は 02 のゲート通過後のみ | 改造は保留 |
| iPad mini（既存） | HA の Companion アプリでタッチ操作用のパネルにする案。**公式資料はこのセッションで未確認**。追加費用なし・低リスクの候補として提示する | 要検討 |

### 却下・保留した案

| 案 | 理由 |
|---|---|
| Echo Show 8 を最初から改造する | 書き込みのリスクが高く、ゲート G1（XDA 原文の確認）が未了。HA がまだないため使い道もない |
| Nest Hub の Android 化 | 信頼できる手順を確認できていない |
| 外部公開 URL の作成 | 依頼書の共通要件に反する |
| Docker Desktop 上の HA Container | 公式の Windows ページに手順がなく、Container 版は「アプリ」も使えない |

## 4. 構成を切り替える条件

| 状況 | 判断 |
|---|---|
| PC を 24 時間つけておけない | 構成 C（専用機）へ移行。購入前に最新価格を再見積 |
| Nest Hub への Cast ダッシュボードが必須 | Home Assistant Cloud の採用をユーザーに諮る |
| HA が役に立たない | 構成 A に戻す（VM を削除） |

## 出典

- Home Assistant インストール: https://www.home-assistant.io/installation/
- Home Assistant Green: https://www.home-assistant.io/green/
- Home Assistant Google Cast: https://www.home-assistant.io/integrations/cast/
- Raspberry Pi の値上げ（2026年4月）: https://gigazine.net/news/20260402-raspberry-pi-price-increases
- Raspberry Pi の値上げ（2026年2月）: https://www.gizmodo.jp/2026/02/raspberry-pi-increase.html
