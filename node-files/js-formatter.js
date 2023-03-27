const beautify = require('js-beautify').js,
      fs = require('fs');

const args = process.argv.slice(2);
const readFile = args[0];
const outputFile = args[1];

fs.readFile(readFile, 'utf8', function (err, data) {
  if (err) {
    throw err;
  }
  fs.writeFileSync(outputFile, beautify(data, { indent_size: 2, space_in_empty_paren: true }))
});