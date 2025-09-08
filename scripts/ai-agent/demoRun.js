const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');
const { generateReports } = require('./report/reportGenerator');

const SAMPLE_YAML_PATH = path.join(__dirname, '..', '..', 'openai', 'output', 'test-mutation-sample.yaml');

async function runDemoReport() {
  try {
    console.log('\n🧪 Simulación: carga de YAML y reportería...');

    const yamlContent = fs.readFileSync(SAMPLE_YAML_PATH, 'utf8');
    const mutations = yaml.loadAll(yamlContent);

    // Fake resultados de pruebas para demo
    const results = mutations.map((m, i) => ({
      file: `${m.className || 'Class'}__mutation_${i + 1}.cls`,
      passed: true,
      failures: []
    }));

    const today = new Date().toISOString().split('T')[0];
    const folderPath = path.join(__dirname, '..', '..', 'mutations', today);

    await generateReports(results, mutations, folderPath);

    console.log('✅ Simulación de reportería completada.');
  } catch (err) {
    console.error('❌ Error en la demo:', err.message);
  }
}

runDemoReport();
