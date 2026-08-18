const { db } = require('../cache/firestore');
const { scrapeTodostuslibros } = require('../plugins/todostuslibros');

async function checkAvailability(isbn) {
  const result = await scrapeTodostuslibros(isbn);
  
  if (result.metadata && Object.keys(result.metadata).length > 0) {
    db.collection('editions').doc(isbn).set(
      { metadata: result.metadata, updatedAt: new Date().toISOString() }, 
      { merge: true }
    ).catch(console.error);
  }
  
  return [result];
}

module.exports = { checkAvailability };
