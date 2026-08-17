const axios = require('axios');

const API_KEY = process.env.GOOGLE_BOOKS_API_KEY;

if (!API_KEY) {
  console.warn("WARNING: GOOGLE_BOOKS_API_KEY is not defined in environment variables. Falling back to unauthenticated Google Books API requests.");
}

async function searchGoogleBooks(query, maxResults = 20) {
  try {
    let url = `https://www.googleapis.com/books/v1/volumes?q=${encodeURIComponent(query)}&maxResults=${maxResults}`;
    if (API_KEY) {
      url += `&key=${API_KEY}`;
    }
    const response = await axios.get(url, axiosConfig);
    return response.data?.items || [];
  } catch (error) {
    console.error(`Error searching Google Books for query "${query}":`, error.message);
    return [];
  }
}

async function fetchFromGoogleBooks(isbn) {
  try {
    let url = `https://www.googleapis.com/books/v1/volumes?q=isbn:${isbn}`;
    if (API_KEY) {
      url += `&key=${API_KEY}`;
    }
    const response = await axios.get(url, axiosConfig);
    
    if (response.data?.items?.length > 0) {
      return response.data.items[0];
    }
    return null;
  } catch (error) {
    console.error(`Error fetching from Google Books for ISBN ${isbn}:`, error.message);
    return null;
  }
}

module.exports = { fetchFromGoogleBooks, searchGoogleBooks };
