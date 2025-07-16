@isTest
private class AccountTaskHandlerTest {
    @isTest static void testCreacionTareaEnCuenta() {
        // Crear una nueva cuenta
        Account cuenta = new Account(Name = 'Prueba Trigger Cuenta');
        insert cuenta;

        // Verificar que se haya creado una tarea asociada
        List<Task> tareas = [
            SELECT Id, WhatId, Subject
            FROM Task
            WHERE WhatId = :cuenta.Id
        ];

        System.assertEquals(1, tareas.size(), 'Debe haberse creado una tarea');
        System.assertEquals('Llamar al nuevo cliente 3', tareas[0].Subject);
    }
}