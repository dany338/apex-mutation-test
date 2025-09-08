@isTest
private class InsertarContactosQueueableTest {
    
    @isTest 
    static void testInsertarContactosQueueable() {
        // Crear lista de contactos de prueba
        List<Contact> contactos = new List<Contact>();
        for (Integer i = 0; i < 3; i++) {
            contactos.add(new Contact(
                FirstName = 'Test' + i,
                LastName = 'Queueable' + i,
                Email = 'test' + i + '@queueable.com'
            ));
        }
        
        Test.startTest();
        // Ejecutar el queueable job
        InsertarContactosQueueable job = new InsertarContactosQueueable(contactos);
        System.enqueueJob(job);
        Test.stopTest();
        
        // Verificar que los contactos fueron insertados
        List<Contact> contactosInsertados = [
            SELECT Id, FirstName, LastName, Email 
            FROM Contact 
            WHERE Email LIKE '%@queueable.com'
        ];
        
        System.assertEquals(3, contactosInsertados.size(), 'Deben haberse insertado 3 contactos');
        
        // Verificar que los datos son correctos
        Set<String> expectedEmails = new Set<String>{'test0@queueable.com', 'test1@queueable.com', 'test2@queueable.com'};
        Set<String> actualEmails = new Set<String>();
        
        for (Contact c : contactosInsertados) {
            actualEmails.add(c.Email);
        }
        
        System.assertEquals(expectedEmails, actualEmails, 'Los emails deben coincidir');
    }
    
    @isTest 
    static void testInsertarContactosQueueableConError() {
        // Crear contacto con datos inválidos para provocar error
        List<Contact> contactos = new List<Contact>();
        Contact contactoInvalido = new Contact(
            // LastName es requerido pero lo omitimos para causar error
            FirstName = 'Test',
            Email = 'test@error.com'
        );
        contactos.add(contactoInvalido);
        
        Test.startTest();
        // Ejecutar el queueable job - debería manejar el error gracefully
        InsertarContactosQueueable job = new InsertarContactosQueueable(contactos);
        System.enqueueJob(job);
        Test.stopTest();
        
        // Verificar que no se insertó ningún contacto debido al error
        List<Contact> contactosInsertados = [
            SELECT Id FROM Contact WHERE Email = 'test@error.com'
        ];
        
        System.assertEquals(0, contactosInsertados.size(), 'No debe haberse insertado el contacto inválido');
    }
}