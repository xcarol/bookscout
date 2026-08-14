/**
 * @typedef {Object} ContributorLight
 * @property {string} id
 * @property {string} name
 * @property {string} role
 */

/**
 * @typedef {Object} SeriesInfo
 * @property {string} name
 * @property {string|null} position
 */

/**
 * @typedef {Object} BookEdition
 * @property {string} isbn - The Primary Key.
 * @property {string} title
 * @property {string|null} subtitle
 * @property {string|null} description
 * @property {string|null} workId - The OpenLibrary Work ID.
 * @property {string|null} physicalFormat
 * @property {SeriesInfo|null} series
 * @property {string[]} categories - Array of genres/subjects.
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
