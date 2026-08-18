require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { getBookDetails } = require('./orchestrator/bookService');
const { fastSearch } = require('./orchestrator/searchService');
const { checkAvailability } = require('./orchestrator/availabilityService');

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
});

app.get('/api/search', async (req, res) => {
  try {
    const query = req.query.q;
    if (!query) {
      return res.status(400).json({ error: "Query parameter 'q' is required" });
    }
    const results = await fastSearch(query);
    res.json(results);
  } catch (error) {
    console.error(`Error in fast search for query "${req.query.q}":`, error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.get('/api/books/:isbn', async (req, res) => {
  try {
    const { isbn } = req.params;
    const book = await getBookDetails(isbn);
    res.json(book);
  } catch (error) {
    console.error(`Error fetching book ${req.params.isbn}:`, error);
    res.status(error.status || 500).json({ error: error.message || "Internal server error" });
  }
});

app.get('/api/availability/:isbn', async (req, res) => {
  try {
    const { isbn } = req.params;
    const results = await checkAvailability(isbn);
    res.json(results);
  } catch (error) {
    console.error(`Error fetching availability for ${req.params.isbn}:`, error);
    res.status(500).json({ error: "Internal server error" });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
