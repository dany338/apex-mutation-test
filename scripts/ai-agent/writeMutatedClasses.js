const fs = require('fs');
const path = require('path');

/**
 * Escribe archivos .cls mutados a partir de mutaciones destructivas
 * @param {Array<Object>} mutations - Lista de mutaciones (desde YAML)
 * @param {string} outputDir - Carpeta destino para los .cls generados
 * @returns {Array<Object>} Archivos generados con metadata
 */
function writeMutatedFiles(mutations, outputDir) {
  const generated = [];

  for (const mutation of mutations) {
    const {
      className = 'UnknownClass',
      fileName = `${className}.cls`,
      'Mutated line': mutatedLine,
      'Affected line': lineNum,
      'Original line': originalLine,
      Description = '',
      'Expected impact': expectedImpact
    } = mutation;

    const originalPath = path.join('force-app', 'main', 'default', 'classes', fileName);
    if (!fs.existsSync(originalPath)) {
      console.warn(`⚠️ Clase original no encontrada: ${fileName}`);
      continue;
    }

    const lines = fs.readFileSync(originalPath, 'utf8').split('\n');
    const backup = [...lines];

    lines[lineNum - 1] = mutatedLine;

    const outputFile = path.join(outputDir, `${className}__mutated_${lineNum}.cls`);
    fs.writeFileSync(outputFile, lines.join('\n'));

    generated.push({
      className,
      outputFile,
      originalFile: originalPath,
      description: Description,
      expectedImpact,
      originalLine,
      mutatedLine,
      lineNum
    });

    // Backup opcional
    fs.writeFileSync(
      path.join(outputDir, `${className}__backup.cls`),
      backup.join('\n')
    );
  }

  return generated;
}

module.exports = { writeMutatedFiles };
