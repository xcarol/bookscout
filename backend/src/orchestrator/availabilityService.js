const { db } = require('../cache/firestore');
const plugins = require('../plugins');

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
  const results = await Promise.allSettled(promises);

  const successfulResults = [];
  let metadataUpdated = false;

  results.forEach(result => {
    if (result.status === 'fulfilled' && result.value) {
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
