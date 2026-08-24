const { scrapeTodostuslibros } = require('./todostuslibros');
const { scrapeEBiblioCat } = require('./ebiblio_cat');
const { scrapeEBiblio } = require('./ebiblio');

const plugins = [
  {
    id: 'todostuslibros',
    regions: ['ES'],
    execute: scrapeTodostuslibros,
  },
  {
    id: 'ebiblio_cat',
    regions: ['ES'],
    execute: scrapeEBiblioCat,
  },
  {
    id: 'ebiblio',
    regions: ['ES'],
    execute: scrapeEBiblio,
  },
];

module.exports = plugins;
