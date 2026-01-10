require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const nodemailer = require('nodemailer');

const app = express();
const PORT = process.env.PORT || 3000;

// ミドルウェア設定
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// メール送信設定
const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: process.env.SMTP_SECURE === 'true',
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASS
  }
});

// メール送信関数
async function sendEmail(subject, text, html) {
  try {
    const info = await transporter.sendMail({
      from: process.env.EMAIL_FROM,
      to: process.env.EMAIL_TO,
      subject: subject,
      text: text,
      html: html
    });
    console.log('メール送信成功:', info.messageId);
    return true;
  } catch (error) {
    console.error('メール送信エラー:', error);
    return false;
  }
}

// Webhook検証エンドポイント（GET）
app.get('/webhook', (req, res) => {
  const VERIFY_TOKEN = process.env.VERIFY_TOKEN;

  const mode = req.query['hub.mode'];
  const token = req.query['hub.verify_token'];
  const challenge = req.query['hub.challenge'];

  if (mode && token) {
    if (mode === 'subscribe' && token === VERIFY_TOKEN) {
      console.log('Webhook検証成功');
      res.status(200).send(challenge);
    } else {
      console.log('Webhook検証失敗');
      res.sendStatus(403);
    }
  } else {
    res.sendStatus(400);
  }
});

// Webhookイベント受信エンドポイント（POST）
app.post('/webhook', async (req, res) => {
  const body = req.body;

  if (body.object === 'page') {
    // すべてのエントリーを処理
    for (const entry of body.entry) {
      // メッセージングイベントを処理
      if (entry.messaging) {
        for (const event of entry.messaging) {
          await handleMessagingEvent(event);
        }
      }
    }

    res.status(200).send('EVENT_RECEIVED');
  } else {
    res.sendStatus(404);
  }
});

// メッセージングイベントを処理
async function handleMessagingEvent(event) {
  const senderId = event.sender.id;
  const recipientId = event.recipient.id;
  const timestamp = event.timestamp;

  // メッセージイベント
  if (event.message) {
    const messageId = event.message.mid;
    const messageText = event.message.text;
    const attachments = event.message.attachments;

    console.log('メッセージ受信:', {
      senderId,
      messageId,
      messageText,
      timestamp
    });

    // メールの件名と本文を作成
    let subject = `Facebook Messengerから新しいメッセージ - ${senderId}`;
    let textContent = `送信者ID: ${senderId}\n`;
    textContent += `メッセージID: ${messageId}\n`;
    textContent += `日時: ${new Date(timestamp).toLocaleString('ja-JP')}\n\n`;

    if (messageText) {
      textContent += `メッセージ:\n${messageText}\n`;
    }

    let htmlContent = `
      <h2>Facebook Messengerから新しいメッセージ</h2>
      <p><strong>送信者ID:</strong> ${senderId}</p>
      <p><strong>メッセージID:</strong> ${messageId}</p>
      <p><strong>日時:</strong> ${new Date(timestamp).toLocaleString('ja-JP')}</p>
    `;

    if (messageText) {
      htmlContent += `
        <h3>メッセージ:</h3>
        <p>${messageText.replace(/\n/g, '<br>')}</p>
      `;
    }

    // 添付ファイルの情報を追加
    if (attachments && attachments.length > 0) {
      textContent += `\n添付ファイル数: ${attachments.length}\n`;
      htmlContent += `<h3>添付ファイル:</h3><ul>`;

      for (const attachment of attachments) {
        textContent += `- タイプ: ${attachment.type}\n`;
        htmlContent += `<li>タイプ: ${attachment.type}`;

        if (attachment.payload && attachment.payload.url) {
          textContent += `  URL: ${attachment.payload.url}\n`;
          htmlContent += ` - <a href="${attachment.payload.url}">リンク</a>`;
        }

        htmlContent += `</li>`;
      }

      htmlContent += `</ul>`;
    }

    // メールを送信
    await sendEmail(subject, textContent, htmlContent);
  }

  // 配信確認イベント
  if (event.delivery) {
    console.log('配信確認:', event.delivery);
  }

  // 既読確認イベント
  if (event.read) {
    console.log('既読確認:', event.read);
  }

  // ポストバックイベント
  if (event.postback) {
    console.log('ポストバック:', event.postback);
  }
}

// ヘルスチェックエンドポイント
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'OK' });
});

// ルートエンドポイント
app.get('/', (req, res) => {
  res.send('Facebook Messenger to Email Forwarder is running!');
});

// サーバー起動
app.listen(PORT, () => {
  console.log(`サーバーがポート${PORT}で起動しました`);
  console.log(`Webhook URL: http://localhost:${PORT}/webhook`);
});
