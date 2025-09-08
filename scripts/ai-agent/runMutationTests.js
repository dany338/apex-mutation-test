#!/usr/bin/env node

const path = require('path');
const fs = require('fs');
const { runAdvancedMutations } = require('./advancedMutationWriter');

async function main() {
  const args = process.argv.slice(2);
  const yamlFile = args[0] || 'mutation-test-cases.yaml';
  const yamlPath = path.join(__dirname, '..', '..', yamlFile);
  const outputDir = path.join(__dirname, '..', '..', 'mutations', new Date().toISOString().split('T')[0]);
  
  console.log('🔬 Ejecutando casos de prueba de mutación para tipos Apex\n');
  console.log(`📁 Archivo YAML: ${yamlPath}`);
  console.log(`📂 Directorio de salida: ${outputDir}\n`);
  
  try {
    if (!fs.existsSync(yamlPath)) {
      console.error(`❌ Archivo YAML no encontrado: ${yamlPath}`);
      console.log('\nArchivos YAML disponibles:');
      console.log('- mutation-test-cases.yaml (mutaciones básicas)');
      console.log('- advanced-mutation-cases.yaml (patrones avanzados)');
      process.exit(1);
    }
    
    const report = await runAdvancedMutations(yamlPath, outputDir);
    
    console.log('\n✅ Proceso de mutación completado exitosamente!');
    console.log('\n📋 Resumen de mutaciones por tipo:');
    
    const typeCount = {};
    report.mutations.forEach(m => {
      typeCount[m.type] = (typeCount[m.type] || 0) + 1;
    });
    
    Object.entries(typeCount).forEach(([type, count]) => {
      console.log(`   ${type}: ${count} mutaciones`);
    });
    
    console.log('\n🧪 Para probar la efectividad de los tests:');
    console.log('1. Despliega las clases mutadas a tu org');
    console.log('2. Ejecuta los tests asociados');
    console.log('3. Los tests deberían FALLAR si son efectivos');
    console.log('4. Si los tests pasan con código mutado, necesitas mejorar los tests');
    
    console.log('\n📊 Tests que deberían fallar:');
    report.summary.expectedFailingTests.forEach(test => {
      console.log(`   - ${test}`);
    });
    
  } catch (error) {
    console.error('❌ Error durante la ejecución:', error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

if (require.main === module) {
  main();
}

module.exports = { main };