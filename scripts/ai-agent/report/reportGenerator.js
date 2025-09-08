const fs = require('fs');
const path = require('path');
const dayjs = require('dayjs');
const { Parser } = require('json2csv');

// ✅ Nuevos módulos visuales
const { generateHtmlReport } = require('./generateHtmlReport');
const { generatePdfReport } = require('./generatePdfReport');

function generateReports(results, mutations, folderBasePath) {
  const dateDir = dayjs().format('YYYY-MM-DD');
  const folderPath = folderBasePath || path.join(__dirname, '..', '..', '..', 'mutations', dateDir);

  fs.mkdirSync(folderPath, { recursive: true });

  // 1. Guardar JSON
  const jsonPath = path.join(folderPath, 'mutation-history.json');
  fs.writeFileSync(jsonPath, JSON.stringify(mutations, null, 2));

  // 2. Guardar CSV
  const parser = new Parser();
  const csv = parser.parse(mutations);
  fs.writeFileSync(path.join(folderPath, 'mutation-history.csv'), csv);

  // 3. Guardar Markdown
  const md = `# 🧪 AI Mutation Summary - ${dateDir}\n\n` + mutations.map((m, i) => (
    `## 💥 Mutation ${i + 1} (${m.class})\n` +
    `- **Affected line:** ${m.affected_line}\n` +
    `- **Mutation:** ${m.mutation_type}\n` +
    `- **Impact:** ${m.impact}\n` +
    `- **Status:** ${m.status}\n`
  )).join('\n\n');

  fs.writeFileSync(path.join(folderPath, 'mutation-history.md'), md);

  console.log('📊 Archivos mutation-history.{json,csv,md} generados correctamente.');

  // 4. ✅ Generar HTML visual
  generateHtmlReport(mutations, folderPath);

  // 5. ✅ Convertir a PDF
  generatePdfReport(folderPath);
}

module.exports = {
  generateReports
};
