# 09 環境診断（Mac と Windows の比較）

- 最終更新: 2026-11-07
- 状態: **診断スクリプトは作成済・未実行。結果待ち。**
- **Home Assistant の常時稼働先は、この比較が終わるまで確定しない**（ユーザー条件）。

## 1. 現時点で分かっていること（ユーザー提供）

| 端末 | 仕様 | 未確認 |
|---|---|---|
| Mac | MacBook Pro、Apple M3 Pro、RAM 18 GB | macOS のバージョン、ストレージの空き、常時稼働の可否、ネットワーク |
| Windows デスクトップ | Intel Core i7-10700K、RAM 32 GB、RTX 5060 Ti 16 GB、MSI MEG Z490I UNIFY、SSD・HDD | OS のバージョンとエディション、稼働状況、BIOS の仮想化設定、ネットワーク |

- Home Assistant の VM の最小リソースは、メモリ 2 GB・2 vCPU・UEFI（公式）。**スペック上は、どちらも余裕で満たす。**【確認済】
- Mac（Apple silicon）には、公式が専用のイメージ（VirtualBox 用の Apple Silicon 版 .vdi）を用意している。VirtualBox が使えない Mac では UTM も案内されている。【確認済】公式の macOS 向けページ
- Windows には、VirtualBox（.vdi）、VMware Workstation（.vmdk）、Hyper-V（.vhdx）のイメージがある。Hyper-V は USB に未対応。【確認済】公式の Windows 向けページ
- 「蓋を閉じたまま動かせるか」「普段のメイン機か」「消費電力」は**未確認**。

## 2. 診断スクリプト

### 2-1 方針

- **読み取り専用**。設定変更、ファイル書き込み、sudo、外部への送信はしない。
- **出力しない情報**: シリアル番号、UUID、ホスト名、ユーザー名、MAC アドレス、IP アドレス、SSID。
- 結果は画面に出るだけ。保存するときは、実行時にリダイレクトする。
- **このリポジトリは公開**です。結果をリポジトリに書かず、チャットで報告してください。貼る前に、個人情報が含まれていないか目で確認してください。

### 2-2 実行方法

**Mac**（ターミナルで）:

```
bash diag_mac.sh
```

保存したい場合は `bash diag_mac.sh > ~/Desktop/diag_mac.txt`。ファイルは [tools/diag_mac.sh](tools/diag_mac.sh)。

**Windows**（PowerShell で）:

```
powershell -NoProfile -ExecutionPolicy Bypass -File .\diag_windows.ps1
```

`-ExecutionPolicy Bypass` は、この実行1回だけに効く。スクリプトの中身は先に読んでから実行してよい。ファイルは [tools/diag_windows.ps1](tools/diag_windows.ps1)。Hyper-V の状態は、管理者権限でないと取得できないことがある（その場合は「取得できない」と出るだけで、止まらない）。

### 2-3 未テストについて

- 作者（Claude）の環境は Linux のため、**macOS と Windows 上での実行は未確認**。
- Mac 用: Linux 上で、構文チェックと、取得できない場合の動作（止まらずに進むか）を確認した。ネットワークの対応づけ、バッテリー ID と端末 ID の伏せ字は、模擬データで確認した。
- Windows 用: PowerShell が使えず、**構文チェックもできていない**。エラーが出たら、その項目を教えてほしい。

### 2-4 実行するコマンドと目的（Mac）

| 項目 | コマンド | 目的 | 変更 |
|---|---|---|---|
| OS | `sw_vers` | macOS のバージョン | なし |
| ハードウェア | `uname -m`、`sysctl`（CPU 名・コア数・RAM）、`system_profiler SPHardwareDataType`（機種名・チップ・メモリの行だけ） | チップと RAM | なし |
| 仮想化 | `sysctl kern.hv_support` | Hypervisor が使えるか | なし |
| ストレージ | `df -h` | 空き容量 | なし |
| 電源・スリープ | `pmset -g batt`、`pmset -g custom` | 常時稼働に関わる設定 | なし |
| 稼働時間 | `uptime` | 再起動の頻度の目安 | なし |
| ネットワーク | `route -n get default`、`networksetup -listallhardwareports`（名前の行だけ）、`scutil --nc list`（接続数だけ） | 有線か無線か、VPN の有無 | なし |
| ファイアウォール | `socketfilterfw --getglobalstate` | 状態の確認 | なし |
| mDNS | `dns-sd -B _googlecast._tcp local.`（5 秒間、受信するだけ） | Nest Hub が見えるか | なし |
| ソフト | `ls /Applications`（名前で絞る）、`VBoxManage --version`、`command -v brew` | 仮想化ソフトの有無 | なし |

### 2-5 実行するコマンドと目的（Windows）

| 項目 | コマンド | 目的 | 変更 |
|---|---|---|---|
| OS | `Get-CimInstance Win32_OperatingSystem` | エディション（Home / Pro）、バージョン、稼働日数 | なし |
| CPU・RAM・GPU | `Win32_Processor`、`Win32_ComputerSystem`、`Win32_VideoController` | 仕様と、BIOS の仮想化設定（`VirtualizationFirmwareEnabled`） | なし |
| 仮想化 | `Win32_DeviceGuard`、`Get-WindowsOptionalFeature` | VBS と Hyper-V の状態 | なし |
| ディスク | `Get-Volume` | 固定ボリュームの空き（ラベルは出さない） | なし |
| ネットワーク | `Get-NetRoute`、`Get-NetAdapter`（MAC は出さない） | 有線か無線か | なし |
| 電源・スリープ | `powercfg /getactivescheme`、`powercfg /query ... STANDBYIDLE`、`powercfg /a` | 常時稼働に関わる設定 | なし |
| 再起動待ち・ソフト | レジストリの読み取り | Windows Update の再起動待ち、仮想化ソフトの有無 | なし |

## 3. スクリプトでは分からないこと（手動で教えてほしい）

| 端末 | 質問 |
|---|---|
| Mac | 普段のメイン機か。持ち出すか。蓋を閉じたまま、または外部ディスプレイ接続で動かす運用にできるか。電源に常時接続できるか |
| Windows | 普段どのくらい電源が入っているか。ゲームや AI 用途で、止められない時間帯があるか。自動更新による再起動を許容できるか。有線 LAN か |
| 共通 | 消費電力の実測が可能か（SwitchBot の Plug Mini 等で測れる。持っていない場合、**追加購入は、必要性を検証してから判断する**） |

## 4. 比較の枠組み（診断後に埋める）

| 評価軸 | Mac | Windows | 判定 |
|---|---|---|---|
| 常時稼働（スリープ・蓋・再起動） | 診断待ち。ノート型なので、蓋と電源の運用が鍵【推定】 | 診断待ち。デスクトップだが、更新による再起動がある【推定】 | 未確定 |
| 消費電力 | 実測待ち | 実測待ち。高性能な GPU を載せた構成なので、待機時の電力は実測が必要【推定】 | 未確定 |
| ネットワーク（有線か無線か、mDNS） | 診断待ち | 診断待ち（mDNS は HA 導入後に Cast の検出で確認） | 未確定 |
| 仮想化の対応 | Apple silicon 用イメージあり【確認済】。macOS のバージョンが VirtualBox の対応範囲かは**未確認** | VirtualBox・VMware・Hyper-V のイメージあり【確認済】。BIOS の仮想化設定と VBS の影響は診断待ち | 未確定 |
| 他用途との競合 | メイン機なら競合する | 高負荷の用途と競合し得る | 未確定 |
| 障害時の影響 | VM が止まると、HA の自動化・通知が止まる（共通） | 同左 | － |
| 追加費用 | 0 円 | 0 円 | － |
| Echo Show 改造の作業 PC として | インストール工程は可。アンロック工程は**未確認**（02 の 2-8） | アンロック工程の資料は Windows が中心 | 別問題として扱う |

## 5. 判断の手順

1. ユーザーが、2 台の診断結果をチャットで報告する。
2. Claude が、この表を埋め、**暫定の比較結果を提出する**。
3. ユーザーが稼働先を確定する（確定するまで、HA の VM は作らない）。
4. 確定後に、06 の手順書で試験導入に進む。

## 6. 実施記録（変更内容）

| 区分 | 内容 |
|---|---|
| 家庭内の機器・PC・ネットワークへの変更 | **なし**（このセッションからは触れない） |
| リポジトリ | 診断スクリプト 2 本と、本書を追加（`tools/` と `09`） |
| クラウド側の環境 | 環境「temp」を作成し、許可ホストを追加した（home-assistant.io、www.home-assistant.io、xdaforums.com、support.google.com、calmtempo.com） |
| Mac への接続 | 試みた。共有されたフォルダが 0 件で、接続できなかった（`list_computer_folders` の結果） |

Mac に直接つなぐ経路（Claude デスクトップアプリの Remote Control でフォルダを共有する方法）もある。ただし、**今回は不要**。スクリプトを手動で実行してもらう方が、実行内容を目で確認できる。
