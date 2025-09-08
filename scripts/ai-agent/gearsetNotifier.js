// scripts/ai-agent/gearsetNotifier.js

const fetch = require('node-fetch');
const fs = require('fs');
const path = require('path');

/**
 * Envia resultados al Webhook de Gearset (modo POST)
 * @param {Object} data 
 * @param {string} data.prId
 * @param {string} data.status - "PASSED" | "FAILED"
 * @param {string} data.summary - Texto resumido
 * @param {string} data.badge - Emoji y mensaje breve
 */
async function notifyGearset({ prId, status, summary, badge }) {
  const payload = {
    pr_id: prId,
    status,
    summary,
    badge
  };

  try {
    const response = await fetch('https://gearset-api.kaseya.internal/hooks/ai', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const responseBody = await response.text();
    const log = {
      timestamp: new Date().toISOString(),
      request: payload,
      responseStatus: response.status,
      responseBody
    };

    // 🖨️ Mostrar por consola
    console.log('📤 Webhook enviado a Gearset.');
    console.log('🔁 Respuesta Gearset:', response.status, responseBody);

    // 📝 Guardar log en /logs/gearset-log.json
    const logPath = path.join(__dirname, '..', '..', 'logs', 'gearset-log.json');
    fs.appendFileSync(logPath, JSON.stringify(log, null, 2) + ',\n');
  } catch (err) {
    console.error('❌ Error enviando webhook a Gearset:', err.message);
  }
}

module.exports = { notifyGearset };
