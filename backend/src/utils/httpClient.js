const puppeteer = require('puppeteer-extra');
const StealthPlugin = require('puppeteer-extra-plugin-stealth');

puppeteer.use(StealthPlugin());

class StealthClient {
  constructor() {
    this.browserPromise = null;
  }

  async getBrowser() {
    if (!this.browserPromise) {
      this.browserPromise = puppeteer.launch({
        headless: 'new',
        args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
      });
    }
    return this.browserPromise;
  }

  async get(url, options = {}) {
    const { page } = await this.getPage(url, options);
    try {
      const html = await page.content();
      return { data: html };
    } finally {
      await page.close();
    }
  }

  async getPage(url) {
    const browser = await this.getBrowser();
    const page = await browser.newPage();

    // Set realistic user agent
    await page.setUserAgent(
      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
    );

    await page.goto(url, { waitUntil: 'networkidle0', timeout: 30000 });
    // Wait an extra second just in case Angular is doing some final rendering
    await new Promise((r) => setTimeout(r, 2000));

    return { browser, page };
  }
}

// Export a singleton instance
const stealthClient = new StealthClient();
module.exports = stealthClient;
