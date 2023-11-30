const { normalize } = require('@geolonia/normalize-japanese-addresses');
const fs = require('fs');

const inputs = JSON.parse(fs.readFileSync('normalize_address.json', 'utf8'));
let outputs = [];

for (const input of inputs) {
  let output = normalize(
    input['address'],
    { level: input['level'] }
  );
  outputs.push(output);
}

Promise.all(outputs).then(results => {
  fs.writeFileSync('normalize_address.json', JSON.stringify(results));
});
