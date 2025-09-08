const path = require('path');
const fs = require('fs');
const dayjs = require('dayjs');
const { parseYAML } = require('./parseYamlMutations');
const { writeMutatedFiles } = require('./writeMutatedClasses');
const { runRetrieve, runDeploy, runTest } = require('./sfExecutor');
const { generateReports } = require('./report/reportGenerator');
const { notifyGearset } = require('./gearsetNotifier');

const MUTATION_BASE = path.join(__dirname, '..', '..', 'mutations');

/**
 * Ejecuta todo el pipeline de pruebas destructivas
 * @param {string} yamlFilePath - Ruta al archivo .yaml con mutaciones
 */
async function runMutationPipeline(yamlFilePath) {
  console.log('\n🔁 Ejecutando pipeline de mutaciones destructivas...\n');

  // 1. Parsear YAML
  const mutations = parseYAML(yamlFilePath);
  const today = dayjs().format('YYYY-MM-DD');
  const folderPath = path.join(MUTATION_BASE, today);
  fs.mkdirSync(folderPath, { recursive: true });

  // 2. Generar archivos mutados
  const generatedFiles = writeMutatedFiles(mutations, folderPath);
  const results = [];

  for (const { outputFile, originalFile } of generatedFiles) {
    console.log(`🧬 Aplicando mutación: ${path.basename(outputFile)}`);

    await runRetrieve(); // 🔄 sincroniza con el Org

    const deployed = await runDeploy(outputFile); // 🚀 sube la clase mutada
   if (!deployed) {
      results.push({
        file: path.basename(outputFile),
        status: '❌ Deploy fallido',
        passed: false
      });
      continue;
    }

    const className = path.basename(outputFile, '.cls').split('__')[0];
    const expectedTests = mutations.find(m => m.className === className)?.['Expected impact'] || [];

    const testResult = runTest(className, expectedTests);
    results.push({
      file: path.basename(outputFile),
      passed: testResult.passed,
      failures: testResult.failures,
      status: testResult.passed ? '✅ Passed' : '❌ Failed'
    });
  }

  console.log('📊 Generando reportes...');
  // 3. Generar reportes
  await generateReports(results, mutations, outputDir);

  // 4. Enviar a Gearset
  await notifyGearset({
    prId: 123,
    status: results.every(r => r.status === '✅ Passed') ? 'PASSED' : 'FAILED',
    summary: `Total: ${results.length}, Fallos: ${results.filter(r => r.status === '❌ Failed').length}`,
    badge: results.every(r => r.passed) ? '✅ AI Approved' : '⚠️ AI Weak Coverage'
  });

  console.log('\n✅ Pipeline completado.\n');
}

module.exports = { runMutationPipeline };
