#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const { runAdvancedMutations } = require('./advancedMutationWriter');

async function runAllMutations() {
  console.log('🔬 Ejecutando TODOS los casos de prueba de mutación para tipos Apex\n');
  
  const today = new Date().toISOString().split('T')[0];
  const baseOutputDir = path.join(__dirname, '..', '..', 'mutations', today);
  
  const mutationSuites = [
    {
      name: 'Mutaciones Básicas',
      file: 'mutation-test-cases.yaml',
      outputDir: path.join(baseOutputDir, 'basic')
    },
    {
      name: 'Patrones Avanzados',
      file: 'advanced-mutation-cases.yaml', 
      outputDir: path.join(baseOutputDir, 'advanced')
    }
  ];
  
  const allReports = [];
  
  for (const suite of mutationSuites) {
    console.log(`\n🎯 Ejecutando: ${suite.name}`);
    console.log(`📁 Archivo: ${suite.file}`);
    console.log(`📂 Salida: ${suite.outputDir}\n`);
    
    const yamlPath = path.join(__dirname, '..', '..', suite.file);
    
    if (!fs.existsSync(yamlPath)) {
      console.warn(`⚠️ Archivo no encontrado: ${yamlPath}`);
      continue;
    }
    
    try {
      const report = await runAdvancedMutations(yamlPath, suite.outputDir);
      report.suiteName = suite.name;
      allReports.push(report);
      
      console.log(`✅ ${suite.name} completado: ${report.successfulMutations}/${report.totalMutations} mutaciones exitosas`);
      
    } catch (error) {
      console.error(`❌ Error en ${suite.name}:`, error.message);
    }
  }
  
  // Generar reporte consolidado
  console.log('\n📊 REPORTE CONSOLIDADO DE MUTACIONES\n');
  
  let totalMutations = 0;
  let totalSuccessful = 0;
  const allTypes = new Set();
  const allClasses = new Set();
  const allTests = new Set();
  
  allReports.forEach(report => {
    totalMutations += report.totalMutations;
    totalSuccessful += report.successfulMutations;
    
    report.summary.types.forEach(type => allTypes.add(type));
    report.summary.classes.forEach(cls => allClasses.add(cls));
    report.summary.expectedFailingTests.forEach(test => allTests.add(test));
    
    console.log(`📋 ${report.suiteName}:`);
    console.log(`   Mutaciones: ${report.successfulMutations}/${report.totalMutations}`);
    console.log(`   Tipos: ${report.summary.types.join(', ')}`);
    console.log(`   Clases: ${report.summary.classes.length}`);
    console.log('');
  });
  
  console.log('🎯 RESUMEN TOTAL:');
  console.log(`   Total mutaciones exitosas: ${totalSuccessful}/${totalMutations}`);
  console.log(`   Tipos de Apex cubiertos: ${Array.from(allTypes).join(', ')}`);
  console.log(`   Clases afectadas: ${allClasses.size}`);
  console.log(`   Tests que deberían fallar: ${allTests.size}`);
  
  // Guardar reporte consolidado
  const consolidatedReport = {
    timestamp: new Date().toISOString(),
    summary: {
      totalMutations,
      totalSuccessful,
      failureRate: ((totalMutations - totalSuccessful) / totalMutations * 100).toFixed(2) + '%',
      typesCount: allTypes.size,
      classesCount: allClasses.size,
      testsCount: allTests.size
    },
    suites: allReports,
    types: Array.from(allTypes),
    classes: Array.from(allClasses),
    expectedFailingTests: Array.from(allTests)
  };
  
  const reportPath = path.join(baseOutputDir, 'consolidated-mutation-report.json');
  fs.mkdirSync(path.dirname(reportPath), { recursive: true });
  fs.writeFileSync(reportPath, JSON.stringify(consolidatedReport, null, 2));
  
  console.log(`\n📄 Reporte consolidado guardado en: ${reportPath}`);
  
  console.log('\n🧪 PRÓXIMOS PASOS:');
  console.log('1. Revisa los archivos mutados en la carpeta mutations/');
  console.log('2. Despliega las clases mutadas a tu Salesforce org');
  console.log('3. Ejecuta las pruebas unitarias correspondientes');
  console.log('4. Verifica que las pruebas FALLEN con código mutado');
  console.log('5. Si las pruebas pasan, mejora la cobertura de pruebas');
  
  return consolidatedReport;
}

if (require.main === module) {
  runAllMutations()
    .then(() => console.log('\n✅ Proceso completo de mutación terminado exitosamente!'))
    .catch(error => {
      console.error('❌ Error en el proceso:', error.message);
      process.exit(1);
    });
}

module.exports = { runAllMutations };