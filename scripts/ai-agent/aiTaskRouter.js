// scripts/ai-agent/aiTaskRouter.js

const { runMutationPipeline } = require('./mutationExecutor');

/**
 * Rutea la tarea solicitada a la función correspondiente
 * @param {string} task - Tipo de tarea ('mutate', 'suggest', 'generateTests', etc.)
 * @param {string} yamlPath - Ruta al archivo YAML generado por OpenAI
 */
async function routeTask(task, yamlPath) {
  switch (task) {
    case 'mutate':
      await runMutationPipeline(yamlPath);
      break;

    case 'suggest':
      console.log('🧠 Tarea "suggest" aún no implementada.');
      break;

    case 'generateTests':
      console.log('🧪 Tarea "generateTests" aún no implementada.');
      break;

    case 'coverageAnalysis':
      console.log('🔍 Tarea "coverageAnalysis" aún no implementada.');
      break;

    default:
      console.warn(`⚠️ Tarea desconocida: ${task}`);
      break;
  }
}

module.exports = {
  routeTask,
};
