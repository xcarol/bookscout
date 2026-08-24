const { scrapeTodostuslibros } = require('../src/plugins/todostuslibros');

async function runTest() {
  const isbn = '9788466353779';
  console.log(`Testing scrapeTodostuslibros for ISBN: ${isbn}`);

  try {
    const result = await scrapeTodostuslibros(isbn);
    console.log('Result:');
    console.dir(result, { depth: null });
  } catch (error) {
    console.error('Unexpected error during testing:', error);
  }
}

runTest();
