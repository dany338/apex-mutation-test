# Análisis de Metadatos del Proyecto apex-mutation-test

## Resumen del Proyecto
Este es un proyecto de **Salesforce DX** enfocado en testing de Apex con capacidades de mutation testing. El proyecto utiliza múltiples tipos de metadatos para configurar el desarrollo, testing y despliegue.

## 1. Metadatos de Salesforce DX

### sfdx-project.json
```json
{
  "packageDirectories": [
    {
      "path": "force-app",
      "default": true
    }
  ],
  "name": "apex-mutation-test",
  "namespace": "",
  "sfdcLoginUrl": "https://login.salesforce.com",
  "sourceApiVersion": "64.0"
}
```

**Metadata utilizado:**
- **Nombre del proyecto**: `apex-mutation-test`
- **API Version**: `64.0` (Winter '25)
- **Directorio fuente**: `force-app`
- **URL de login**: Salesforce production/developer org
- **Namespace**: Vacío (sin namespace)

## 2. Metadatos de Node.js y Herramientas de Desarrollo

### package.json
**Información del proyecto:**
- **Nombre**: `salesforce-app`
- **Versión**: `1.0.0`
- **Descripción**: `Salesforce App`
- **Tipo**: Proyecto privado

**Scripts de testing configurados:**
- `test:unit`: Testing unitario con sfdx-lwc-jest
- `test:unit:watch`: Modo watch para testing
- `test:unit:debug`: Modo debug para testing
- `test:unit:coverage`: Reporte de cobertura

**Herramientas de calidad de código:**
- **ESLint**: Linting para JavaScript/LWC
- **Prettier**: Formateo automático de código
- **Husky**: Git hooks para pre-commit
- **lint-staged**: Linting en archivos staged

## 3. Metadatos de Salesforce (Apex/Triggers)

### Archivos .cls-meta.xml y .trigger-meta.xml
```xml
<?xml version="1.0" encoding="UTF-8"?>
<ApexClass xmlns="http://soap.sforce.com/2006/04/metadata">
    <apiVersion>64.0</apiVersion>
    <status>Active</status>
</ApexClass>
```

**Estructura de metadatos Apex:**
- **API Version**: 64.0 (consistente en todo el proyecto)
- **Status**: Active (todas las clases están activas)
- **Namespace XML**: `http://soap.sforce.com/2006/04/metadata`

## 4. Configuración de Testing

### jest.config.js
```javascript
const { jestConfig } = require('@salesforce/sfdx-lwc-jest/config');

module.exports = {
    ...jestConfig,
    modulePathIgnorePatterns: ['<rootDir>/.localdevserver']
};
```

**Configuración de testing:**
- **Framework**: Jest con configuración de Salesforce LWC
- **Ignora**: Directorio `.localdevserver`
- **Basado en**: `@salesforce/sfdx-lwc-jest`

## 5. Configuración de Formateo (Prettier)

### .prettierrc
```json
{
  "trailingComma": "none",
  "plugins": [
    "prettier-plugin-apex",
    "@prettier/plugin-xml"
  ],
  "overrides": [
    {
      "files": "**/lwc/**/*.html",
      "options": { "parser": "lwc" }
    },
    {
      "files": "*.{cmp,page,component}",
      "options": { "parser": "html" }
    }
  ]
}
```

**Configuración de formateo:**
- **Plugin Apex**: Soporte para formateo de código Apex
- **Plugin XML**: Soporte para formateo de XML/metadatos
- **Parser LWC**: Configuración específica para Lightning Web Components
- **Parser HTML**: Para componentes Aura

## 6. Configuración de VS Code

### .vscode/extensions.json
**Extensiones recomendadas:**
- `salesforce.salesforcedx-vscode`: Suite de herramientas de Salesforce
- `redhat.vscode-xml`: Soporte para XML
- `dbaeumer.vscode-eslint`: ESLint
- `esbenp.prettier-vscode`: Prettier
- `financialforce.lana`: Herramienta adicional de análisis

### .vscode/launch.json
**Configuración de debugging:**
- **Apex Replay Debugger**: Configurado para debugging de Apex logs
- **Trace habilitado**: Para análisis detallado

### .vscode/settings.json
**Configuración del workspace:**
- **Exclusiones de búsqueda**: node_modules, bower_components, .sfdx

## 7. Control de Versiones

### .gitignore
**Archivos ignorados:**
- Caché de Salesforce (`.sf/`, `.sfdx/`, `.localdevserver/`)
- Configuraciones LWC (`**/lwc/jsconfig.json`)
- Reportes de cobertura (`coverage/`)
- Dependencias (`node_modules/`)
- Archivos de sistema (`.DS_Store`, `Thumbs.db`)

### .forceignore
**Archivos ignorados en operaciones de Salesforce:**
- `package.xml`
- Configuraciones LWC (`**/jsconfig.json`, `**/.eslintrc.json`)
- Tests LWC (`**/__tests__/**`)

## 8. Git Hooks (Husky)

### .husky/pre-commit
```bash
#!/bin/sh
. "$(dirname "$0")/_/husky.sh"

npm run precommit
```

**Configuración de pre-commit:**
- Ejecuta `npm run precommit` antes de cada commit
- Utiliza `lint-staged` para procesar archivos

## 9. Resultados de Testing

### Directorio testResults/
**Metadatos de resultados:**
- **Formato JSON**: Resultados detallados de tests
- **Formato JUnit XML**: Compatible con CI/CD pipelines
- **IDs de test**: Formato Salesforce (707gK000008...)

## 10. Dependencias del Proyecto

### DevDependencies principales:
- **@salesforce/sfdx-lwc-jest**: Framework de testing para LWC
- **@salesforce/eslint-config-lwc**: Configuración ESLint para LWC
- **prettier-plugin-apex**: Plugin Prettier para Apex
- **husky**: Git hooks
- **lint-staged**: Procesamiento de archivos staged

## Conclusiones

Este proyecto utiliza un stack completo de metadatos moderno para desarrollo Salesforce:

1. **Metadatos nativos de Salesforce**: API 64.0, configuración DX estándar
2. **Herramientas de calidad**: ESLint, Prettier, Jest
3. **Automatización**: Husky para git hooks, lint-staged
4. **IDE Integration**: Configuración completa para VS Code
5. **Testing**: Framework Jest adaptado para Salesforce LWC
6. **CI/CD Ready**: Configuración compatible con pipelines de integración continua

El proyecto está configurado para seguir las mejores prácticas de desarrollo moderno en el ecosistema Salesforce.