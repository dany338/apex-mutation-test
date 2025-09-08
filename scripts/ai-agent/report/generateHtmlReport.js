// scripts/ai-agent/report/generateHtmlReport.js

const fs = require('fs');
const path = require('path');
const dayjs = require('dayjs');

function generateHtmlFromJson(mutations) {
  const today = dayjs().format('YYYY-MM-DD');
  const outputPath = path.join(__dirname, '..', '..', '..', 'mutations', today, 'mutation-report-auto.html');

  const htmlStart = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Mutation Report - ${today}</title>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #f5f6f7;
      color: #333;
      margin: 0;
      padding: 1rem;
    }
    header {
      background: linear-gradient(90deg, #0061a8, #00c0ff);
      padding: 1rem;
      color: white;
      text-align: center;
      border-radius: 8px;
      margin-bottom: 1.5rem;
    }
    h1 {
      margin: 0;
      font-size: 1.5rem;
    }
    .mutation {
      background: white;
      border-radius: 10px;
      padding: 1rem;
      box-shadow: 0 4px 6px rgba(0,0,0,0.05);
      margin-bottom: 1rem;
    }
    .mutation h2 {
      margin-top: 0;
    }
    .tag {
      display: inline-block;
      padding: 0.2rem 0.5rem;
      margin-right: 0.5rem;
      border-radius: 4px;
      background-color: #e8f0fe;
      color: #1967d2;
      font-size: 0.85rem;
    }
    .status-pass {
      background-color: #e6ffed;
      color: #0f5132;
    }
    .status-fail {
      background-color: #fff3cd;
      color: #664d03;
    }
  </style>
</head>
<body>
  <header>
    <h1>📊 Mutation Report – ${today}</h1>
    <p>Resumen visual de mutaciones ejecutadas con agente AI</p>
  </header>
`;

  const htmlMutations = mutations.map((m, i) => {
    const statusClass = m.status.includes("Failed") ? "status-fail" : "status-pass";
    return `
  <div class="mutation">
    <h2>💥 Mutation ${m.mutation_id} – ${m.class}</h2>
    <p>
      <span class="tag">Type: ${m.type}</span>
      <span class="tag">Line: ${m.affected_line}</span>
      <span class="tag">Mutation: ${m.mutation_type}</span>
    </p>
    <p>🧠 <strong>Impact:</strong> ${m.impact}</p>
    <p class="tag ${statusClass}">${m.status}</p>
  </div>`;
  }).join("\n");

  const htmlEnd = "</body>\n</html>";
  const finalHtml = htmlStart + htmlMutations + htmlEnd;

  fs.writeFileSync(outputPath, finalHtml);
  console.log("✅ HTML report generado en:", outputPath);
}

module.exports = { generateHtmlFromJson };
