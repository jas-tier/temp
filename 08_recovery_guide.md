# 08 バックアップ・復旧手順（無料の範囲）

- 最終更新: 2026-11-07
- 状態: **ドラフト。未実施・未検証。** Home Assistant 公式ページ（2026-11-07 に取得）に基づく。復元テストは、まだ行っていない。
- 範囲: Home Assistant の VM と、構成 A（標準連携）への撤退。Echo Show 8 の改造は対象外（改造を承認した場合に、別途この文書を拡張する）。

## 1. 守るもの

| 対象 | 失うと困るもの | 保護の方法 |
|---|---|---|
| Home Assistant の設定・履歴・連携 | 連携設定、ダッシュボード、自動化 | HA のバックアップ（暗号化） |
| 暗号化キー（緊急キット） | **暗号化されたバックアップの復元** | HA の外に保管 |
| オーナーアカウント | 管理者のログイン | 安全な場所に保管（**復旧できない**） |
| 既存の Alexa / Google Home / SwitchBot の設定 | 現在の操作環境 | HA 導入で**変更しない**設計 |

## 2. Home Assistant のバックアップ

出典: Home Assistant 公式の Backup のページ、バックアップ用の緊急キットのページ、OS 関連の共通タスクのページ。

### 2-1 作成

- UI: Settings → System → Backups。自動バックアップの設定ができる。
- コマンドライン（Home Assistant OS）: `ha backups new --name 任意の名前`（作成）、`ha backups list`（一覧とスラッグ名）、`ha backups restore スラッグ名`（復元）。
- アップデートの前は、バックアップを取ってから行う。OS 更新の前提条件として、公式が「**HA が入っている機器の外**にバックアップを置く」ことを求めている。

### 2-2 保管（無料の範囲）

1. バックアップのファイルは、VM と同じ PC の内部だけに置かない。USB メモリ、別ドライブ、すでに契約済みの保管先へコピーする。
2. **緊急キット（暗号化キー）は、HA の外に保管する。** Settings → System → Backups の「Encryption key」カードからダウンロードできる。
3. 暗号化キーを変更したら、**古い緊急キットも残す**。古いバックアップの復元に必要。
4. Home Assistant Cloud（有料）への保存は使わない。

### 2-3 復元

出典: オンボーディングのページ。

- 新しい HA（新しい VM を含む）の初回のようこそ画面で、「Or restore」の下の「Upload backup」から復元できる。
- 暗号化されたバックアップの復元には、**その時点の暗号化キーが必要**。キーがなければ復元できない（公式の明記）。
- **復元テストを、実際に一度行うこと**（別の VM で試すのが安全）。テストするまで、バックアップが使えるとは言い切れない。

## 3. 障害パターンと復帰手順

| 症状 | 確認すること |
|---|---|
| HA の画面が開かない | `http://homeassistant.local/` → `http://homeassistant.local:8123/` → VM の IP アドレス（`http://（IP）:8123`）の順に試す（公式） |
| 初回起動で「Preparing Home Assistant」のまま | 20 分以上かかることがある（公式）。ネットワーク接続を確認して待つ |
| PC の再起動後に HA が上がらない | VM が起動しているか確認する。自動起動の設定は、公式ページに記載がないため**未検証**。手動で VM を起動して、結果を報告する |
| Nest Hub が見つからない | Google Cast の Known hosts に IP を手動登録する。同じサブネットにいるか確認する（公式） |
| 読み上げが再生されない | ローカルの HA の URL が「自動」か確認する。`homeassistant.local` のような名前の URL は、Cast 端末では再生できない（公式） |
| SwitchBot Cloud が応答しない | トークンとシークレットの再入力、API の上限（1 日 10,000 リクエスト）を確認する。IR 家電の状態は推定値である点に注意 |
| VM のディスクが壊れた | 新しい VM を作り、バックアップから復元する（2-3） |

## 4. 構成 A（標準連携）への撤退

HA を使わないことにした場合、または試験を終える場合。

1. HA の最後のバックアップを取り、保管する（あとで戻せるようにする）。
2. VirtualBox で VM を削除する（VM は PC の中で分離されている）。
3. **Alexa と Google Home の既存の連携は、HA とは独立している**ため、変更不要。確認項目 9（06 の 10 章）で、事前に影響がないことを確かめておく。
4. SwitchBot のトークンとシークレットが不要になったら、SwitchBot 側で無効にする方法を公式で確認して実施する（**このセッションでは未調査**）。

## 5. Echo Show 8 について

- 改造しない限り、復旧作業は不要（現状のまま、または標準機能の範囲で使う）。
- 改造を承認した場合の前提（02 のゲート G0〜G6）と、TECHO5 の文書にある要点だけをここに記録する。**実行はしない。原文を確認してから手順書にする。**
  - 書き込み前に、全パーティションの raw バックアップを取る（TECHO5 は約 4 GB の空きを要求）。
  - **`tee1`・`lk`・preloader は書き込まない。**書くと文鎮化する。
  - Fire OS へ戻すには、バックアップした boot と system の 2 パーティションを、TWRP から書き戻す。「Fire OS の system は TECHO5 のカーネルでは起動しない」ため、**両方を戻す**。Fire OS は初回起動時に、TWRP を Amazon のリカバリに置き換える。
  - LineageOS 経路の公式な戻し手順は**未確認**（XDA 未読）。shareXDA- には「stock へ戻す手順なし」と書かれている。
  - 文鎮化した場合は、アンロックに使った MediaTek の下位ツール経由で書き戻す（TECHO5 の記述）。**成功の保証はない。**

## 6. Nest Hub について

- HA 側の対応: Google Cast の連携を削除すれば、HA との接続は外れる。Nest Hub 本体の設定は変わらない。
- 本体のファクトリーリセットの手順は、Google の公式案内を参照する（**このセッションでは未調査**）。

## 出典

- Backup: https://www.home-assistant.io/integrations/backup/
- Backup emergency kit: https://www.home-assistant.io/more-info/backup-emergency-kit/
- 共通タスク（OS）: https://www.home-assistant.io/common-tasks/os/
- オンボーディング: https://www.home-assistant.io/getting-started/onboarding/
- Google Cast: https://www.home-assistant.io/integrations/cast/
- TTS: https://www.home-assistant.io/integrations/tts/
- SwitchBot Cloud: https://www.home-assistant.io/integrations/switchbot_cloud/
- TECHO5: https://github.com/HuskerMinion/techo5
- shareXDA-: https://github.com/EdwilsonPereira/shareXDA-
