const { config, normalize } = require('@geolonia/normalize-japanese-addresses');
const fs = require('fs');

config.japaneseAddressesApi = 'file:///japanese-addresses/api/ja';

async function normalize_address() {
  const inputs = JSON.parse(fs.readFileSync('normalize_address.json', 'utf8'));
  const outputs = await Promise.all(inputs.map(input => normalize(input['address'], { level: input['level'] })));

  await fs.writeFileSync('normalize_address.json', JSON.stringify(outputs));
}

normalize_address();
