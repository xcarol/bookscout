const { getEdition, saveEdition } = require('../cache/firestore');
const { buildBookEdition } = require('./metadataService');

/**
 * @param {string} isbn
 * @returns {Promise<import('../models/BookModels').BookEdition>}
 */
async function getBookDetails(isbn) {
  const existingBook = await getEdition(isbn);

  if (existingBook) {
    console.log(`[DB HIT] Edition found for ISBN ${isbn}`);
    return existingBook;
  }

  console.log(`[DB MISS] Fetching from external APIs for ISBN ${isbn}...`);

  const newBook = await buildBookEdition(isbn);

  saveEdition(isbn, newBook).catch((err) => {
    console.error(`Failed to save edition for ISBN ${isbn} to Firestore:`, err.message);
  });

  return newBook;
}

module.exports = {
  getBookDetails,
};
