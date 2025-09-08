# Mutation Testing for Apex - Guide and Implementation

## Overview / Resumen

This repository implements mutation testing for Apex code to validate the effectiveness of unit tests. Mutation testing introduces small changes (mutations) to source code and runs tests to see if they catch these changes. If tests pass with mutated code, it indicates weak test coverage.

Este repositorio implementa pruebas de mutación para código Apex para validar la efectividad de las pruebas unitarias. Las pruebas de mutación introducen pequeños cambios (mutaciones) al código fuente y ejecutan las pruebas para ver si detectan estos cambios. Si las pruebas pasan con código mutado, indica una cobertura de pruebas débil.

## Apex Types Covered / Tipos de Apex Cubiertos

### 1. Standard Classes (Clases Estándar)
- **DiscountCalculator**: Business logic with calculations
- **ContactValidator**: Data validation patterns
- **ContactAccountHandler**: Data association logic

### 2. Invocable Methods (Métodos Invocables)
- **ProductInvocableAction**: Flow integration patterns
- **FlowInvoker**: Flow execution patterns

### 3. Queueable Classes (Clases Queueable)
- **InsertarContactosQueueable**: Asynchronous processing patterns

### 4. Callout Classes (Clases de Callout)
- **PaisCallout**: External API integration patterns

## Mutation Strategies / Estrategias de Mutación

### Boundary Condition Mutations
- Change `>=` to `>` to test boundary conditions
- Cambiar `>=` a `>` para probar condiciones límite

### Calculation Logic Mutations
- Modify discount percentages (10% → 5%)
- Modificar porcentajes de descuento (10% → 5%)

### Null Safety Mutations
- Remove null checks to test null handling
- Remover verificaciones de null para probar manejo de null

### Logic Inversion Mutations
- Invert boolean conditions (`contains` → `!contains`)
- Invertir condiciones booleanas (`contains` → `!contains`)

### DML Operation Mutations
- Comment out or modify DML operations
- Comentar o modificar operaciones DML

### HTTP Method Mutations
- Change GET to POST in callouts
- Cambiar GET a POST en callouts

### Exception Handling Mutations
- Remove try-catch blocks
- Remover bloques try-catch

### SOQL Security Mutations
- Replace parameterized queries with string concatenation
- Reemplazar consultas parametrizadas con concatenación de strings

## How to Use / Cómo Usar

### 1. Run Basic Mutations / Ejecutar Mutaciones Básicas
```bash
node scripts/ai-agent/runMutationTests.js
```

### 2. Run Advanced Mutations / Ejecutar Mutaciones Avanzadas
```bash
node scripts/ai-agent/runMutationTests.js advanced-mutation-cases.yaml
```

### 3. Deploy and Test / Desplegar y Probar
1. Deploy mutated classes to your Salesforce org
2. Run the associated unit tests
3. Tests should FAIL if they are effective
4. If tests pass with mutated code, improve the tests

1. Despliega las clases mutadas a tu org de Salesforce
2. Ejecuta las pruebas unitarias asociadas
3. Las pruebas deberían FALLAR si son efectivas
4. Si las pruebas pasan con código mutado, mejora las pruebas

## Test Effectiveness Indicators / Indicadores de Efectividad de Pruebas

### Strong Tests (Pruebas Fuertes) ✅
- Tests fail when mutation is introduced
- Las pruebas fallan cuando se introduce la mutación

### Weak Tests (Pruebas Débiles) ❌
- Tests pass even with mutated code
- Las pruebas pasan incluso con código mutado

## Common Mutation Patterns / Patrones Comunes de Mutación

### 1. Comparison Operators / Operadores de Comparación
```apex
// Original
if (amount >= 1000)
// Mutated
if (amount > 1000)
```

### 2. Mathematical Operations / Operaciones Matemáticas
```apex
// Original
return amount * 0.1;
// Mutated
return amount * 0.05;
```

### 3. Null Checks / Verificaciones de Null
```apex
// Original
if (email != null)
// Mutated
if (true)
```

### 4. Boolean Logic / Lógica Booleana
```apex
// Original
if (map.containsKey(key))
// Mutated
if (!map.containsKey(key))
```

### 5. DML Operations / Operaciones DML
```apex
// Original
insert contacts;
// Mutated
// insert contacts; // Commented out
```

## Expected Test Failures / Fallos de Prueba Esperados

Each mutation specifies which tests should fail:

| Mutation | Expected Failing Test |
|----------|----------------------|
| DiscountCalculator boundary | `testDiscountExactlyThreshold` |
| DiscountCalculator percentage | `testDiscountOverThreshold` |
| ContactValidator null check | `testEvitarDuplicadosPorEmailConNull` |
| ContactValidator logic | `testEvitarDuplicadosPorEmail` |
| Queueable DML | `testInsertarContactosQueueable` |
| Callout HTTP method | `testLlamadaAPais` |
| Account association | `testAsociarContactoConCuenta` |

## Report Analysis / Análisis de Reportes

The mutation report (`mutation-report.json`) contains:
- Total mutations attempted
- Successful vs failed mutations  
- Types of Apex classes covered
- Expected failing tests

El reporte de mutación (`mutation-report.json`) contiene:
- Total de mutaciones intentadas
- Mutaciones exitosas vs fallidas
- Tipos de clases Apex cubiertas
- Pruebas que deberían fallar

## Best Practices / Mejores Prácticas

1. **Start with Critical Business Logic** / Comenzar con Lógica de Negocio Crítica
2. **Test Boundary Conditions** / Probar Condiciones Límite
3. **Verify Exception Handling** / Verificar Manejo de Excepciones
4. **Check Null Safety** / Verificar Seguridad de Null
5. **Validate Security Patterns** / Validar Patrones de Seguridad

## Files Structure / Estructura de Archivos

```
├── mutation-test-cases.yaml          # Basic mutations
├── advanced-mutation-cases.yaml      # Advanced patterns
├── scripts/ai-agent/
│   ├── runMutationTests.js           # Main execution script
│   ├── advancedMutationWriter.js     # Mutation application logic
│   └── parseYamlMutations.js         # YAML parsing
├── mutations/                        # Generated mutated files
└── force-app/main/default/classes/   # Original and test classes
```

## Contributing / Contribuciones

To add new mutation patterns:
1. Create new YAML definitions
2. Ensure corresponding test methods exist
3. Run mutations and verify test failures
4. Document expected behaviors

Para agregar nuevos patrones de mutación:
1. Crear nuevas definiciones YAML
2. Asegurar que existan métodos de prueba correspondientes
3. Ejecutar mutaciones y verificar fallos de prueba
4. Documentar comportamientos esperados