/**
 * @typedef {Object} ContributorLight
 * @property {string} id
 * @property {string} name
 * @property {string} role
 */

/**
 * @typedef {Object} BookEdition
 * @property {string} isbn - The Primary Key.
 * @property {string} title
 * @property {string|null} description
 * @property {number|null} pageCount
 * @property {string|null} coverUrl
 * @property {string|null} publisher
 * @property {string|null} publishedDate
 * @property {string|null} language
 * @property {number|null} averageRating
 * @property {string[]} moods
 * @property {string[]} tropes
 * @property {ContributorLight[]} contributors
 * @property {string} updatedAt - ISO 8601 date
 */

module.exports = {};
