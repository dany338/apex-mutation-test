const fs = require('fs');
const path = require('path');
const { processFiles } = require('./processApexFiles');
const { detectClassType } = require('./detectClassType');
const { loadViewForType, generatePromptFromTemplate } = require('./generatePrompt');
const { callOpenAI } = require('./openaiClient');
const { routeTask } = require('./aiTaskRouter'); // ⬅ Nuevo import

const repoPath = path.resolve(__dirname, '../../force-app/main/default/classes'); // Asegúrate de ajustar si trabajas desde triggers

async function runAgentAI() {
  try {
    console.log('\n🤖 Iniciando ejecución del agente AI...');

    const files = await processFiles({ useGitDiff: true }); // Usa Git por defecto

    if (!files.length) {
      console.log('📭 No se encontraron archivos Apex modificados.');
      return;
    }

    for (const { filePath } of files) {
      const fileName = path.basename(filePath);
      const apexContent = fs.readFileSync(filePath, 'utf-8');
      const type = detectClassType(filePath, apexContent);
      const view = loadViewForType(type, apexContent);
      // console.log(`\n📄 Procesando archivo: ${path.basename(filePath)} [${type}]`);

      // const filePath = path.join(repoPath, fileName);

      console.log(`🔍 Analizando archivo: ${fileName} como tipo ${type}`);

      const prompt = generatePromptFromTemplate(view);

      const aiResponse = await callOpenAI(prompt);

      const tmpYamlPath = path.join(__dirname, '../../openai/output', `${fileName}.mutations.yaml`);
      fs.writeFileSync(tmpYamlPath, aiResponse, 'utf-8');

      // 🔁 Modularizamos con el router de tareas
      await routeTask('mutate', tmpYamlPath); // Futuro: 'suggest', 'generateTests', etc.
    }

    console.log('✅ Agente AI ejecutado correctamente.\n');
  } catch (err) {
    console.error('❌ Error en ejecución del agente AI:', err.message);
  }
}

runAgentAI();
