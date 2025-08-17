# Shriken

NostrクライアントのFlutterアプリケーション「Supported Nostr Life」

## 概要

ShrikenはNostrプロトコルを活用したソーシャルメディアアプリです。投稿の共有、暗号化キーの変換、ビットコイン価格チャートの表示など、Nostrエコシステムで必要な機能を提供します。

## 機能一覧

### 🚀 実装済み機能

#### 1. Nostr投稿機能
- テキスト投稿の作成と送信
- 複数のNostrリレーへの同時投稿
- 外部アプリからのテキスト共有に対応
- 暗号化されたプライベートキー（nsec）の管理

**対応リレー:**
- wss://relay-jp.nostr.wirednet.jp/
- wss://yabu.me/
- wss://r.kojira.io/
- wss://relay-jp.shino3.net/

#### 2. キー変換ツール
- npub/nsecキーからHEXへの変換
- リアルタイムでの変換結果表示
- NIP-19形式のキーデコード機能

#### 3. ビットコイン価格チャート
- リアルタイムのビットコイン価格チャート（JPY）
- CoinGecko APIを使用した過去6時間のデータ表示
- 滑らかな曲線グラフでの価格変動表示

#### 4. 設定管理
- プライベートキー（nsec）の暗号化保存
- AES暗号化によるセキュアなキー管理
- SharedPreferencesを使用したローカルストレージ

#### 5. 外部アプリ連携
- 他のアプリからのテキスト共有を受信
- Flutter Sharing Intentプラグインによる統合

### 🛠️ 技術スタック

- **フレームワーク:** Flutter (Dart)
- **Nostrライブラリ:** nostr_core_dart
- **暗号化:** encrypt パッケージ (AES)
- **チャート表示:** fl_chart
- **ローカルストレージ:** shared_preferences
- **HTTP通信:** http パッケージ

### 📱 対応プラットフォーム

- Android
- iOS
- Web
- Windows
- macOS
- Linux

### 🔐 セキュリティ機能

- プライベートキーのAES暗号化
- 固定キーとIVによる暗号化（開発中のため）
- SharedPreferencesでのセキュアなローカル保存

### 🔄 将来の実装予定

- タイムライン表示機能
- フォロー/フォロワー管理
- リプライ機能
- いいね機能
- プロフィール管理
- 画像投稿機能
- DM（ダイレクトメッセージ）機能
- Lightning Network統合
- より高度なセキュリティ機能

## インストール

```bash
git clone <repository-url>
cd shriken
flutter pub get
flutter run
```

## 使用方法

1. **初期設定**: 設定画面でnsecキーを入力
2. **投稿**: "Post to Nostr"で投稿を作成・送信
3. **キー変換**: "Convert To Hex"でキーの変換
4. **価格確認**: "How much sats"でビットコイン価格をチェック

## 開発状況

現在はベータ版で、基本機能の実装が完了しています。今後、Nostrエコシステムでより重要な機能を順次追加していく予定です。

## ライセンス

[ライセンス情報を追加してください]
