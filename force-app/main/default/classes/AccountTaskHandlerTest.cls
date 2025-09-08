@isTest
private class AccountTaskHandlerTest {
    
    @isTest static void testCrearTareasDeBienvenida() {
        // Create test accounts
        List<Account> cuentas = new List<Account>();
        cuentas.add(new Account(Name = 'Cuenta Test 1'));
        cuentas.add(new Account(Name = 'Cuenta Test 2'));
        insert cuentas;
        
        Test.startTest();
        AccountTaskHandler.crearTareasDeBienvenida(cuentas);
        Test.stopTest();
        
        // Verify tasks were created
        List<Task> tareasCreadas = [
            SELECT Id, WhatId, Subject, Description, Status, Priority
            FROM Task
            WHERE WhatId IN :cuentas
        ];
        
        System.assertEquals(2, tareasCreadas.size(), 'Should create one task per account');
        
        // Verify task details
        for (Task tarea : tareasCreadas) {
            System.assertEquals('Llamar al nuevo cliente 3', tarea.Subject, 'Task subject should be correct');
            System.assertEquals('Not Started', tarea.Status, 'Task status should be Not Started');
            System.assertEquals('Normal', tarea.Priority, 'Task priority should be Normal');
            System.assert(tarea.Description.contains('Realizar una llamada de bienvenida'), 'Description should contain welcome message');
            
            // Verify the task is associated with one of our accounts
            Boolean isAssociatedWithTestAccount = false;
            for (Account cuenta : cuentas) {
                if (tarea.WhatId == cuenta.Id) {
                    isAssociatedWithTestAccount = true;
                    System.assert(tarea.Description.contains(cuenta.Name), 'Description should contain account name');
                    break;
                }
            }
            System.assert(isAssociatedWithTestAccount, 'Task should be associated with a test account');
        }
    }
    
    @isTest static void testCrearTareasDeBienvenidaCuentaUnica() {
        // Test with single account
        List<Account> cuentas = new List<Account>();
        Account cuentaUnica = new Account(Name = 'Cuenta Única Test');
        cuentas.add(cuentaUnica);
        insert cuentas;
        
        Test.startTest();
        AccountTaskHandler.crearTareasDeBienvenida(cuentas);
        Test.stopTest();
        
        // Verify task was created
        List<Task> tareasCreadas = [
            SELECT Id, WhatId, Subject, Description
            FROM Task
            WHERE WhatId = :cuentaUnica.Id
        ];
        
        System.assertEquals(1, tareasCreadas.size(), 'Should create exactly one task');
        System.assertEquals(cuentaUnica.Id, tareasCreadas[0].WhatId, 'Task should be associated with the account');
        System.assert(tareasCreadas[0].Description.contains('Cuenta Única Test'), 'Description should contain account name');
    }
    
    @isTest static void testCrearTareasDeBienvenidaListaVacia() {
        // Test with empty list
        List<Account> cuentasVacias = new List<Account>();
        
        Test.startTest();
        AccountTaskHandler.crearTareasDeBienvenida(cuentasVacias);
        Test.stopTest();
        
        // Verify no tasks were created
        List<Task> tareasCreadas = [SELECT Id FROM Task];
        System.assertEquals(0, tareasCreadas.size(), 'Should not create any tasks for empty list');
    }
    
    @isTest static void testCrearTareasDeBienvenidaMultiplesCuentas() {
        // Test with multiple accounts
        List<Account> cuentas = new List<Account>();
        for (Integer i = 0; i < 5; i++) {
            cuentas.add(new Account(Name = 'Cuenta Test ' + i));
        }
        insert cuentas;
        
        Test.startTest();
        AccountTaskHandler.crearTareasDeBienvenida(cuentas);
        Test.stopTest();
        
        // Verify correct number of tasks
        List<Task> tareasCreadas = [
            SELECT Id, WhatId, Subject
            FROM Task
            WHERE WhatId IN :cuentas
        ];
        
        System.assertEquals(5, tareasCreadas.size(), 'Should create one task per account');
        
        // Verify each account has exactly one task
        Map<Id, Integer> tareasPorCuenta = new Map<Id, Integer>();
        for (Task tarea : tareasCreadas) {
            if (tareasPorCuenta.containsKey(tarea.WhatId)) {
                tareasPorCuenta.put(tarea.WhatId, tareasPorCuenta.get(tarea.WhatId) + 1);
            } else {
                tareasPorCuenta.put(tarea.WhatId, 1);
            }
        }
        
        for (Account cuenta : cuentas) {
            System.assertEquals(1, tareasPorCuenta.get(cuenta.Id), 'Each account should have exactly one task');
        }
    }
}