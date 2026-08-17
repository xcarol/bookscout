const { searchGoogleBooks } = require('../api/googleBooks');

async function fastSearch(query) {
  const items = await searchGoogleBooks(query);
  
  return items.map(item => {
    const volumeInfo = item.volumeInfo || {};
    
    // Extract ISBN
    const identifiers = volumeInfo.industryIdentifiers || [];
    const isbn13 = identifiers.find(id => id.type === 'ISBN_13')?.identifier;
    const isbn10 = identifiers.find(id => id.type === 'ISBN_10')?.identifier;
    const isbn = isbn13 || isbn10;
    
    if (!isbn) return null;
    
    // Extract Cover URL with HD trick
    let coverUrl = volumeInfo.imageLinks?.thumbnail || null;
    if (coverUrl) {
      coverUrl = coverUrl.replace('zoom=1', 'zoom=3').replace('&edge=curl', '');
    }
    
    // Extract Published Year
    let publishedYear = null;
    if (volumeInfo.publishedDate && volumeInfo.publishedDate.length >= 4) {
      publishedYear = volumeInfo.publishedDate.substring(0, 4);
    }
    
    return {
      isbn,
      title: volumeInfo.title || '',
      subtitle: volumeInfo.subtitle || null,
      authors: volumeInfo.authors || [],
      publisher: volumeInfo.publisher || null,
      publishedYear,
      pageCount: volumeInfo.pageCount || null,
      categories: volumeInfo.categories || [],
      coverUrl,
      averageRating: volumeInfo.averageRating || null
    };
  }).filter(book => book !== null);
}

module.exports = { fastSearch };
