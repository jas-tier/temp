# 01 機器台帳・ファームウェア調査

- 最終更新: 2026-11-07
- 状態: Phase 1 調査（読み取りのみ）。確度の凡例は [README.md](README.md) を参照。

## 改訂履歴

| 日付 | 内容 |
|---|---|
| 2026-11-07 | 実装依頼書の誤りを訂正。所有端末は Echo Show 5 ではなく **Echo Show 8 第2世代（2021年・athena）**。Echo Show 5 向けの改造手順は適用しない。 |
| 2026-11-07 | 同日の会話での回答「第2世代は現時点で非対応」を**訂正**。2026年10月以降の資料で、athena のアンロック・LineageOS 18.1・TECHO5 の導入報告を確認した（詳細は 02）。 |

## A. Amazon Echo Show 8 第2世代

### A-1 端末情報

| 項目 | 値 | 検証状態 |
|---|---|---|
| 機種 | Amazon Echo Show 8 第2世代（2021年発売） | 【確認済】販売店ページで ASIN B084TNP2B4 が「第2世代」、2021年6月発売と確認 |
| 型番 | A8H3N2 | 【報告】kiosk-satellite issue #10 と TECHO5 の文書でも athena = A8H3N2 と記載 |
| コードネーム | athena | 【報告】amazon-oss の LineageOS リリース名に「Echo Show 8 (2021) (athena)」 |
| SoC | MediaTek MT8183 | 【報告】商品情報サイト複数と issue #10 の記載。分解資料は未確認 |
| Software version | 36274154116 | ユーザー提供（本体表示値）。公開資料との照合はできていない |
| Fire OS | 7574.1（初回提供時は「7.5.7.4」と表記） | ユーザー報告（2026-11-07 に「FireOS 7574.1」として再提示）。**端末の表示から読み取った値かの確認が残る** |
| ビルド | PS75741 / 7082 | 同上。TECHO5 の文書の表記「PS7574.1.7080N」と同じ形式で、検証された 7080 とは別のビルド（7082） |

### A-2 ビルド表記の整合性

- 【報告】PS75741 と PS7574.1 は同じ表記の書き分け。issue #10 は 7080 のビルドを「PS75741.7080N」、TECHO5 の文書は同じビルドを「PS7574.1.7080N」と書いている。ユーザーが再提示した「7574.1（PS75741/7082）」は、この表記で 7082 に当たる。shareXDA- の文書は「Fire OS 7.5.5.1 (PS7551)」と対応づけており、Fire OS のバージョン表記とも整合する【推定】。Amazon の公式な対応表は見つからなかった。
- 【報告】issue #10 の報告者の端末は、ビルド 7080、Software version 36274153604。
- ユーザーの端末の 36274154116 は、数値としては 7080 の報告値より大きい（差 512）。ただし 7081・7082・それ以降のどれに当たるかは、公開資料からは判別できない。「36274154116」で検索したが、一致する公開資料はなかった。
- ビルドが 7082 であることは、ユーザーの2回の報告（過去の調査の判定と、今回の再提示）で一致している。ただし、**Software version 36274154116 と 7082 の対応は、公開資料では未検証**のまま。端末情報の表示から読み取った値かどうかを確認すること。

### A-3 再照合手順（ユーザー実施・読み取りのみ）

1. 本体の「設定 → デバイスオプション → 端末情報」で、Software version・Fire OS・ビルドの表示を撮影またはメモする。【検索要約】メニュー名は本体の表示に従う。
2. Alexa アプリのデバイス設定でも、ソフトウェアバージョンを確認して突き合わせる。
3. 本体背面の USB ポートの形状（micro-USB か USB-C か）を撮影する。ケーブル選定に使う。【未確認】
4. シリアル番号は記録しない（このリポジトリは公開）。

### A-4 現状の利用と注意

- 現在の用途: フォトフレームとタイマー（依頼書の記載。Echo Show 8 でも同じか要確認）。
- Echo はネットワークに接続していると OTA で更新される。「更新で公開手法が塞がれるか」を示す確認済みの情報は見つかっていない。ただし TECHO5 の文書には、Fire OS に戻った状態について「An update might remove the unlock or TWRP（更新でアンロックや TWRP が消えるかもしれない）」とある。【報告】shareXDA- には「OTA パッケージは**新しいビルドの上には入らない**」という記載がある。【報告】
- 本体をオフラインにするかどうかは、フォトフレームとタイマーが使えなくなるため、ユーザーの判断事項（質問 Q3）。

## B. Google Nest Hub（H1A）

| 項目 | 値 | 検証状態 |
|---|---|---|
| 実機型番 | H1A | ユーザー提供 |
| 機種 | Google Nest Hub（初代） | 【確認済】Google ストア ヘルプ「デバイス情報（韓国のみ）」で H1A =「Google Nest Hub」。第2世代は別行で GUIK2 |
| 画面 | 7インチ LCD タッチスクリーン | 【確認済】同ページの仕様欄 |
| カメラ | 非搭載 | 【確認済】同ページの仕様欄にカメラの記載なし。【検索要約】日本での発売時の報道でも非搭載 |
| マイク | 2個 | 【確認済】同ページ |
| ファームウェア | 32.20260727.103.15100 | ユーザー提供。検証していない |
| Chrome からの Cast / YouTube 再生 | 動作実績あり | ユーザー提供 |
| 購入履歴との相違 | 購入履歴は「Max」表記。実機は H1A | 未解決。実機（H1A）を初代として扱う。金額は公開リポジトリのため記載しない |

補足:
- 上記の Google ページは**韓国向けの情報**で、ページ上の発売日（2020-06-30）は韓国の日付。日本での発売は 2019年6月（【検索要約】報道）。
- 【検索要約】2026年7月23日付の Google Home リリースノートで、第1世代 Nest Hub が Gemini Live の対象に追加された（有料の Google Home Premium が必要）。個別のサポート終了期限は確認できなかった。

## C. SwitchBot（未調査）

- 機種、Hub 構成、Hub のモデル（Hub Mini か、Hub 2 / Hub 3 か）、登録済みの IR 家電は未調査。
- Home Assistant 連携の可否は Hub のモデルと機器種別で変わる（02 の「SwitchBot」節）。**質問 Q5 の回答が必要。**

## D. ネットワーク（未検証）

- NEC Aterm をブリッジモードで使用。上流は賃貸住宅付属のネットワーク。
- DHCP 管理や上流ルーターの詳細は不明。
- **要検証**: 同一セグメントでの機器間通信と mDNS 発見。Google Cast の自動発見は mDNS が必須で、同一サブネットでないと動かない（Home Assistant 公式ページに記載）。

## E. PC・その他の端末

- Windows デスクトップ PC（仕様・常時稼働の可否は未確認）。
- iPhone、iPad mini。
- Raspberry Pi は未所有。

## F. 不足情報（質問）

| # | 質問 | 理由 |
|---|---|---|
| Q1 | 本体の「端末情報」に表示される Software version・Fire OS・ビルドの現在値 | ビルド 7082 の再照合 |
| Q2 | Echo Show 8 の背面 USB ポートの形状 | ケーブルの要否・選定 |
| Q3 | Echo Show 8 を今オフラインにしてよいか（フォトフレーム・タイマーが止まる） | OTA で手法が使えなくなる可能性を避けるため |
| Q4 | Windows PC の OS エディション（Home / Pro）、RAM、常時稼働の可否、有線か Wi-Fi か | VM 稼働の可否 |
| Q5 | SwitchBot の機種一覧と Hub のモデル | 連携方式の決定 |
| Q6 | ~~Home Assistant Cloud（有料）を使ってよいか~~ | **回答済み**: 2026-11-07「無料の範囲で進める」→ 使わない |
| Q7 | 使いたい操作の優先順位（照明、エアコン、テレビ、シーン） | ダッシュボード設計 |

## 出典

- 販売店ページ（第2世代・2021年6月）: https://shop.tsukumo.co.jp/goods/0840080510163/
- AV Watch（第2世代 Echo Show 8）: https://av.watch.impress.co.jp/docs/news/1324007.html
- kiosk-satellite issue #10: https://github.com/jxlarrea/lineageos-echo-kiosk-satellite/issues/10
- TECHO5: https://github.com/HuskerMinion/techo5
- shareXDA-: https://github.com/EdwilsonPereira/shareXDA-
- amazon-oss リリース: https://github.com/amazon-oss/releases/releases/tag/lineage-18.1-athena-v0.1
- Google ストア ヘルプ（デバイス情報・韓国向け）: https://support.google.com/store/answer/6160585?hl=ja
- Gemini Live 対応の報道: https://jetstream.blog/2026/07/24/gemini-live-google-home-mini-nest-hub-support/
