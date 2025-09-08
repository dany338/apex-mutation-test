const { execSync } = require("child_process");
const path = require("path");

const delay = (ms) => new Promise((res) => setTimeout(res, ms));

/**
 * 🔄 Retrieve desde Salesforce Org usando manifest
 */
async function runRetrieve() {
  console.log("📥 Ejecutando sf project retrieve con manifest/package.xml...");
  try {
    execSync("sf project retrieve start --manifest manifest/package.xml --wait 3", {
      stdio: "inherit",
    });
    console.log("✅ Retrieve completado.\n");
  } catch (err) {
    console.error("❌ Error en retrieve:", err.message);
  }
}

/**
 * 🚀 Despliega un archivo mutado usando source-dir
 * @param {string} filePath - Ruta completa del archivo .cls mutado
 */
async function runDeploy(filePath) {
  const className = path.basename(filePath, ".cls");
  console.log(`🚀 Realizando deploy de clase mutada: ${className}...`);

  try {
    const deployCommand = `sf project deploy start --source-dir ${filePath} --ignore-conflicts --wait 3`;
    execSync(deployCommand, { stdio: "inherit" });

    console.log("⏳ Esperando propagación de cambios en el Org...\n");
    await delay(4000); // tiempo de espera para evitar race conditions en Developer UI

    console.log("✅ Deploy exitoso.\n");
    return true;
  } catch (err) {
    console.error("❌ Error en deploy:", err.message);
    return false;
  }
}

/**
 * 🧪 Ejecuta pruebas esperadas definidas en el YAML
 * @param {string} className - Nombre de clase a testear
 * @param {string[]} expectedTests - Nombres de métodos de prueba relevantes
 */
function runTest(className, expectedTests = []) {
  console.log(`🧪 Ejecutando pruebas para clase: ${className}...`);

  try {
    const testCommand = `sf apex run test --tests ${expectedTests.join(",")} --json`;
    const output = execSync(testCommand).toString();
    const result = JSON.parse(output);

    const failures = result.result.tests.filter((t) => t.outcome === "Fail");

    return {
      passed: failures.length === 0,
      failures,
    };
  } catch (err) {
    console.error("❌ Error en ejecución de pruebas:", err.message);
    return {
      passed: false,
      failures: ["Error en ejecución"],
    };
  }
}

module.exports = {
  runRetrieve,
  runDeploy,
  runTest,
};
