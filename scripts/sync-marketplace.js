#!/usr/bin/env node
// Updates the matching plugin entry in .claude-plugin/marketplace.json.
// Invoked from a release-it hook after the bumper has updated plugin.json.
// release-it runs hooks from the plugin's directory, so marketplace.json
// is one level up.
//
// Usage: node ../scripts/sync-marketplace.js <plugin-name> <version>

const fs = require('fs');

const [pluginName, version] = process.argv.slice(2);
if (!pluginName || !version) {
  console.error('usage: sync-marketplace.js <plugin-name> <version>');
  process.exit(1);
}

const marketplacePath = '../.claude-plugin/marketplace.json';
const marketplace = JSON.parse(fs.readFileSync(marketplacePath, 'utf8'));
const entry = marketplace.plugins.find((p) => p.name === pluginName);
if (!entry) {
  console.error(`plugin "${pluginName}" not found in marketplace.json`);
  process.exit(1);
}
entry.version = version;
fs.writeFileSync(marketplacePath, JSON.stringify(marketplace, null, 2) + '\n');
console.log(`synced ${pluginName} -> ${version} in marketplace.json`);
