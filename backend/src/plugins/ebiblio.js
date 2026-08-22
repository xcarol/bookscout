const axios = require('axios');
const cheerio = require('cheerio');
const { buildPluginResult } = require('../models/PluginContract');
const { FORMATS, STATUSES } = require('../models/Constants');
const { sendTelegramAlert } = require('../services/telegramNotifier');

const EBIBLIO_DOMAINS = {
  'andalucia': 'andalucia.ebiblio.es',
  'aragon': 'aragon.ebiblio.es',
  'asturias': 'asturias.ebiblio.es',
  'canarias': 'canarias.ebiblio.es',
  'cantabria': 'cantabria.ebiblio.es',
  'castillalamancha': 'castillalamancha.ebiblio.es',
  'castillayleon': 'castillayleon.ebiblio.es',
  'ceuta': 'ceuta.ebiblio.es',
  'comunitatvalenciana': 'comunitatvalenciana.ebiblio.es',
  'extremadura': 'extremadura.ebiblio.es',
  'galicia': 'galicia.ebiblio.es',
  'illesbalears': 'illesbalears.ebiblio.es',
  'larioja': 'larioja.ebiblio.es',
  'madrid': 'madrid.ebiblio.es',
  'melilla': 'melilla.ebiblio.es',
  'murcia': 'murcia.ebiblio.es',
  'navarra': 'navarra.ebiblio.es'
};

/**
 * Scrapes book availability from eBiblio (Spanish public digital library network).
 * 
 * @param {string} isbn
 * @param {string} region 
 * @returns {Promise<import('../models/PluginContract').PluginContract>}
 */
async function scrapeEBiblio(isbn, region) {
  console.log('[INFO] eBiblio: Starting search for ISBN', isbn, 'in region', region);
  if (!region) return null;
  if (region.toLowerCase() === 'catalunya') return null;

  const domain = EBIBLIO_DOMAINS[region.toLowerCase()];
  if (!domain) return null;

  const url = `https://${domain}/resources?q=${isbn}&l=es`;
  try {
    const headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36'
    };

    const searchResponse = await axios.get(url, { headers });
    const $search = cheerio.load(searchResponse.data);
    
    // Find the first result link
    const detailLink = $search('.view-details a[href^="/resources/"]').first().attr('href');
    
    if (!detailLink) {
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

    const detailUrl = `https://${domain}${detailLink}${detailLink.includes('?') ? '&' : '?'}l=es`;
    const detailResponse = await axios.get(detailUrl, { headers });
    const $ = cheerio.load(detailResponse.data);

    // Parse metadata
    const title = $('.header__title h1').text().trim();
    const author = $('[itemprop="author"] [itemprop="name"]').first().text().trim();
    const description = $('[itemprop="description"]').text().replace(/\s+/g, ' ').trim();
    const coverUrl = $('img.cover[itemprop="image"]').first().attr('src');
    
    const publisher = $('[itemprop="publisher"]').first().text().trim();
    const categories = [];
    $('[itemprop="genre"]').each((i, el) => {
      const cat = $(el).text().trim();
      if (cat) categories.push(cat);
    });
    const publishedDate = $('[itemprop="datePublished"]').text().trim();
    const language = $('[itemprop="inLanguage"]').text().trim();
    
    const durationMatch = $('[itemprop="duration"]').attr('content');
    let format = FORMATS.DIGITAL;
    if ($('[itemprop="bookFormat"]').text().toLowerCase().includes('audio') || durationMatch) {
      format = FORMATS.AUDIO;
    }

    // Status
    let status = STATUSES.UNKNOWN;
    const actionText = $('.button-borrow .action, .button-download .action').text().toLowerCase();
    
    if (actionText.includes('reserv')) {
      status = STATUSES.AVAILABLE_SOON;
    } else if (actionText.includes('prestar') || actionText.includes('visuali') || actionText.includes('préstec') || actionText.includes('descargar') || actionText.includes('escuchar')) {
      status = STATUSES.IN_STOCK;
    }

    // Sanity check: if we couldn't parse the status
    if (status === STATUSES.UNKNOWN) {
      sendTelegramAlert('eBiblio', isbn, 'Odilo DOM changed on detail page. Unable to parse status.').catch(console.error);
    }

    return buildPluginResult({
      providerName: 'eBiblio',
      isAvailable: status === STATUSES.IN_STOCK || status === STATUSES.AVAILABLE_SOON,
      price: 0,
      currency: 'EUR',
      url: detailUrl,
      format,
      status,
      metadata: {
        title: title || undefined,
        author: author || undefined,
        description: description || undefined,
        coverUrl: coverUrl || undefined,
        publisher: publisher || undefined,
        categories: categories.length > 0 ? categories : undefined,
        publishedDate: publishedDate || undefined,
        language: language || undefined
      }
    });

  } catch (error) {
    console.error(`[ERROR] eBiblio: Error occurred for region ${region} -`, error.message);
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
