const axios = require('axios');
const cheerio = require('cheerio');
const { buildPluginResult } = require('../models/PluginContract');
const { FORMATS, STATUSES } = require('../models/Constants');
const { sendTelegramAlert } = require('../services/telegramNotifier');

const EBIBLIO_DOMAINS = {
  'ca': 'biblioteca.ebiblio.cat', // Catalunya
  'gl': 'catalogo.galicia.ebiblio.es', // Galicia
  'default': 'madrid.ebiblio.es' // Fallback (we will expand this later)
};

/**
 * Scrapes book availability from eBiblio (Spanish public digital library network).
 * 
 * @param {string} isbn
 * @param {string} lang 
 * @returns {Promise<import('../models/PluginContract').PluginContract>}
 */
async function scrapeEBiblio(isbn, lang) {
  const domain = EBIBLIO_DOMAINS[lang] || EBIBLIO_DOMAINS['default'];
  const url = `https://${domain}/opac/?q=${isbn}`;

  try {
    const response = await axios.get(url, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
      }
    });

    const html = response.data;
    const $ = cheerio.load(html);
    const bodyText = $('body').text();

    // Verify if ISBN is on the page
    if (!bodyText.includes(isbn)) {
      return buildPluginResult({
        providerName: 'eBiblio',
        isAvailable: false,
        price: null,
        currency: null,
        url: url,
        format: FORMATS.DIGITAL,
        status: STATUSES.UNKNOWN
      });
    }

    // Determine status
    let status = STATUSES.UNKNOWN;
    if (bodyText.includes('Reservar')) {
      status = STATUSES.AVAILABLE_SOON;
    } else if (bodyText.includes('Prestar') || bodyText.includes('Visualitzar') || bodyText.includes('Visualizar') || bodyText.includes('Préstec')) {
      status = STATUSES.IN_STOCK;
    }

    // Sanity check: if we found the ISBN but couldn't parse the status
    if (status === STATUSES.UNKNOWN) {
      sendTelegramAlert('eBiblio', isbn, 'Odilo DOM changed. ISBN found on page but unable to parse status or internal ID.').catch(console.error);
    }

    return buildPluginResult({
      providerName: 'eBiblio',
      isAvailable: status === STATUSES.IN_STOCK || status === STATUSES.AVAILABLE_SOON,
      price: 0,
      currency: 'EUR',
      url: url,
      format: FORMATS.DIGITAL,
      status: status
    });

  } catch (error) {
    return buildPluginResult({
      providerName: 'eBiblio',
      isAvailable: false,
      price: null,
      currency: null,
      url: url,
      format: FORMATS.DIGITAL,
      status: STATUSES.UNKNOWN
    });
  }
}

module.exports = { scrapeEBiblio };
