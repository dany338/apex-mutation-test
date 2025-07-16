@isTest
public class FlowInvokerTest {
    static void testFlowInvocadoConAccount() {
        // Crear cuenta de prueba
        Account cuenta = new Account(Name = 'Cuenta Test');
        insert cuenta;

        // Ejecutar el Flow
        Test.startTest();
        FlowInvoker.invocarFlowConAccountId(cuenta.Id);
        Test.stopTest();

        // Validar que se creó la tarea correctamente
        List<Task> tareas = [SELECT Subject, WhatId FROM Task WHERE WhatId = :cuenta.Id];
        System.debug('▶ TAREAS ENCONTRADAS: ' + tareas);

        Boolean tareaEncontrada = false;
        for (Task t : tareas) {
            System.debug('✔ Tarea Subject: ' + t.Subject);
            if (t.Subject == 'Tarea creada automáticamente para la cuenta') {
                tareaEncontrada = true;
                break;
            }
        }

        System.assert(tareaEncontrada, 'No se encontró una tarea con el asunto esperado.');
    }
}