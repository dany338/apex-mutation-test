const fs = require('fs');
const path = require('path');
const mustache = require('mustache');

// Ruta del template base Mustache
const PROMPT_TEMPLATE_PATH = path.join(__dirname, '../prompts/prompt-template.mustache');
const template = fs.readFileSync(PROMPT_TEMPLATE_PATH, 'utf8');

/**
 * Carga y enriquece dinámicamente el view JSON del tipo de clase.
 * Si no encuentra view, construye uno base.
 */
function loadViewForType(type, apexContent, fileName = 'UnknownClass') {
  const viewPath = path.join(__dirname, '../prompts', `view-${type}.json`);
  let view = {};

  // Intenta cargar view personalizado por tipo
  if (fs.existsSync(viewPath)) {
    const json = fs.readFileSync(viewPath, 'utf8');
    view = JSON.parse(json);
  } else {
    console.warn(`⚠️ No se encontró view para tipo ${type}, usando vista dinámica`);
  }

  const lines = apexContent.split('\n');

  return {
    ...view,
    class_name: fileName.replace('.cls', ''),
    class_type: type,
    class_content: apexContent,
    total_lines: lines.length,
    num_mutations: 3, // puedes hacer esto dinámico si luego se parametriza
    target_block: 'main logic',
    start_line: 1
  };
}

/**
 * Renderiza el prompt final con Mustache
 */
function generatePromptFromTemplate(view) {
  return mustache.render(template, view);
}

module.exports = {
  loadViewForType,
  generatePromptFromTemplate,
};
