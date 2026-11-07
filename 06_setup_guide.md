# 06 設定・構築手順（無料の範囲）

- 最終更新: 2026-11-07
- 状態: **ドラフト。未実施・未検証。** Home Assistant 公式ページ（2026-11-07 に取得）の内容に基づく。実機で動くことは、まだ確認していない。
- 範囲: **追加購入なし・有料サービスなし**（2026-11-07 のユーザー指示）。対象外: Home Assistant Cloud、Raspberry Pi、Home Assistant Green、Echo Show 8 の改造（改造は 02 のゲートと承認が前提）。
- 実施するのはユーザー。Claude は自宅の PC・機器に直接触れない。結果は報告してもらい、`07_validation_report.md` に記録する。

## 0. 共通ルール

- **認証情報（SwitchBot のトークンとシークレット、HA のパスワード、暗号化キー）は、このリポジトリやチャットに貼らない。** HA の画面にだけ入力する。
- 各ステップの前後で「戻せるか」を確認する。戻せない操作はこの手順書に含めていない。
- 既存の家庭内ネットワーク設定（ルーター等）は変更しない。変更が必要になったら、止めて相談する。
- つまずいたら、そのステップで止めて、表示された内容（認証情報を除く）を報告する。

## 1. 事前確認（Phase 0。読み取りのみ）

結果はチャットで報告する（リポジトリには書かない）。

- [ ] Echo Show 8 の端末情報の表示（Software version、Fire OS、ビルド）
- [ ] Echo Show 8 背面の USB ポートの形状（改造しない場合は不要）
- [ ] SwitchBot アプリの機器一覧と、Hub のモデル（Hub Mini か、Hub 2 / Hub 3 か）
- [ ] Windows PC の OS エディション（Home / Pro）、RAM、常時稼働にできるか、有線か Wi-Fi か
- [ ] PC の BIOS / UEFI で仮想化支援機能が有効か

## 2. 構成A（標準連携）の確認

HA を入れる前の土台。すでに使えていれば、何も変えない。

- Echo Show 8: Alexa アプリと SwitchBot の Alexa 連携で、本体から家電を操作できるか。
- Nest Hub: Google Home と SwitchBot の Google 連携で、本体のタッチと音声で操作できるか。
- 連携の手順は SwitchBot と各社の公式案内に従う（**このセッションでは未調査**）。

## 3. Home Assistant の VM を作る（VirtualBox の場合）

出典: Home Assistant 公式の Windows 向けページ。VirtualBox は、公式がこのページで手順を詳しく示している。無償利用の条件は各社のライセンスで確認すること（**未確認**）。

最小リソースは、メモリ 2 GB、2 vCPU。UEFI が必要。

1. 公式の Windows 向けページ（https://www.home-assistant.io/installation/windows）から、VirtualBox 用のイメージ（.vdi）をダウンロードして、展開する（zip の場合）。
2. VirtualBox で「New（新規）」を選ぶ。
   - Name: `Home Assistant`
   - ISO Image: 空のまま
   - OS: Linux、OS Distribution: Oracle Linux (64-bit)
3. 仮想ハードウェアを設定する。
   - Base Memory: 2048 MB 以上
   - Number of CPUs: 2 以上
   - **Use EFI にチェック**（Home Assistant は UEFI での起動が必須）
4. Finish を選ぶ。
5. 作った VM の Settings → Storage で、空のプレースホルダーのディスクを「Remove attachment」で外し、「Add hard disk」から、展開した .vdi を追加する。
6. Settings → Network で、**Attached to を Bridged Adapter** にする。Name は、インターネットに出るときに使っているアダプタ（Wi-Fi なら Wi-Fi アダプタ、有線なら Ethernet）を選ぶ。
7. VM を起動し、ブートの様子を確認する。
8. 起動後、ブラウザで `http://homeassistant.local/` を開く。開けなければ `http://homeassistant.local:8123/`、それでも開けなければ VM の IP アドレスを使って `http://（IPアドレス）:8123` を開く。

注意:
- VMware Workstation と Hyper-V の手順は、公式ページの該当部分に従う。**Hyper-V は USB に未対応。**
- 【検索要約】Windows 11 では VBS（仮想化ベースのセキュリティ）が、VirtualBox の USB パススルーを妨げるという指摘がある。USB の Bluetooth ドングルを使わない構成では影響しない。
- **PC を再起動したあと VM が自動で起動するかは、公式ページに記載がない。** 検証項目（9章）に入れる。

## 4. 初期設定（オンボーディング）

出典: Home Assistant 公式のオンボーディングのページ。

1. 初回は「Preparing Home Assistant」の画面になる。**20 分以上かかることがある**（ネットワークと PC の性能による）。
2. ようこそ画面で「Create my smart home」を選ぶ。
3. 名前、ユーザー名（小文字・スペースなし）、パスワードを入力して、オーナーアカウントを作る。**オーナーの認証情報は復旧できない。** 安全な場所に保管する。
4. 家の位置を入力する。住所を入れず、地図のマーカーを**おおよその位置**に置く運用でもよい（ホームゾーンの精度に影響する）。
5. 「Help us help you」の画面では、共有する情報を選ぶ。**既定はすべてオフ。** 迷ったらオフのままにする。
6. 最後の画面で、見つかった互換機器が表示されることがある。Finish で完了する。

## 5. 最初のバックアップ（必須）

出典: Home Assistant 公式の Backup のページ、バックアップ用の緊急キットのページ。

1. Settings → System → Backups を開く。
2. 自動バックアップを設定する。最初の手順で、**暗号化キーの「緊急キット」をダウンロード**できる。
3. **緊急キットは、Home Assistant の外（別の場所）に保管する。** キットがないと、暗号化されたバックアップは復元できない。キットを変えたら、古いキットも残す。
4. バックアップのファイルは、**VM と同じ PC の中だけに置かない。** USB メモリや別ドライブ、すでに契約している保管先などへコピーする（有料サービスを新たに契約しない）。
5. Home Assistant Cloud（有料）への保存は使わない。

## 6. Google Cast を追加して Nest Hub を検出する

出典: Home Assistant 公式の Google Cast のページ。**これが mDNS の動作確認も兼ねる。**

1. Settings → Devices & services を開く。
2. Google Cast が「Discovered」として出ていれば、そこから追加する。
3. 出てこなければ、Add Integration から Google Cast を選ぶ。
4. 自動で見つからない場合は、mDNS が通っていない可能性がある。Nest Hub の IP アドレスを、Google Cast のオプションの Known hosts に入れる（IP の固定は、ルーターの設定変更になるため、**必要になったら相談する**）。
5. 結果（見つかった／見つからなかった）を報告する。

## 7. SwitchBot Cloud を追加する

出典: Home Assistant 公式の SwitchBot Cloud のページ。

1. SwitchBot アプリで、「プロフィール → 設定 → 情報 → 開発者向けオプション」を開く。表示されなければ、バージョン番号を 10 回タップする。メニュー名は公式ページの英語表記（Profiles > Preferences > About > Developer Options）の訳で、アプリの表示と違う場合がある。
2. トークンとシークレットを取得する。**これらはチャットやリポジトリに貼らず、HA の入力欄にだけ入力する。**
3. HA で、Settings → Devices & services → Add Integration → SwitchBot Cloud を選び、画面の指示に従う。
4. 追加された機器と、IR 家電（Hub 経由）が表示されるか確認する。

制約（公式ページより）:
- IR 家電の状態は、HA から送った過去のコマンドからの**推定**。リモコンなど他の方法で操作すると、実際と食い違う。
- Hub 2 / Hub 3 は、センサー値の取得のみ。制御は未対応。
- API は 1 日 10,000 リクエストまで。
- ロボット掃除機や人感・開閉センサーの更新（Webhook）は、HA がインターネットから到達できないと届かない。**無料・外部公開なしの範囲では、これらの機器は更新を受け取れない。**

## 8. Nest Hub から音声で通知する（無料）

出典: Home Assistant 公式の TTS と Google Translate text-to-speech のページ。

1. Settings → Devices & services → Add Integration → 「Google Translate text-to-speech」を選ぶ。言語は日本語（`ja`）。
   - この TTS は、**非公式の Google Translate の音声エンジン**を使う。インターネット接続が必要で、コミュニティが保守している。将来使えなくなる可能性がある。
2. Settings → System → Network で、ローカルの HA の URL が**自動**になっていることを確認する（公式が強く推奨）。手動で `homeassistant.local` などを入れると、Cast 端末が再生できない。
3. 新しいスクリプトを作り、アクション「Speak（`tts.speak`）」を選ぶ。ターゲットは、作成した TTS のエンティティ。メディアプレーヤーに、Nest Hub を選ぶ。
4. メッセージに短い文を入れ、スクリプトを実行して、Nest Hub が読み上げるか確認する。

YAML の形（エンティティ ID は**画面で確認して置き換える**。ここに書いた名前は例）:

```yaml
action: tts.speak
target:
  entity_id: tts.google_ja_com        # 例。実際の ID は画面で確認
data:
  media_player_entity_id: media_player.nest_hub   # 例。実際の ID は画面で確認
  message: "テストです"
  language: ja
```

静止画を Nest Hub に表示する方法（`media_player.play_media`、公式の例にある）は、**対話操作はできない表示専用**。必要になったときに別途試す。

## 9. iPad mini から HA を開く（無料）

1. iPad mini のブラウザで、`http://homeassistant.local:8123/`（または VM の IP アドレス）を開く。
2. ログインして、基本画面が表示されるか確認する。
3. 常時表示用のパネルとして使うかどうかは、Phase 6 のダッシュボードができてから決める。専用アプリや画面固定機能は、**このセッションでは未調査**。

## 10. 動作確認チェックリスト（結果は 07 に記録する）

| # | 確認項目 | 結果 |
|---|---|---|
| 1 | HA の VM が起動し、ブラウザで開ける | 未実施 |
| 2 | **PC を再起動したあと、VM が自動で起動し、HA に再び入れる** | 未実施 |
| 3 | 最初のバックアップを作成し、緊急キットを HA の外に保管した | 未実施 |
| 4 | Nest Hub が Google Cast として自動検出された（検出されない場合は手動登録の要否） | 未実施 |
| 5 | Nest Hub が `tts.speak` で読み上げる | 未実施 |
| 6 | SwitchBot Cloud で、照明の ON/OFF ができる | 未実施 |
| 7 | SwitchBot Cloud で、エアコンの温度・モード変更ができる | 未実施 |
| 8 | iPhone / iPad から HA に接続できる | 未実施 |
| 9 | 既存の Alexa / Google Home 経由の操作が、HA 導入後も変わらず使える | 未実施 |
| 10 | 既存の SwitchBot アプリの設定が変わっていない | 未実施 |

## 11. やらないこと

- Home Assistant Cloud の契約、外部公開 URL の作成、ルーターのポート開放。
- Raspberry Pi・Home Assistant Green など専用機の購入。
- Echo Show 8 への書き込み（ROM・Bootloader）。02 のゲート G0〜G6 と、ユーザーの明示的な承認が前提。
- Nest Hub の Android 化。

## 出典

- Windows への導入: https://www.home-assistant.io/installation/windows
- オンボーディング: https://www.home-assistant.io/getting-started/onboarding/
- Backup: https://www.home-assistant.io/integrations/backup/
- Backup emergency kit: https://www.home-assistant.io/more-info/backup-emergency-kit/
- Google Cast: https://www.home-assistant.io/integrations/cast/
- SwitchBot Cloud: https://www.home-assistant.io/integrations/switchbot_cloud/
- TTS: https://www.home-assistant.io/integrations/tts/
- Google Translate text-to-speech: https://www.home-assistant.io/integrations/google_translate/
