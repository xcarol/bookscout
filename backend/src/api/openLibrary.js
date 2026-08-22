const axios = require('axios');

async function fetchFromOpenLibrary(isbn) {
  try {
    const response = await axios.get(`https://openlibrary.org/api/books?bibkeys=ISBN:${isbn}&format=json&jscmd=data`, { timeout: 3000 });
    const key = `ISBN:${isbn}`;
    
    if (response.data && response.data[key]) {
      return response.data[key];
    }
    return null;
  } catch (error) {
    console.error(`Error fetching from Open Library for ISBN ${isbn}:`, error.message);
    return null;
  }
}

module.exports = { fetchFromOpenLibrary };
