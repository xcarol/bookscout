const { scrapeTodostuslibros } = require('./todostuslibros');
const { scrapeEBiblioCat, ebiblioCatRegions } = require('./ebiblio_cat');
const { scrapeEBiblio, ebiblioRegions } = require('./ebiblio');

const plugins = [
  {
    id: 'todostuslibros',
    countries: ['ES'],
    regions: [], // TodoTusLibros is nationwide, no specific regions required
    execute: scrapeTodostuslibros,
  },
  {
    id: 'ebiblio_cat',
    countries: ['ES'],
    regions: ebiblioCatRegions,
    execute: scrapeEBiblioCat,
  },
  {
    id: 'ebiblio',
    countries: ['ES'],
    regions: ebiblioRegions,
    execute: scrapeEBiblio,
  },
];

module.exports = plugins;
