const fs = require('fs-extra');
const path = require('path');
const simpleGit = require('simple-git');

const REPO_ROOT = path.join(__dirname, '..', '..'); // Asume raíz del proyecto
const OUTPUT_DIR = path.join(REPO_ROOT, 'openai/output');
const DEFAULT_SOURCE_DIR = path.resolve(__dirname, '../../force-app/main/default/');

// 🔍 Detecta tipo de clase Apex por su contenido
function apexTypeFromContent(filePath, content) {
  const ext = path.extname(filePath);
  const lower = content.toLowerCase();

  if (ext === '.trigger') return 'trigger';
  if (lower.includes('implements database.batchable')) return 'batch';
  if (lower.includes('implements queueable')) return 'queueable';
  if (lower.includes('implements schedulable')) return 'schedulable';
  if (lower.includes('@invocablemethod')) return 'invocable';
  if (lower.includes('extends') && lower.includes('controller')) return 'controller';
  if (lower.includes('@istest') || lower.includes('testmethod') || /class\s+\w*test\b/i.test(content)) return 'test';

  return 'standard';
};

// 🧠 Usa git diff para detectar archivos modificados en la rama actual vs origin/main
async function getModifiedApexFilesFromGit(sourceDir = DEFAULT_SOURCE_DIR) {
  const git = simpleGit(REPO_ROOT);
  const diff = await git.diff(['--name-only', 'origin/main']);

  const files = diff
    .split('\n')
    .filter(f => f.includes(sourceDir) && (f.endsWith('.cls') || f.endsWith('.trigger')))
    .map(f => path.join(REPO_ROOT, f));

  return files;
}

// 📁 Escaneo recursivo sin Git
function getAllApexFilesFromDisk(sourceDir = DEFAULT_SOURCE_DIR) {
  const base = path.join(REPO_ROOT, sourceDir);
  const results = [];

  function walk(dir) {
    const entries = fs.readdirSync(dir);
    for (const entry of entries) {
      const fullPath = path.join(dir, entry);
      const stat = fs.statSync(fullPath);

      if (stat.isDirectory()) {
        walk(fullPath);
      } else if (entry.endsWith('.cls') || entry.endsWith('.trigger')) {
        results.push(fullPath);
      }
    }
  }

  walk(base);
  return results;
}

// 🚀 Proceso general: detecta tipo + carga prompt si existe
async function processFiles({ useGitDiff = false }) {
  const files = useGitDiff
    ? await getModifiedApexFilesFromGit()
    : getAllApexFilesFromDisk();

  const results = [];

  for (const filePath of files) {
    const content = await fs.readFile(filePath, 'utf8');
    const type = apexTypeFromContent(filePath, content);

    const promptPath = path.join(OUTPUT_DIR, `${type}.prompt.txt`);
    const promptExists = await fs.pathExists(promptPath);

    if (!promptExists) {
      console.warn(`⚠️  No prompt found for ${type} (${filePath})`);
      continue;
    }

    const prompt = await fs.readFile(promptPath, 'utf8');
    results.push({ filePath, type, prompt });
  }

  return results;
}

module.exports = {
  processFiles,
  apexTypeFromContent,
  getModifiedApexFilesFromGit,
  getAllApexFilesFromDisk
};
