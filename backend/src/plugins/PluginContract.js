/**
 * @typedef {import('../models/AvailabilityModels.js').AvailabilityProvider} AvailabilityProvider
 */

class BookPlugin {
  constructor(name, targetRegions, type, priority) {
    this.name = name;
    this.targetRegions = targetRegions;
    this.type = type;
    this.priority = priority;
    this.errorCount = 0;
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
