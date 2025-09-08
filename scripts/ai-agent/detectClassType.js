const fs = require('fs');
const path = require('path');

// Entrada: ruta del archivo Apex
function detectClassType(filePath) {
  const ext = path.extname(filePath);
  const content = fs.readFileSync(filePath, 'utf8');
  const lower = content.toLowerCase();

  // Prioridad por extensión
  if (ext === '.trigger') return 'trigger';

  // Análisis por contenido
  if (/implements\s+Database\.Batchable/.test(content)) return 'batch';
  if (/implements\s+Queueable/.test(content)) return 'queueable';
  if (/implements\s+Schedulable/.test(content)) return 'schedulable';
  if (/@InvocableMethod/.test(content)) return 'invocable';
  if (/extends\s+\w*Controller/.test(content) || /PageReference/.test(content)) return 'controller';
  if (/(@isTest|testMethod)/.test(content) || /class\s+\w*Test/.test(content)) return 'test';

  // Estilo moderno
  if (lower.includes('extends triggerhandler')) return 'triggerHandler';

  if (lower.includes('class')) return 'class'; // Clase estándar

  // return 'standard';
  // ❓ Fallback
  return 'unknown';
}

module.exports = { detectClassType };
//