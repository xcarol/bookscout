/**
 * @typedef {Object} AvailabilityProvider
 * @property {string} providerName
 * @property {string} type - e.g., 'LIBRARY', 'BOOKSTORE'
 * @property {boolean} isAvailable
 * @property {string|null} price
 * @property {string} url
 * @property {number} priority
 */

/**
 * @typedef {Object} RegionalAvailability
 * @property {string} id - format: isbn_region
 * @property {string} isbn
 * @property {string} region
 * @property {Date} expiresAt
 * @property {AvailabilityProvider[]} providers
 */

module.exports = {};
