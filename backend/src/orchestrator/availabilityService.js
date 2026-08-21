const { db } = require('../cache/firestore');
const plugins = require('../plugins');

async function checkAvailability(isbn, country = 'GLOBAL', lang = 'en') {
  const normalizedCountry = country.toUpperCase();
  // Filter plugins by region
  const filteredPlugins = plugins.filter(plugin => 
    plugin.regions.includes(normalizedCountry) || plugin.regions.includes('GLOBAL')
  );

  // Execute all filtered plugins concurrently
  const promises = filteredPlugins.map(plugin => {
    return plugin.execute(isbn, lang);
  });
  const results = await Promise.allSettled(promises);

  const successfulResults = [];
  let metadataUpdated = false;

  results.forEach(result => {
    if (result.status === 'fulfilled' && result.value) {
      successfulResults.push(result.value);

      // Hydration logic: Take metadata from the first valid result that provides it
      if (!metadataUpdated && result.value.metadata && Object.keys(result.value.metadata).length > 0) {
        db.collection('editions').doc(isbn).set(
          { metadata: result.value.metadata, updatedAt: new Date().toISOString() }, 
          { merge: true }
        ).catch(console.error);
        metadataUpdated = true; // prevent multiple plugins from overwriting metadata simultaneously
      }
    } else if (result.status === 'rejected') {
      console.error('Plugin failed:', result.reason);
    }
  });

  return successfulResults;
}

module.exports = { checkAvailability };
