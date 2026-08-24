const { initializeApp, getApps } = require('firebase-admin/app');
const { getFirestore } = require('firebase-admin/firestore');

// Initialize a default dummy app for now
if (!getApps().length) {
  initializeApp();
}

const db = getFirestore();

/**
 * Attempts to get the document from the editions collection
 * @param {string} isbn
 * @returns {Promise<import('../models/BookModels').BookEdition|null>}
 */
async function getEdition(isbn) {
  try {
    const docRef = db.collection('editions').doc(isbn);
    const docSnap = await docRef.get();
    if (docSnap.exists) {
      return docSnap.data();
    }
  } catch (error) {
    console.error(`Firestore getEdition error for ISBN ${isbn}:`, error.message);
  }
  return null;
}

/**
 * Saves or overwrites the document in the editions collection
 * @param {string} isbn
 * @param {import('../models/BookModels').BookEdition} bookEditionData
 */
async function saveEdition(isbn, bookEditionData) {
  try {
    const docRef = db.collection('editions').doc(isbn);
    await docRef.set(bookEditionData);
  } catch (error) {
    console.error(`Firestore saveEdition error for ISBN ${isbn}:`, error.message);
  }
}

// Export the db instance so we can wire it up later
module.exports = {
  db,
  getEdition,
  saveEdition,
};
