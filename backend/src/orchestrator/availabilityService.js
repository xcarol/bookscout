const { db } = require('../cache/firestore');
const plugins = require('../plugins');
const { sendTelegramAlert } = require('../services/telegramNotifier');
const { FORMATS, ERROR_TYPES } = require('../models/Constants');

async function checkAvailability(isbn, country = 'GLOBAL', region = null) {
  const normalizedCountry = country.toUpperCase();
  const normalizedRegion = region ? region.toLowerCase() : 'global';
  const cacheId = `${isbn}_${normalizedCountry}_${normalizedRegion}`;

  // 1. Check cache first
  try {
    const cachedDoc = await db.collection('availability').doc(cacheId).get();
    if (cachedDoc.exists) {
      const data = cachedDoc.data();
      if (data.expiresAt && new Date(data.expiresAt) > new Date()) {
        console.info(`[CACHE HIT] Returning cached availability for ${cacheId}`);
        return data.providers;
      }
    }
  } catch (error) {
    console.error(`[CACHE ERROR] Failed to fetch cached availability for ${cacheId}:`, error);
  }

  console.info(`[CACHE MISS] Fetching fresh availability for ${cacheId}...`);

  // Filter plugins by region
  const filteredPlugins = plugins.filter(plugin => 
    plugin.regions.includes(normalizedCountry) || plugin.regions.includes('GLOBAL')
  );

  // Execute all filtered plugins concurrently
  const promises = filteredPlugins.map(plugin => {
    return plugin.execute(isbn, region);
  });
  
  // Also get the book edition to know its format for filtering
  const editionPromise = db.collection('editions').doc(isbn).get();
  
  const [results, editionDoc] = await Promise.all([
    Promise.allSettled(promises),
    editionPromise.catch(() => null)
  ]);

  const bookFormat = editionDoc?.exists ? (editionDoc.data().format || FORMATS.UNKNOWN) : FORMATS.UNKNOWN;

  const successfulResults = [];
  let metadataUpdated = false;

  results.forEach(result => {
    if (result.status === 'fulfilled' && result.value) {
      if (result.value.error) {
        if (result.value.errorType === ERROR_TYPES.NOT_FOUND) {
          console.info(`[INFO] ${result.value.providerName}: Book ${isbn} not found.`);
        } else {
          console.error(`[ERROR] ${result.value.providerName}: Error - ${result.value.errorMessage}`);
          if (typeof sendTelegramAlert === 'function') {
            sendTelegramAlert(result.value.providerName, isbn, result.value.errorMessage || 'Unknown error').catch(() => {});
          }
        }
        return; // Skip adding to successfulResults
      }

      const providerFormat = result.value.format;
      
      if (bookFormat !== FORMATS.UNKNOWN && providerFormat !== FORMATS.UNKNOWN && bookFormat !== providerFormat) {
        console.info(`[FILTER] Skipping provider ${result.value.providerName} for ISBN ${isbn} because formats do not match (${providerFormat} vs ${bookFormat})`);
        return;
      }

      successfulResults.push(result.value);

      // Hydration logic: Take metadata from the first valid result that provides it
      if (!metadataUpdated && result.value.metadata && Object.keys(result.value.metadata).length > 0) {
        const meta = result.value.metadata;
        const updateDoc = { updatedAt: new Date().toISOString() };

        if (meta.title) updateDoc.title = meta.title;
        if (meta.description || meta.synopsis) updateDoc.description = meta.description || meta.synopsis;
        if (meta.coverUrl) updateDoc.coverUrl = meta.coverUrl;
        if (meta.publisher) updateDoc.publisher = meta.publisher;
        if (meta.publishedDate) updateDoc.publishedDate = meta.publishedDate;
        if (meta.language) updateDoc.language = meta.language;
        if (meta.pages) updateDoc.pageCount = meta.pages;
        if (meta.categories) updateDoc.categories = meta.categories;
        if (meta.collection) updateDoc.series = { name: meta.collection, position: null };

        // For simplicity, we just merge these root fields into the edition
        db.collection('editions').doc(isbn).set(updateDoc, { merge: true }).catch(console.error);
        metadataUpdated = true; // prevent multiple plugins from overwriting metadata simultaneously
      }
    } else if (result.status === 'rejected') {
      console.error('Plugin failed:', result.reason);
    }
  });

  // Strip metadata to save only provider info in cache
  const providers = successfulResults.map(r => ({
    providerName: r.providerName,
    isAvailable: r.isAvailable,
    price: r.price,
    currency: r.currency,
    url: r.url,
    format: r.format,
    status: r.status
  }));

  // Save to cache (expires in 24 hours)
  try {
    const expiresAt = new Date();
    expiresAt.setHours(expiresAt.getHours() + 24);

    await db.collection('availability').doc(cacheId).set({
      id: cacheId,
      isbn,
      country: normalizedCountry,
      region: normalizedRegion,
      expiresAt: expiresAt.toISOString(),
      providers
    });
  } catch (error) {
    console.error(`[CACHE ERROR] Failed to save availability for ${cacheId}:`, error);
  }

  return providers;
}

module.exports = { checkAvailability };
