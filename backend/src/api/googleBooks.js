const axios = require('axios');

async function fetchFromGoogleBooks(isbn) {
  try {
    const response = await axios.get(`https://www.googleapis.com/books/v1/volumes?q=isbn:${isbn}`);
    
    if (response.data?.items?.length > 0) {
      return response.data.items[0];
    }
    return null;
  } catch (error) {
    console.error(`Error fetching from Google Books for ISBN ${isbn}:`, error.message);
    return null;
  }
}

module.exports = { fetchFromGoogleBooks };
