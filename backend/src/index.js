const express = require('express');
const cors = require('cors');
const { getBookDetails } = require('./orchestrator/bookService');

const app = express();
const PORT = process.env.PORT || 8080;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date() });
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

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
