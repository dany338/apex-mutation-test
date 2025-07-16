public class AccountTaskHandler {
    public static void crearTareasDeBienvenida(List<Account> cuentas) {
        List<Task> tareas = new List<Task>();

        for (Account acc : cuentas) {
            Task nuevaTarea = new Task(
                WhatId = acc.Id, // Asocia la tarea a la cuenta
                Subject = 'Llamar al nuevo cliente 3',
                Description = 'Realizar una llamada de bienvenida a la nueva cuenta: ' + acc.Name,
                Status = 'Not Started',
                Priority = 'Normal'
            );
            tareas.add(nuevaTarea);
        }

        if (!tareas.isEmpty()) {
            insert tareas;
        }
    }
}