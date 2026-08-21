const axios = require('axios');

async function sendTelegramAlert(scraperName, isbn, reason) {
  const token = process.env.TELEGRAM_BOT_TOKEN;
  const chatId = process.env.TELEGRAM_CHAT_ID;

  const message = `⚠️ [ALERTA BOOKSCOUT]\nScraper: ${scraperName}\nISBN: ${isbn}\nError: ${reason}`;

  if (!token || !chatId) {
    console.warn('Local Alert (Telegram not configured):\n' + message);
    return;
  }

  try {
    await axios.post(`https://api.telegram.org/bot${token}/sendMessage`, {
      chat_id: chatId,
      text: message
    });
  } catch (error) {
    console.error('Failed to send Telegram alert:', error.message);
  }
}

module.exports = { sendTelegramAlert };
