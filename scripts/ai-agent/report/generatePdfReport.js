// scripts/ai-agent/report/generatePdfReport.js

const fs = require('fs');
const path = require('path');
const dayjs = require('dayjs');
const puppeteer = require('puppeteer');

async function generatePdfFromHtml() {
  const today = dayjs().format('YYYY-MM-DD');
  const basePath = path.join(__dirname, '..', '..', '..', 'mutations', today);
  const htmlFile = path.join(basePath, 'mutation-report-auto.html');
  const pdfFile = path.join(basePath, 'mutation-report.pdf');

  if (!fs.existsSync(htmlFile)) {
    console.error('❌ HTML file not found:', htmlFile);
    return;
  }

  const browser = await puppeteer.launch({ headless: 'new' });
  const page = await browser.newPage();
  await page.goto('file://' + htmlFile, { waitUntil: 'networkidle0' });
  await page.pdf({
    path: pdfFile,
    format: 'A4',
    printBackground: true,
    margin: { top: '1cm', bottom: '1cm', left: '1cm', right: '1cm' },
  });
  await browser.close();

  console.log('✅ PDF generado en:', pdfFile);
}

module.exports = { generatePdfFromHtml };
