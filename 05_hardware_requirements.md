# 05 必要機材

- 最終更新: 2026-11-07
- 状態: Phase 1 調査に基づく一覧。確度の凡例は [README.md](README.md) を参照。
- 方針: 追加購入を前提にしない。**「必須」と書いてあるもの以外は購入不要。** 価格は 03 を参照。

## 1. 推奨構成（構成B: Windows PC + HA の VM）

| 機材 | 要否 | 内容・条件 |
|---|---|---|
| Windows デスクトップ PC（既存） | 必須 | HA の公式 VM 手順の最小リソースは**メモリ 2 GB・2 vCPU**。UEFI が必要。仕様と常時稼働の可否は未確認（質問 Q4） |
| 仮想化ソフト | 必須（無償で可） | VirtualBox、VMware Workstation、Hyper-V のいずれか。USB を VM に渡すなら VirtualBox か VMware（Hyper-V は USB 未対応） |
| ネットワーク | 必須 | VM はブリッジ接続。VMware の手順は有線 Ethernet 前提。VirtualBox は Wi-Fi アダプタも選択可だが、Cast の発見が安定するかは**要検証** |
| Bluetooth ドングル | 任意 | SwitchBot の Bluetooth 連携（Bot・カーテン・センサーなど）を使う場合のみ。IR 家電は Cloud 連携で足りるため不要 |
| SwitchBot Hub | 必須（既存） | Cloud 連携に必要。モデルは未確認（質問 Q5） |
| iPhone・iPad mini（既存） | 任意 | HA の管理と、パネル用途の候補 |
| PC の消費電力計測 | 任意 | 既存の SwitchBot Plug Mini があれば、消費電力を HA で見られる（公式ページに記載）。常時稼働の電気代を把握する用 |
| Home Assistant Cloud | 任意（有料） | Nest Hub へのダッシュボード Cast に必要（HTTPS 要件）。金額は未取得 |

## 2. 構成C に移行する場合（購入が必要）

| 機材 | 内容 |
|---|---|
| Home Assistant Green | 推奨小売価格 $199 / €179。日本での入手性と価格は未確認 |
| または Raspberry Pi 4 / 5（最小 2 GB）+ 電源 + microSD または SSD + ケース | 公式が選択肢として記載。Pi 5 は2025年12月以降3回値上げ。日本の実売価格は未確認 |
| 有線 LAN ケーブル | 公式の手順は Ethernet 接続を前提 |

## 3. Echo Show 8 の改造に必要なもの（Phase 7 で改造を選んだ場合のみ）

実行はゲート G0〜G6 の通過後。**現時点では何も購入しない。**

| 機材・ソフト | 内容 | 根拠 |
|---|---|---|
| データ通信対応の USB ケーブル | 充電専用ケーブルは不可。端子の形状は未確認（質問 Q2） | 【確認済】TECHO5 の文書 |
| 作業用 PC | TECHO5 は Windows・Linux・macOS に対応。Python 3、adb、fastboot、git が必要。shareXDA- は Windows、Python 3、pyserial、keystone-engine、MediaTek の USB ドライバを使う | 【確認済】TECHO5 / 【報告】shareXDA- |
| バックアップ用の空き容量 | 約 4 GB 以上。PC 以外にも保管する | 【確認済】TECHO5 |
| 安定した電源 | 本体を AC に接続し、書き込み中は抜かない | 【確認済】TECHO5 |
| 取得するファイルの出所と SHA-256 | amazon-oss は公式かどうか不明のため、必ず突き合わせる | 【未確認】 |

注意:
- 構成 C の機材とは無関係に、**HA（VM または専用機）は改造の前に動いている必要がある**（改造後の端末は HA に接続して使うため）。
- 「USB ケーブルは root シェル」（TECHO5）。改造後は、物理的に触れる人が root を取れる状態になる。

## 4. Nest Hub（H1A）

追加機材なし。電源とネットワークのみ。固定 IP の割り当て（ルーターの設定）は、mDNS が動かない場合のみ。**既存のネットワーク設定の変更は、ユーザーの承認後に限る。**

## 出典

- Home Assistant Windows: https://www.home-assistant.io/installation/windows
- Home Assistant インストール: https://www.home-assistant.io/installation/
- Home Assistant Green: https://www.home-assistant.io/green/
- Home Assistant SwitchBot Cloud: https://www.home-assistant.io/integrations/switchbot_cloud/
- Home Assistant SwitchBot Bluetooth: https://www.home-assistant.io/integrations/switchbot/
- TECHO5: https://github.com/HuskerMinion/techo5
- shareXDA-: https://github.com/EdwilsonPereira/shareXDA-
