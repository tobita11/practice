# Facebook Messenger to Email Forwarder

Facebookメッセンジャーからのメッセージをメールアドレスへ自動転送するNode.jsアプリケーションです。

## 機能

- Facebook Messenger Webhookを受信
- 受信したメッセージを指定したメールアドレスに転送
- メッセージテキスト、添付ファイル情報、送信者IDなどを含む
- HTML形式とテキスト形式の両方でメールを送信

## 必要要件

- Node.js（v14以上推奨）
- Facebook Developerアカウント
- Facebookページ（メッセンジャーの受信用）
- SMTPサーバー（Gmail、SendGrid、AWS SESなど）
- 外部からアクセス可能なサーバー（ngrok、Heroku、AWS、GCPなど）

## セットアップ

### 1. リポジトリのクローンとパッケージのインストール

```bash
git clone <repository-url>
cd practice
npm install
```

### 2. 環境変数の設定

`.env.example`を`.env`にコピーして、必要な情報を入力します。

```bash
cp .env.example .env
```

`.env`ファイルを編集：

```env
PORT=3000
VERIFY_TOKEN=任意の検証トークン（ランダムな文字列を生成してください）

# Gmail使用の場合
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_SECURE=false
SMTP_USER=your-email@gmail.com
SMTP_PASS=アプリパスワード

EMAIL_FROM=your-email@gmail.com
EMAIL_TO=destination-email@example.com
```

**Gmail使用時の注意：**
- 2段階認証を有効化してください
- アプリパスワードを生成してください（https://myaccount.google.com/apppasswords）
- 通常のGmailパスワードではなく、アプリパスワードを使用してください

### 3. Facebook Developerの設定

1. [Facebook Developers](https://developers.facebook.com/)にアクセス
2. アプリを作成（ビジネスタイプ: その他）
3. Messengerプロダクトを追加
4. Facebookページを作成または既存のページを選択
5. ページアクセストークンを生成（後で使用する場合に備えて保存）

### 4. サーバーの起動

ローカルで開発する場合：

```bash
npm run dev
```

本番環境：

```bash
npm start
```

### 5. Webhookの設定

開発環境では、ngrokを使用して外部からアクセス可能にします：

```bash
ngrok http 3000
```

Facebook Developerコンソールで：

1. Messenger設定 > Webhooks > "Webhookを設定"をクリック
2. コールバックURL: `https://your-ngrok-url.ngrok.io/webhook`
3. 検証トークン: `.env`ファイルの`VERIFY_TOKEN`と同じ値
4. サブスクリプションフィールド: `messages`, `messaging_postbacks`にチェック
5. "確認して保存"をクリック
6. Facebookページをサブスクライブ

### 6. テスト

1. Facebookページのメッセンジャーにメッセージを送信
2. 指定したメールアドレスにメッセージが転送されることを確認

## 機能の詳細

### 受信できるイベント

- **テキストメッセージ**: メッセージ本文をメールに転送
- **添付ファイル**: 画像、動画、ファイルなどのURL情報を転送
- **配信確認**: ログに記録（メール転送なし）
- **既読確認**: ログに記録（メール転送なし）
- **ポストバック**: ボタンクリックなどのイベント（ログに記録）

### メールの内容

各メールには以下の情報が含まれます：

- 送信者ID
- メッセージID
- 受信日時
- メッセージ本文
- 添付ファイル情報（あれば）

## デプロイ

### Herokuへのデプロイ

```bash
heroku create
heroku config:set VERIFY_TOKEN=your_token
heroku config:set SMTP_HOST=smtp.gmail.com
heroku config:set SMTP_PORT=587
heroku config:set SMTP_SECURE=false
heroku config:set SMTP_USER=your-email@gmail.com
heroku config:set SMTP_PASS=your-app-password
heroku config:set EMAIL_FROM=your-email@gmail.com
heroku config:set EMAIL_TO=destination@example.com
git push heroku main
```

### その他のプラットフォーム

- AWS EC2/ECS
- Google Cloud Platform
- Azure App Service
- DigitalOcean

いずれの場合も、外部からHTTPSでアクセス可能である必要があります。

## トラブルシューティング

### Webhookの検証に失敗する

- `VERIFY_TOKEN`がFacebook Developerコンソールと一致しているか確認
- サーバーが正常に起動しているか確認
- 外部からWebhook URLにアクセスできるか確認

### メールが送信されない

- SMTP設定が正しいか確認
- Gmailの場合、アプリパスワードを使用しているか確認
- サーバーログでエラーメッセージを確認

### メッセージが受信されない

- Facebookページが正しくサブスクライブされているか確認
- Webhookのサブスクリプションフィールドに`messages`が含まれているか確認
- Facebook Developerコンソールでテストイベントを送信してみる

## セキュリティに関する注意

- `.env`ファイルは絶対にGitにコミットしないでください
- 本番環境では環境変数を安全に管理してください
- HTTPSを使用してください（本番環境では必須）
- VERIFY_TOKENは推測されにくい長いランダムな文字列を使用してください

## ライセンス

MIT