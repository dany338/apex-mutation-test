const fs = require('fs-extra');
const path = require('path');
const yaml = require('js-yaml');
const dayjs = require('dayjs');

async function applyMutations({ classPath, yamlContent }) {
  const originalContent = await fs.readFile(classPath, 'utf8');
  const lines = originalContent.split('\n');

  const parsed = yaml.load(yamlContent); // Mejor que loadAll si es un array plano
  const className = path.basename(classPath, '.cls');
  const today = dayjs().format('YYYY-MM-DD');

  const outputDir = path.join(__dirname, '../../mutations', today);
  await fs.ensureDir(outputDir);

  // Backup
  const backupPath = path.join(outputDir, `${className}__backup.cls`);
  await fs.writeFile(backupPath, originalContent);

  const mutationPaths = [];

  for (let i = 0; i < parsed.length; i++) {
    const mutation = parsed[i];
    const { 'Affected line': lineNum, 'Mutated line': newLine, 'Original line': oldLine, 'Mutation type': type } = mutation;
    if (!lineNum || !newLine) continue;

    const index = lineNum - 1;

    if (!lines[index]?.includes(oldLine.trim())) {
      console.warn(`⚠️ Advertencia: Línea ${lineNum} no coincide exactamente con línea esperada.`);
    }

    const mutatedLines = [...lines];
    mutatedLines[index] = newLine;

    const mutatedContent = mutatedLines.join('\n');
    const fileName = `${className}__mut${i + 1}_${type.replace(/\s+/g, '_')}.cls`;
    const filePath = path.join(outputDir, fileName);

    await fs.writeFile(filePath, mutatedContent);

    mutationPaths.push({
      filePath,
      description: mutation.Description || '',
      expectedImpact: mutation['Expected impact'] || '',
    });
  }

  return mutationPaths;
}

module.exports = { applyMutations };
