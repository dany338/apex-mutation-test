const fs = require('fs');
const path = require('path');

/**
 * Escribe archivos .cls mutados basándose en texto/patrones (nueva versión)
 * @param {Array<Object>} mutations - Lista de mutaciones con originalCode/mutatedCode
 * @param {string} outputDir - Carpeta destino para los .cls generados
 * @returns {Array<Object>} Archivos generados con metadata
 */
function writeMutatedFilesAdvanced(mutations, outputDir) {
  const generated = [];

  for (const mutation of mutations) {
    const {
      className,
      type,
      description,
      originalCode,
      mutatedCode,
      expectedImpact,
      reason
    } = mutation;

    const fileName = `${className}.cls`;
    const originalPath = path.join(__dirname, '..', '..', 'force-app', 'main', 'default', 'classes', fileName);
    
    if (!fs.existsSync(originalPath)) {
      console.warn(`⚠️ Clase original no encontrada: ${fileName}`);
      continue;
    }

    // Leer el archivo original
    let content = fs.readFileSync(originalPath, 'utf8');
    
    // Verificar que el código original existe en el archivo
    if (!content.includes(originalCode)) {
      console.warn(`⚠️ Código original no encontrado en ${fileName}: ${originalCode}`);
      continue;
    }

    // Aplicar la mutación
    const mutatedContent = content.replace(originalCode, mutatedCode);
    
    if (mutatedContent === content) {
      console.warn(`⚠️ No se aplicó ninguna mutación en ${fileName}`);
      continue;
    }

    // Generar nombre único para el archivo mutado
    const timestamp = Date.now();
    const outputFile = path.join(outputDir, `${className}__mutated_${timestamp}.cls`);
    
    // Escribir archivo mutado
    fs.writeFileSync(outputFile, mutatedContent);

    // Crear archivo de metadata
    const metaContent = `<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>64.0</apiVersion>
    <status>Active</status>
</ApexClass>`;
    fs.writeFileSync(outputFile + '-meta.xml', metaContent);

    generated.push({
      className,
      type,
      outputFile,
      originalFile: originalPath,
      description,
      expectedImpact: Array.isArray(expectedImpact) ? expectedImpact : [expectedImpact],
      originalCode,
      mutatedCode,
      reason,
      timestamp
    });

    console.log(`✅ Mutación creada: ${path.basename(outputFile)}`);
    console.log(`   Tipo: ${type}`);
    console.log(`   Descripción: ${description}`);
    console.log(`   Impacto esperado: ${Array.isArray(expectedImpact) ? expectedImpact.join(', ') : expectedImpact}`);
  }

  return generated;
}

/**
 * Ejecuta mutaciones y genera reporte
 * @param {string} yamlFilePath - Ruta al archivo YAML
 * @param {string} outputDir - Directorio de salida
 */
async function runAdvancedMutations(yamlFilePath, outputDir) {
  const { parseYAML } = require('./parseYamlMutations');
  
  console.log('🧬 Iniciando proceso de mutaciones avanzadas...\n');
  
  // Crear directorio de salida
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Parsear mutaciones del YAML
  const mutations = parseYAML(yamlFilePath);
  
  if (mutations.length === 0) {
    console.log('❌ No se encontraron mutaciones válidas en el YAML');
    return;
  }

  // Generar archivos mutados
  const generated = writeMutatedFilesAdvanced(mutations, outputDir);
  
  // Generar reporte
  const reportPath = path.join(outputDir, 'mutation-report.json');
  const report = {
    timestamp: new Date().toISOString(),
    totalMutations: mutations.length,
    successfulMutations: generated.length,
    failedMutations: mutations.length - generated.length,
    mutations: generated,
    summary: {
      types: [...new Set(generated.map(m => m.type))],
      classes: [...new Set(generated.map(m => m.className))],
      expectedFailingTests: [...new Set(generated.flatMap(m => m.expectedImpact))]
    }
  };
  
  fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
  
  console.log('\n📊 Reporte de mutaciones:');
  console.log(`   Total mutaciones: ${report.totalMutations}`);
  console.log(`   Exitosas: ${report.successfulMutations}`);
  console.log(`   Fallidas: ${report.failedMutations}`);
  console.log(`   Tipos de Apex: ${report.summary.types.join(', ')}`);
  console.log(`   Clases afectadas: ${report.summary.classes.join(', ')}`);
  console.log(`   Tests que deberían fallar: ${report.summary.expectedFailingTests.join(', ')}`);
  console.log(`\n📄 Reporte guardado en: ${reportPath}`);
  
  return report;
}

module.exports = { 
  writeMutatedFilesAdvanced, 
  runAdvancedMutations,
  writeMutatedFiles: writeMutatedFilesAdvanced // Alias para compatibilidad
};