/**
 * @typedef {import('../models/AvailabilityModels.js').AvailabilityProvider} AvailabilityProvider
 */

class BookPlugin {
  constructor(name, targetRegions, type, priority, notFound, error) {
    this.name = name;
    this.targetRegions = targetRegions;
    this.type = type;
    this.priority = priority;
    this.notFound = notFound;
    this.error = error;
  }

  /**
   * @param {string} isbn 
   * @returns {Promise<AvailabilityProvider[]>}
   */
  async fetchAvailabilityByIsbn(isbn) {
    throw new Error("fetchAvailabilityByIsbn() not implemented");
  }
}

module.exports = BookPlugin;
