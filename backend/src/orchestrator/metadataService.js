const { fetchFromGoogleBooks } = require('../api/googleBooks');
const { fetchFromOpenLibrary } = require('../api/openLibrary');

/**
 * Builds a BookEdition object by fetching metadata concurrently from Google Books and Open Library.
 * @param {string} isbn 
 * @returns {Promise<import('../models/BookModels.js').BookEdition>}
 */
async function buildBookEdition(isbn) {
  const [googleResult, olResult] = await Promise.allSettled([
    fetchFromGoogleBooks(isbn),
    fetchFromOpenLibrary(isbn)
  ]);

  const googleData = googleResult.status === 'fulfilled' && googleResult.value ? googleResult.value : null;
  const olData = olResult.status === 'fulfilled' && olResult.value ? olResult.value : null;

  if (!googleData && !olData) {
    const error = new Error("Book metadata not found");
    error.status = 404;
    throw error;
  }

  const volumeInfo = googleData?.volumeInfo || {};

  // Title, description, pageCount, publisher, publishedDate, language
  const title = volumeInfo.title || olData?.title || "Unknown Title";
  const description = volumeInfo.description || (olData?.notes ? (typeof olData.notes === 'string' ? olData.notes : olData.notes.value) : null) || null;
  const pageCount = volumeInfo.pageCount || olData?.number_of_pages || null;
  const publisher = volumeInfo.publisher || (olData?.publishers?.length > 0 ? olData.publishers[0]?.name : null) || null;
  const publishedDate = volumeInfo.publishedDate || olData?.publish_date || null;
  const language = volumeInfo.language || (olData?.languages?.length > 0 ? olData.languages[0]?.name : null) || null;
  const averageRating = volumeInfo.averageRating || null;

  const subtitle = volumeInfo.subtitle || null;
  
  let workId = null;
  if (olData?.works?.[0]?.key) {
    const parts = olData.works[0].key.split('/');
    const olId = parts.find(p => p.startsWith('OL') && p.endsWith('W'));
    if (olId) {
      workId = olId;
    }
  }

  const physicalFormat = olData?.physical_format || null;

  let series = null;
  if (Array.isArray(olData?.series) && olData.series.length > 0) {
    const seriesName = typeof olData.series[0] === 'string' ? olData.series[0] : olData.series[0]?.name;
    if (seriesName) {
      series = {
        name: seriesName,
        position: null
      };
    }
  }

  const categoriesRaw = [];
  if (Array.isArray(volumeInfo.categories)) {
    categoriesRaw.push(...volumeInfo.categories);
  }
  if (Array.isArray(olData?.subjects)) {
    olData.subjects.forEach(sub => {
      if (typeof sub === 'string') categoriesRaw.push(sub);
      else if (sub.name) categoriesRaw.push(sub.name);
    });
  }
  const categories = [...new Set(categoriesRaw)];

  // Cover URL
  let coverUrl = null;
  if (olData?.cover?.large) {
    coverUrl = olData.cover.large;
  } else if (volumeInfo.imageLinks?.thumbnail) {
    // HD trick: replace zoom=1 with zoom=3 and remove &edge=curl
    coverUrl = volumeInfo.imageLinks.thumbnail.replace('zoom=1', 'zoom=3').replace('&edge=curl', '');
  }

  // Contributors
  const contributors = [];
  if (olData?.authors && Array.isArray(olData.authors)) {
    for (const author of olData.authors) {
      let id = author.name; // fallback to name
      
      if (author.url) {
        // e.g. https://openlibrary.org/authors/OL26244A/Frank_Herbert
        const parts = author.url.split('/');
        const olId = parts.find(p => p.startsWith('OL'));
        if (olId) {
          id = olId;
        }
      }
      
      contributors.push({
        id,
        name: author.name,
        role: 'AUTHOR'
      });
    }
  } else if (volumeInfo.authors && Array.isArray(volumeInfo.authors)) {
    for (const authorName of volumeInfo.authors) {
      contributors.push({
        id: authorName, // Google Books doesn't provide IDs, use name
        name: authorName,
        role: 'AUTHOR'
      });
    }
  }

  // Format
  let format = 'UNKNOWN';
  if (googleData?.saleInfo?.isEbook || olData?.physical_format?.toLowerCase().includes('ebook') || olData?.physical_format?.toLowerCase().includes('digital')) {
    format = 'DIGITAL';
  } else if (olData?.physical_format?.toLowerCase().includes('audio')) {
    format = 'AUDIOBOOK';
  } else if (volumeInfo.printType === 'BOOK' || olData?.physical_format) {
    format = 'PHYSICAL';
  }

  return {
    isbn,
    title,
    subtitle,
    description,
    workId,
    format,
    physicalFormat,
    series,
    categories,
    pageCount,
    coverUrl,
    publisher,
    publishedDate,
    language,
    averageRating,
    moods: [],
    tropes: [],
    contributors,
    updatedAt: new Date().toISOString()
  };
}

module.exports = {
  buildBookEdition
};
