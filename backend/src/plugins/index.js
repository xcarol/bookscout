const { scrapeTodostuslibros } = require('./todostuslibros');
const { scrapeEBiblio } = require('./ebiblio');

const plugins = [
  {
    id: 'todostuslibros',
    regions: ['ES'],
    execute: scrapeTodostuslibros
  },
  {
    id: 'ebiblio',
    regions: ['ES'],
    execute: scrapeEBiblio
  }
];

module.exports = plugins;
