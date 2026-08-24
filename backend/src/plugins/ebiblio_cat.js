const cheerio = require('cheerio');
const { buildPluginResult } = require('../models/PluginContract');
const { FORMATS, STATUSES, ERROR_TYPES } = require('../models/Constants.js');
const stealthClient = require('../utils/httpClient.js');

async function scrapeEBiblioCat(isbn, region) {
  if (region?.toLowerCase() !== 'catalunya') return null;

  const providerName = 'eBiblio Catalunya';
  const searchUrl = `https://biblioteca.ebiblio.cat/results?query=${isbn}`;
  let page;
  try {
    const pageResult = await stealthClient.getPage(searchUrl);
    page = pageResult.page;

    const searchHtml = await page.content();

    const articleSelector = '.results-grid article';
    const article = await page.$(articleSelector);
    
    if (!article) {
      return buildPluginResult({
        providerName: 'eBiblio Catalunya',
        error: true,
        errorType: ERROR_TYPES.NOT_FOUND,
        errorMessage: `Book ${isbn} not found`
      });
    }

    // Click the article and wait for navigation
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle0', timeout: 30000 }),
      page.evaluate(el => el.click(), article)
    ]);
    
    const detailUrl = page.url();
    // Wait for the waiting button to disappear
    try {
      await page.waitForFunction(() => !document.querySelector('app-waiting-button'), { timeout: 15000 });
    } catch (e) {}

    const detailHtml = await page.content();

    // Look for application/ld+json script tag inside detailHtml
    const $ = cheerio.load(detailHtml);
    let jsonData = null;
    let foundJson = false;
    $('script[type="application/ld+json"]').each((i, el) => {
      const content = $(el).html();
      if (content && content.includes(isbn)) {
        try {
          jsonData = JSON.parse(content);
          foundJson = true;
          return false; // break loop
        } catch (err) {}
      }
    });

    // 3. Status Extraction
    let status = STATUSES.UNKNOWN;
    let isAvailable = false;
    const buttonTexts = [];
    $('.buttons-wrapper button').each((i, el) => {
      buttonTexts.push($(el).text().trim().toLowerCase());
    });
    const allBtnText = buttonTexts.join(' | ');

    // In English, Odilo uses 'borrow', 'place hold'. In Spanish/Catalan 'prestar', 'llegir', 'reservar'
    if (allBtnText.includes('reserv') || allBtnText.includes('hold')) {
      status = STATUSES.AVAILABLE_SOON;
      isAvailable = false;
    } else if (allBtnText.includes('prestar') || allBtnText.includes('llegir') || allBtnText.includes('borrow') || allBtnText.includes('read')) {
      status = STATUSES.IN_STOCK;
      isAvailable = true;
    }

    if (status === STATUSES.UNKNOWN) {
      return buildPluginResult({
        providerName: 'eBiblio Catalunya',
        error: true,
        errorType: ERROR_TYPES.DOM_CHANGED,
        errorMessage: 'Odilo DOM changed on detail page. Unable to parse status.'
      });
    }

    // 4. Extract Extra Metadata from DOM
    const extraMetadata = {};
    $('app-metadata-info').each((i, el) => {
      const label = $(el).find('.label').text().trim();
      const values = [];
      $(el).find('.value').each((j, valEl) => {
        values.push($(valEl).text().trim());
      });
      if (label && values.length > 0) {
        extraMetadata[label] = values.length === 1 ? values[0] : values;
      }
    });

    // Also extract facets/categories from .record__right__subjects
    const categories = [];
    $('.record__right__subjects a').each((i, el) => {
      categories.push($(el).text().trim());
    });
    
    // Fallbacks from JSON-LD if we didn't find them in DOM
    const title = jsonData ? jsonData.name : $('.record__right__title').text().trim();
    const author = jsonData?.author?.name || extraMetadata['Author'] || $('.author a').first().text().trim() || null;
    const description = jsonData ? jsonData.abstract : $('.description-wrapper').text().trim();
    const coverUrl = jsonData ? jsonData.image : $('opac-record-cover img').attr('src');

    // Make sure we have a title to return a valid Book object
    if (title) {
      return buildPluginResult({
        providerName,
        isAvailable,
        status,
        url: detailUrl,
        format: FORMATS.DIGITAL,
        price: 0,
        currency: 'EUR',
        metadata: {
          title,
          author,
          description,
          coverUrl,
          publisher: extraMetadata['Publisher'],
          collection: extraMetadata['Series'],
          publishedDate: extraMetadata['Publication year'],
          language: extraMetadata['Language'],
          pages: parseInt(extraMetadata['Size']) || undefined,
          categories: categories.length > 0 ? categories : (extraMetadata['Thema'] ? [].concat(extraMetadata['Thema']) : undefined),
          contributors: [].concat(extraMetadata['Additional contributors']).filter(Boolean)
        }
      });
    }

    return buildPluginResult({
      providerName: 'eBiblio Catalunya',
      error: true,
      errorType: ERROR_TYPES.DOM_CHANGED,
      errorMessage: 'Could not extract title from DOM'
    });

  } catch (error) {
    return buildPluginResult({
      providerName: 'eBiblio Catalunya',
      error: true,
      errorType: ERROR_TYPES.UNEXPECTED,
      errorMessage: `Unexpected scraping error. Error: ${error.message}`
    });
  }
}

module.exports = { scrapeEBiblioCat };