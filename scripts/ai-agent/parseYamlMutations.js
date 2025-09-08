const fs = require('fs');
const yaml = require('js-yaml');

function parseYAML(filePath) {
  const content = fs.readFileSync(filePath, 'utf8');
  try {
    const parsed = yaml.loadAll(content).filter(Boolean);
    console.log(`✅ Se detectaron ${parsed.length} mutaciones destructivas.`);
    return parsed;
  } catch (err) {
    console.error('❌ Error parseando YAML:', err.message);
    return [];
  }
}

module.exports = { parseYAML };
