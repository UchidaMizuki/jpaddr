const { normalize } = require('@geolonia/normalize-japanese-addresses');
const fs = require('fs');

normalize(
  process.argv[2],
  { level: process.argv[3] }
).then(result => {
  fs.writeFileSync('normalize_address.json', JSON.stringify(result));
});
