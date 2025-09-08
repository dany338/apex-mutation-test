# Apex Mutation Testing Project

This Salesforce DX project implements comprehensive mutation testing for Apex code to validate the effectiveness of unit tests.

## 🔬 Mutation Testing Overview

Mutation testing introduces small changes (mutations) to source code and runs tests to verify if they catch these changes. If tests pass with mutated code, it indicates weak test coverage that needs improvement.

### Supported Apex Types
- **Standard Classes**: Business logic, data validation, calculations
- **Invocable Methods**: Flow integration and custom actions  
- **Queueable Classes**: Asynchronous processing
- **Callout Classes**: External API integrations
- **Trigger Handlers**: DML event processing

## 🧪 Quick Start

### Run Mutation Tests
```bash
# Run basic mutations
npm run mutation:basic

# Run advanced pattern mutations  
npm run mutation:advanced

# Run all mutation test suites
npm run mutation:all
```

### Manual Execution
```bash
# Basic mutations
node scripts/ai-agent/runMutationTests.js

# Advanced mutations
node scripts/ai-agent/runMutationTests.js advanced-mutation-cases.yaml

# All mutations
node scripts/ai-agent/runAllMutations.js
```

## 📋 Available Mutations

### Basic Mutations (`mutation-test-cases.yaml`)
- Boundary condition changes (`>=` → `>`)
- Calculation logic alterations (10% → 5% discount)
- Null safety removals
- Boolean logic inversions
- DML operation removals
- HTTP method changes

### Advanced Mutations (`advanced-mutation-cases.yaml`)
- Exception handling bypass
- SOQL injection vulnerabilities
- Governor limits violations
- Null pointer exceptions
- Security context changes
- Asynchronous execution errors

## 🎯 Test Classes Included

| Test Class | Coverage |
|------------|----------|
| `DiscountCalculatorTest` | Calculation logic, boundary conditions |
| `ContactValidatorTest` | Data validation, duplicate detection |
| `ContactAccountHandlerTest` | Association logic, null handling |
| `InsertarContactosQueueableTest` | Async processing, error handling |
| `ProductInvocableActionTest` | Flow integration, data flow |
| `PaisCalloutTest` | API integration, HTTP methods |

## 📊 Mutation Results

After running mutations, check the generated reports:
- `mutations/YYYY-MM-DD/basic/mutation-report.json`
- `mutations/YYYY-MM-DD/advanced/mutation-report.json`  
- `mutations/YYYY-MM-DD/consolidated-mutation-report.json`

### Expected Outcomes
- **Effective Tests**: Tests FAIL when mutations are introduced ✅
- **Weak Tests**: Tests PASS with mutated code ❌ (needs improvement)

## 🚀 Testing Process

1. **Generate Mutations**: Run mutation scripts to create modified classes
2. **Deploy Mutated Code**: Deploy generated `.cls` files to your Salesforce org
3. **Execute Tests**: Run the corresponding unit tests
4. **Analyze Results**: Tests should fail if they effectively validate the code
5. **Improve Coverage**: Enhance tests that pass with mutated code

## 📁 Project Structure

```
├── force-app/main/default/classes/     # Apex classes and tests
├── mutation-test-cases.yaml           # Basic mutation definitions
├── advanced-mutation-cases.yaml       # Advanced pattern mutations
├── scripts/ai-agent/                  # Mutation execution scripts
├── mutations/                         # Generated mutated files
└── MUTATION_TESTING_GUIDE.md         # Detailed documentation
```

## 🛠 Development Commands

```bash
# Install dependencies
npm install

# Format code
npm run prettier

# Lint code  
npm run lint

# Run mutation tests
npm run mutation:all
```

## 📚 Resources

- [Mutation Testing Guide](./MUTATION_TESTING_GUIDE.md) - Comprehensive documentation
- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)

## 🤝 Contributing

1. Add new mutation patterns in YAML files
2. Create corresponding test methods
3. Run mutations to verify effectiveness
4. Document expected behaviors and outcomes

---

# Original Salesforce DX Project: Next Steps

Now that you've created a Salesforce DX project, what's next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)