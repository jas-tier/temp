# 02 改造・再活用の可否と根拠

- 最終更新: 2026-11-07
- 状態: Phase 1 調査（読み取りのみ）。確度の凡例は [README.md](README.md) を参照。
- この文書は**可否の調査結果**であり、実施の承認ではない。ROM・Bootloader の変更はユーザーの承認が出るまで行わない。

## 1. 結論サマリ

| 項目 | 判定 | 根拠の強さ |
|---|---|---|
| Echo Show 8 第2世代（athena）のアンロック | **報告あり・条件付き**。ユーザーの端末での成功は未確認 | 【報告】GitHub の個人・コミュニティ資料のみ。XDA 本文は未読 |
| ソフトウェアバージョン 36274154116 でのアンロック | **判定不能**。公開資料にバージョンとビルドの対応表がない | 【未確認】 |
| ビルド 7082 でのアンロック | **報告あり**（成功したとする記述が2件） | 【報告】techo5 の記述と shareXDA- の記述 |
| ビルド 7082 でのフル導入（OS 置換まで） | **1件の自己申告のみ**。TECHO5 は「7082 でのフル導入は未報告」と明記 | 【報告】 |
| TWRP | アンロック一式（saiyaku-athena v1.1.x）に同梱されると記載 | 【報告】 |
| LineageOS 18.1 | R0rt1z2 が athena 向けに公開（初回版 v0.1） | 【報告】【確認済】リリースページの本文 |
| Alexa・タイマーの喪失 | **ほぼ確実に失う**。代替手段は未検証 | 【確認済】TECHO5 は「Alexa なし」と明記 |
| 元の Fire OS へ戻せるか | TECHO5 には手順あり。LineageOS 経路は未確認 | 【確認済】TECHO5 の文書 / 【未確認】LineageOS 経路 |
| Nest Hub H1A の標準機能での活用 | **一部可能**。ダッシュボード表示は HTTPS 要件に注意 | 【確認済】Home Assistant 公式ページ |
| Nest Hub H1A の Android 化 | 信頼できる手順を確認できていない。**候補にしない** | 【未確認】 |

## 2. Echo Show 8 第2世代（athena）

### 2-1 資料ごとの内容

| 資料 | 日付 | 内容 | 確度 |
|---|---|---|---|
| kiosk-satellite issue #10（報告者 tjbaker） | 2026-10-26 | A8H3N2 / MT8183。ビルド 7080（Software version 36274153604）で「アンロックには 7080 が必要」と記載。saiyaku-athena v1.1.0 でアンロックし、R0rt1z2 の LineageOS 18.1（`lineage-18.1-20261017-UNOFFICIAL-athena.zip`、GApps なし）を導入。2026-10-21 から常時稼働 | 【報告】1名 |
| amazon-oss/releases `lineage-18.1-athena-v0.1` | 10月17日（年は未表示。ファイル名は 20261017） | 「初回リリースのため不具合があり得る。全機能は検証していない」「**Bootloader unlock version 1.1.0 へ更新が必要。新しい TWRP が含まれ、LineageOS の書き込みに必要**」と警告。SHA-256 を記載。アセット一覧は読み込めず | 【確認済】本文 |
| TECHO5 `docs/install-athena.md` | 日付表示なし | **Fire OS 7080 で検証**。「アンロックは 7082 でも動くが、7082 でのフル導入は未報告」。未知の Fire OS ではインストーラが停止する。画面パネル3種で検証。**`tee1`・`lk`・preloader は決して書かない**（書くと文鎮化） | 【確認済】本文 |
| shareXDA-（EdwilsonPereira） | 2026-10-29 | 工場出荷に近い旧ビルド（PS7551）から OTA で 7082 へ上げ、アンロック→TWRP→LineageOS 18.1 まで到達したと自己申告。リポジトリには exploit 本体は含まれず、配布元の URL もない | 【報告】個人。2 stars |
| XDA Forums の各スレッド | － | **本文は未読**（ボット対策で取得不可） | 【未確認】 |
| Hackaday（2026-01-02） | 2026-01-02 | 第2世代は別 SoC で脆弱性が効かないとした記事 | **古い情報。以降の資料で覆っている** |

資料間の食い違い: issue #10 は「7080 が必要」、TECHO5 と shareXDA- は「7082 でも可」。**7082 は「アンロック可能とする報告がある」止まりで、ユーザーの端末での再現は未確認。**

### 2-2 配布元について

- amazon-oss は GitHub の組織名だが、ページ上では Amazon 公式かどうか判別できなかった。リリースは個人アカウント（R0rt1z2）名義。【未確認】
- したがって、取得するファイルは**出所と SHA-256 を必ず突き合わせる**こと。公式配布物とは扱わない。

### 2-3 改造後の動作（LineageOS 18.1 + Kiosk Satellite、issue #10 の1名の報告）

| 機能 | 結果 |
|---|---|
| 画面・タッチ・HA ダッシュボード・時計スクリーンセーバー | 動作 |
| マイク・ウェイクワード・音声（HA Assist） | 動作 |
| スピーカー（Music Assistant 再生を含む） | 動作 |
| カメラ・モーションセンサー | 動作 |
| 自動輝度・リモート管理・アプリの OTA 更新 | 動作 |
| 不具合・癖 | アプリ再起動後にウェイクワードが一度止まった（HA 側の再読み込みで回復）。パネルに薄いまだら模様（低輝度で目立つ）。ROM v0.1 の癖として、ミュートボタンが電源ボタン兼用、ディープスリープ無効、バッテリー表示が常に 100%。SELinux は permissive |

TECHO5（Alpine Linux、Android なし）の athena 版: 画面、タッチ、前面カメラ、マイク4個、スピーカー、Bluetooth オーディオ、光センサー、Wi-Fi が動作。既知の制限は、光センサー未較正とビーム形成オフ。README では「2台で日常使用」とされる。【確認済】本文

### 2-4 Alexa・タイマー等の喪失評価

| 現在の機能 | 改造後 |
|---|---|
| Alexa（音声操作） | 失う。TECHO5 は「Alexa なし」と明記。LineageOS 18.1（GApps なし）にも Amazon のアプリは入らない【推定】 |
| Alexa タイマー | 失う。代替は TECHO5 のタイマー・アラーム画面（README の記述。**動作は未検証**）。Kiosk Satellite 側は記載を確認できていない |
| フォトフレーム（Amazon Photos） | 失う。代替は HA のダッシュボードやスクリーンセーバー（**未検証**） |
| 公式の保証・サポート | 失う（TECHO5 が「保証が残っていても無効になる」と明記） |

### 2-5 復旧可能性

- TECHO5: TWRP から、事前に取ったバックアップの2パーティション（boot と system）を書き戻して Fire OS に戻る手順がある。「どちらも戻すこと。Fire OS の system は TECHO5 のカーネルでは起動しない」と明記。Fire OS は初回起動時に TWRP を Amazon のリカバリに置き換える。【確認済】
- LineageOS 経路: R0rt1z2 のスレッド（XDA）を読めておらず、公式な戻し手順は**未確認**。shareXDA- には「stock へ戻す手順なし」とある。
- 文鎮化した場合の手段: アンロックに使った MediaTek の下位ツール経由での書き戻し（TECHO5 の記述）。ただし**成功の保証はない**。
- **事前バックアップが前提。** TECHO5 は書き込み前にバックアップを取る設計で、約 4 GB の空きが必要。

### 2-6 リスク

- 文鎮化: ブートローダ関連（preloader・lk・tee）の書き込みで起こる。
- 公開手法のため、Amazon の OTA で塞がれる可能性がある。更新の有無を示す確認済みの情報はない。
- 物理アクセスで root が取れる状態になる（TECHO5「USB ケーブルは root シェル」、issue #10 は SELinux permissive）。
- カメラとマイクがある端末にカスタム OS を載せるため、通信先は自宅の HA に限定する設計にする（TECHO5 は音声を自分の HA のみに送る設計）。

### 2-7 実施前のゲート条件（すべて満たすまで書き込みを行わない）

| ゲート | 内容 | 現状 |
|---|---|---|
| G0 | 本体表示でビルドを再照合（01 の A-3） | 未実施 |
| G1 | saiyaku-athena の手順と対応ビルドを、XDA の原文で確認 | **未実施**（私からは取得不可。本文の貼り付け等が必要） |
| G2 | ユーザーの明示的な承認 | 未取得 |
| G3 | バックアップ先（約 4 GB 以上）の確保 | 未実施 |
| G4 | データ通信対応ケーブルと作業用 PC の準備 | 未実施 |
| G5 | 本体を AC 電源に接続し、作業中は抜かない運用 | 未実施 |
| G6 | 復旧手順の机上確認（`08_recovery_guide.md` の作成） | 未着手 |

### 2-8 参考: Echo Show 5（第2世代・cronos）向けの記事との違い

個人ブログ「Calm tempo」の記事（2026-09-15、同 9-21 更新）は、**Echo Show 5 第2世代（2021、cronos）**を LineageOS 化する手順を紹介している。【確認済】本文

| 項目 | 記事（Echo Show 5 第2世代） | ユーザーの端末（Echo Show 8 第2世代） |
|---|---|---|
| コードネーム | cronos | athena |
| アンロックの道具 | amonet-cronos v2.0.1（fastboot モードで実行）。記事の手順では、音量＋・－とミュートを押しながら電源を入れる | saiyaku-athena（1.1.x）。**別の道具・別の手順** |
| ROM | LineageOS 18.1 for Echo Show 5 (2021) | R0rt1z2 の LineageOS 18.1（athena）など。**機種専用で互換性はない** |
| 本体の条件 | 記事は「バージョンによってできるできないがあるかもしれない」とだけ書き、要件の記載はない | ビルドの条件がある（2-1 を参照） |

- **この記事の手順は、ユーザーの Echo Show 8 には適用しない**（依頼書の「Echo Show 5 向けの改造手順を適用しない」に従う）。道具も ROM も機種専用で、取り違えると文鎮化の恐れがある。
- 記事は「この版から Fire OS のバックアップは不要になったようだ」と書くが、本計画では**バックアップを必須**とする方針を変えない（TECHO5 と shareXDA- の文書もバックアップを前提にしている）。
- 記事の筆者は、Raspberry Pi の値上がりで購入を断念し、Echo Show 5 をスマートホームの「サーバとダッシュボード」に使っているという。何を動かしているかは書かれておらず、**Home Assistant を動かしているとは確認できない**。記事は Echo Show 5 を「ストレージ 8GB・メモリ 1GB」としている。Home Assistant の公式インストールページは、Raspberry Pi で最小 2 GB の RAM を挙げている。

## 3. Google Nest Hub H1A

### 3-1 Home Assistant Cast（ダッシュボード表示）【確認済】公式ページ

- Home Assistant 独自の Cast アプリで、Chromecast 系端末に HA の画面を表示できる。`cast.show_lovelace_view` アクションか、ダッシュボードの Cast エンティティ行から使う。
- **要件**: 「Home Assistant の `https://` でのアクセスが必要。Home Assistant Cloud を使う場合は設定不要。それ以外は `external_url` の設定が必要」。
- 影響: ローカルの http のみの構成では、HA Cast の表示は使えない。**HTTPS で外部から到達できる URL を用意する**（依頼書の「外部公開ポートは原則作らない」と衝突する）か、**Home Assistant Cloud（有料）を使う**かのどちらかになる。Cloud の料金は未取得（公式ページで要確認）。**無料の範囲（2026-11-07 のユーザー指示）では HA Cast は使わない**（03 参照）。
- **タッチ操作の可否は公式ページに記載がない。** 実機検証項目とする。

### 3-2 音声通知・メディア再生【確認済】

- `media_player.play_media` で、HTTP(S) でアクセスできるメディアを再生できる。TTS もこの経路。
- Chromecast は mDNS でのホスト名解決をせず、DHCP の DNS も使わず、Google の公開 DNS（8.8.8.8 / 8.8.4.4）を使う。そのため**メディア URL は IP アドレス直指定か、公開 DNS で解決できる名前**にする。`homeassistant.local` は再生に失敗する。

### 3-3 発見とネットワーク【確認済】

- 自動発見には mDNS が必須。Cast 端末と HA は**同じサブネット**にある必要がある。
- mDNS が動かない場合は、Cast 端末の IP を手動で登録する（Known hosts）。端末に固定 IP を割り当てるのが推奨されている。
- HA を Docker の Container で動かす場合は host ネットワークモードが必須。

### 3-4 標準機能（HA なし）

- 【検索要約】SwitchBot の Hub Mini は、Alexa と Google Home の両方から赤外線家電を音声操作できる。Hub Mini の Matter 対応機では、IR 家電を Matter 経由でホームアプリから操作できるとされる。Hub のモデルは未確認。
- すでに動作実績のある Chrome からの Cast は、ダッシュボードを PC の Chrome タブで開いて Cast する用途に使える可能性がある。タブの Cast は表示のみで、Nest Hub 側のタッチが PC 側の画面に反映されるかは**未検証**。

### 3-5 Android 化

- 信頼できる手順は確認できていない（調査自体も深くは行っていない）。依頼書の方針どおり、**候補にしない**。

## 4. SwitchBot と Home Assistant

### 4-1 SwitchBot Cloud 連携【確認済】公式ページ

- 前提: SwitchBot Hub と、アプリで取得するトークンとシークレット。
- IoT クラス: Cloud Polling（クラウド経由）。
- **IR 家電**: 「Hub 経由で公開される。ON/OFF は「その他」を除くすべての種別、エアコンは温度とモードの変更が可能」。
- 警告: **IR 家電の状態は、HA から送った過去のコマンドからの推定**。リモコンなど他の方法で操作すると実際と食い違う。
- Hub 2 と Hub 3 は「現状はセンサー値の取得のみ。デバイス制御は未対応」と記載。
- API 制限: 1日 10,000 リクエスト。各センサーは 10 分ごとに状態を取得する。
- **Webhook**: ロボット掃除機、水漏れ・開閉・人感・在室センサーの状態更新は、インターネットから HA に到達できる必要がある。`external_url` か Home Assistant Cloud が要る。ローカルのみの構成では、これらの機器は更新を受け取れない。
- 日本限定の機種として、シーリングライト / Ceiling Light Pro と Plug（Wi-Fi 版）が掲載されている。

### 4-2 SwitchBot Bluetooth 連携【確認済】公式ページ

- HA を動かす機器で Bluetooth が使えることが必須。Hub は不要。
- Hub のうち Hub 2・Hub Mini Matter Enabled・Hub 3 は、センサー値の取得のみで制御は未対応。
- **IR 家電の操作は Bluetooth 連携では行えず、Cloud 連携が必要**（上記 4-1）。

### 4-3 影響

- 「赤外線リモコンの大半を SwitchBot で代行」している環境では、HA からの IR 操作は **Cloud 連携のみ**。インターネット接続と SwitchBot クラウドに依存する。依頼書の「可能な限りローカル」とは両立しない部分がある。
- ローカルで完結するのは、Bot・カーテン・センサーなど Bluetooth 対応機器の操作（Bluetooth が使える機器に HA を載せた場合）。

## 5. Home Assistant の稼働環境【確認済】公式ページ

- Windows 向けの公式手順は **VM のみ**: VirtualBox（.vdi）、VMware Workstation（.vmdk）、Hyper-V（.vhdx）。Windows 上の Container 構成の手順は、公式の Windows ページにはない。
- 最小リソース: メモリ 2 GB、2 vCPU。UEFI が必須。
- ネットワーク: ブリッジ接続にする。VirtualBox の手順では Wi-Fi アダプタも選択できる。VMware の手順は有線 Ethernet 接続を前提にしている。
- **Hyper-V は USB に未対応**（公式の注記）。Bluetooth ドングルを VM に渡すなら VirtualBox か VMware。【検索要約】コミュニティでは、ホスト内蔵 Bluetooth の VM への受け渡しがうまくいかない例や、Windows 11 の VBS が USB パススルーを妨げる可能性の指摘がある。
- Raspberry Pi 4 / 5（最小 2 GB）、Home Assistant Green、x86-64 機を、公式が選択肢として挙げている。Home Assistant OS が推奨のインストール方式。
- Container 版では「アプリ」（旧アドオン）が使えない。

## 6. 検証計画（読み取りのみで始められるもの）

| # | 検証項目 | 方法 | 担当 | 状態 |
|---|---|---|---|---|
| V1 | Echo のビルド再照合 | 本体の端末情報を確認 | ユーザー | 未実施 |
| V2 | USB ポート形状 | 背面の撮影 | ユーザー | 未実施 |
| V3 | mDNS が自宅 LAN で動くか | PC でサービス探索ツールを使い、Nest Hub / Echo が見えるか確認 | ユーザー（手順は 06 で提供） | 未実施 |
| V4 | SwitchBot の Hub モデルと機器一覧 | SwitchBot アプリを確認 | ユーザー | 未実施 |
| V5 | PC の常時稼働条件・仮想化の可否 | OS エディションと BIOS 設定の確認 | ユーザー | 未実施 |
| V6 | HA Cast のタッチ操作の可否 | HA 導入後に Nest Hub へ Cast して確認（HTTPS 要件を満たしたとき） | ユーザー・Claude | 未実施 |
| V7 | XDA の saiyaku-athena 手順 | 本文を原文で確認 | 要相談（取得経路が必要） | **未実施** |

## 出典

- Home Assistant Google Cast: https://www.home-assistant.io/integrations/cast/
- Home Assistant SwitchBot Cloud: https://www.home-assistant.io/integrations/switchbot_cloud/
- Home Assistant SwitchBot Bluetooth: https://www.home-assistant.io/integrations/switchbot/
- Home Assistant インストール: https://www.home-assistant.io/installation/
- Home Assistant Windows: https://www.home-assistant.io/installation/windows
- TECHO5: https://github.com/HuskerMinion/techo5
- kiosk-satellite issue #10: https://github.com/jxlarrea/lineageos-echo-kiosk-satellite/issues/10
- amazon-oss リリース: https://github.com/amazon-oss/releases/releases/tag/lineage-18.1-athena-v0.1
- shareXDA-: https://github.com/EdwilsonPereira/shareXDA-
- Hackaday（古い情報）: https://hackaday.com/2026/01/02/jailbreaking-the-amazon-echo-show
- Echo Show 5 第2世代の LineageOS 化の記事（個人ブログ。Echo Show 8 には適用しない）: https://calmtempo.com/2026/09/amazon-echo-show5/
- SwitchBot Hub Mini の連携（検索要約）: https://kaden.watch.impress.co.jp/docs/news/1563921.html
