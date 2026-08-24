const axios = require('axios');
const cheerio = require('cheerio');
const { buildPluginResult } = require('../models/PluginContract');
const { FORMATS, STATUSES, ERROR_TYPES } = require('../models/Constants');

/**
 * Scrapes book availability, price, and metadata from todostuslibros.com
 *
 * @param {string} isbn
 * @returns {Promise<import('../models/PluginContract').PluginContract>}
 */
async function scrapeTodostuslibros(isbn) {
  const url = `https://www.todostuslibros.com/isbn/${isbn}`;

  try {
    const response = await axios.get(url, {
      headers: {
        'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
      },
    });

    const html = response.data;
    const $ = cheerio.load(html);

    // Price Extraction
    let price = null;
    const bodyText = $('body').text();

    // Check multiple potential price containers. Often '.price', '.book-price' or strong
    const priceElements = $('.price, .book-price, strong');
    priceElements.each((_, el) => {
      const text = $(el).text().trim();
      if (text.includes('€') && /\d/.test(text)) {
        // e.g. "19,50 €"
        const match = text.match(/(\d+[,.]\d+)/);
        if (match) {
          price = parseFloat(match[1].replace(',', '.'));
          return false; // Break loop
        }
      }
    });

    // Availability
    const availabilityKeywords = ['Disponible', 'Añadir a la cesta', 'Encontrar en librerías'];
    let isAvailable = price !== null;
    if (!isAvailable) {
      for (const keyword of availabilityKeywords) {
        if (bodyText.includes(keyword)) {
          isAvailable = true;
          break;
        }
      }
    }

    // Metadata
    const metadata = {};

    // Look for <dt> / <dd> metadata list
    $('dt').each((_, el) => {
      const dtText = $(el).text().trim();
      const ddText = $(el).next('dd').text().trim();

      if (dtText.includes('Editorial')) {
        metadata.publisher = ddText;
      } else if (dtText.includes('Col·lecció') || dtText.includes('Colección')) {
        metadata.collection = ddText;
      } else if (dtText.includes('Data publicació') || dtText.includes('Fecha de publicación')) {
        metadata.publishedDate = ddText;
      } else if (dtText.includes('Nº pàgines') || dtText.includes('Nº de páginas')) {
        const pagesMatch = ddText.match(/\d+/);
        if (pagesMatch) {
          metadata.pages = parseInt(pagesMatch[0], 10);
        }
      } else if (dtText.includes('Encuadernación')) {
        metadata.binding = ddText;
      }
    });

    // Synopsis
    const synopsisElement = $('.book-description, .synopsis, .summary, [itemprop="description"]');
    if (synopsisElement.length > 0) {
      const rawText = synopsisElement.first().text();
      metadata.synopsis = rawText
        .replace(/Leer todo|Leer menos/g, '')
        .replace(/\s+/g, ' ')
        .trim();
    }

    // Cover URL
    const imgElement = $('img#book-cover, .book-image img, img[itemprop="image"]').first();
    if (imgElement.length > 0) {
      metadata.coverUrl = imgElement.attr('src');
    }

    if (isAvailable && price === null && Object.keys(metadata).length === 0) {
      return buildPluginResult({
        providerName: 'Todostuslibros',
        error: true,
        errorType: ERROR_TYPES.DOM_CHANGED,
        errorMessage:
          'DOM parse failure. Found availability text but failed to extract price and metadata.',
      });
    }

    return buildPluginResult({
      providerName: 'Todostuslibros',
      isAvailable: isAvailable,
      price: price,
      currency: price !== null ? 'EUR' : null,
      url: url,
      format: FORMATS.PHYSICAL,
      status: isAvailable ? STATUSES.IN_STOCK : STATUSES.OUT_OF_STOCK,
      metadata: Object.keys(metadata).length > 0 ? metadata : undefined,
    });
  } catch (error) {
    if (error.response && error.response.status === 404) {
      return buildPluginResult({
        providerName: 'Todostuslibros',
        error: true,
        errorType: ERROR_TYPES.NOT_FOUND,
        errorMessage: 'Book not found (404)',
      });
    } else {
      const statusCode = error.response ? error.response.status : 'Network/Other';
      return buildPluginResult({
        providerName: 'Todostuslibros',
        error: true,
        errorType: ERROR_TYPES.UNEXPECTED,
        errorMessage: `Unexpected scraping error. Status: ${statusCode}, Error: ${error.message}`,
      });
    }
  }
}

module.exports = { scrapeTodostuslibros };
