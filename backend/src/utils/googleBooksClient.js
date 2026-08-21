const axios = require('axios');

const googleBooksClient = axios.create({ timeout: 3000 });

googleBooksClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const config = error.config;
    if (!config) {
      return Promise.reject(error);
    }

    config.__retryCount = config.__retryCount || 0;
    const maxRetries = config.__shortRetries ? 2 : 6;
    const delays = [1000, 1500, 2000, 2500, 3000, 3500];

    const is503 = error.response?.status === 503;
    const is429 = error.response?.status === 429;
    const isNetworkError = !error.response;

    const shouldRetry = is503 || is429 || isNetworkError;

    if (shouldRetry && config.__retryCount < maxRetries) {
      const delay = delays[config.__retryCount] || 1500;
      config.__retryCount += 1;
      
      const now = new Date().toISOString();
      const statusMsg = error.response?.status ? `status ${error.response.status}` : `message: ${error.message}`;
      console.log(`[${now}] [googleBooksClient] Request failed with ${statusMsg}. Retrying (attempt ${config.__retryCount}/${maxRetries}) in ${delay}ms...`);

      await new Promise(resolve => setTimeout(resolve, delay));
      return googleBooksClient(config);
    }

    return Promise.reject(error);
  }
);

module.exports = googleBooksClient;
