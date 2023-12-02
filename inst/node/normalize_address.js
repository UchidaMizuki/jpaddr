const { normalize } = require('@geolonia/normalize-japanese-addresses');
const fs = require('fs');

const timeout = process.argv[4] * 1000;

const timer = setTimeout(() => {
  process.exit(1);
}, timeout);

normalize(
  process.argv[2],
  { level: process.argv[3] }
).then(result => {
  clearTimeout(timer);
  fs.writeFileSync('normalize_address.json', JSON.stringify(result));
});
