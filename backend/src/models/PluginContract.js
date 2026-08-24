const { FORMATS, STATUSES } = require('./Constants');

/**
 * @typedef {Object} PluginMetadata
 * @property {string} [synopsis]
 * @property {string} [publisher]
 * @property {string} [collection]
 * @property {string} [publishedDate]
 * @property {string} [coverUrl]
 * @property {number} [pages]
 * @property {string} [binding]
 * @property {string} [language]
 * @property {string[]} [categories]
 * @property {string[]} [contributors]
 */

/**
 * @typedef {Object} PluginContract
 * @property {string} providerName - Name of the provider.
 * @property {boolean} isAvailable - Whether the book is available.
 * @property {number|null} price - Price of the book.
 * @property {string|null} currency - Currency of the price (e.g., 'EUR').
 * @property {string} url - Direct link to buy/borrow.
 * @property {typeof FORMATS[keyof typeof FORMATS]} format - Format of the book.
 * @property {typeof STATUSES[keyof typeof STATUSES]} status - Availability status.
 * @property {PluginMetadata} [metadata] - Additional scraped metadata.
 * @property {boolean} [error] - Whether an error occurred.
 * @property {string} [errorType] - Type of error (e.g. 'NOT_FOUND', 'DOM_CHANGED', 'UNEXPECTED').
 * @property {string} [errorMessage] - Detail of the error.
 */

/**
 * Validates and builds a standardized plugin response object.
 *
 * @param {PluginContract} data
 * @returns {PluginContract}
 */
function buildPluginResult(data) {
  return {
    providerName: data.providerName,
    isAvailable: data.isAvailable,
    price: data.price !== undefined ? data.price : null,
    currency: data.currency !== undefined ? data.currency : null,
    url: data.url,
    format: data.format || FORMATS.UNKNOWN,
    status: data.status || STATUSES.UNKNOWN,
    metadata: data.metadata,
    error: !!data.error,
    errorType: data.errorType || null,
    errorMessage: data.errorMessage || null,
  };
}

module.exports = { buildPluginResult };
