@isTest
private class ContactHandlerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create the generic account that ContactHandler expects
        Account cuentaGenerica = new Account(Name='Sin cuenta');
        insert cuentaGenerica;
    }
    
    @isTest static void testAsignarCuentaGenericaConContactoSinCuenta() {
        // Test the actual asignarCuentaGenerica method
        List<Contact> contactos = new List<Contact>();
        Contact contactoSinCuenta = new Contact(
            FirstName = 'Juan',
            LastName = 'Pérez',
            Email = 'juan.perez@test.com'
            // AccountId is null by default
        );
        contactos.add(contactoSinCuenta);
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactos);
        Test.stopTest();
        
        // Verify the generic account was assigned
        Account cuentaGenerica = [SELECT Id FROM Account WHERE Name = 'Sin cuenta' LIMIT 1];
        System.assertEquals(cuentaGenerica.Id, contactoSinCuenta.AccountId, 'Contact should be assigned to generic account');
    }
    
    @isTest static void testAsignarCuentaGenericaConContactoConCuenta() {
        // Test with contact that already has an account
        Account cuentaExistente = new Account(Name = 'Cuenta Existente');
        insert cuentaExistente;
        
        List<Contact> contactos = new List<Contact>();
        Contact contactoConCuenta = new Contact(
            FirstName = 'María',
            LastName = 'González',
            Email = 'maria.gonzalez@test.com',
            AccountId = cuentaExistente.Id
        );
        contactos.add(contactoConCuenta);
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactos);
        Test.stopTest();
        
        // Verify the existing account was not changed
        System.assertEquals(cuentaExistente.Id, contactoConCuenta.AccountId, 'Contact should keep existing account');
    }
    
    @isTest static void testAsignarCuentaGenericaConListaMixta() {
        // Test with mixed list of contacts
        Account cuentaExistente = new Account(Name = 'Cuenta Específica');
        insert cuentaExistente;
        
        List<Contact> contactos = new List<Contact>();
        
        // Contact without account
        Contact contactoSinCuenta = new Contact(
            FirstName = 'Ana',
            LastName = 'López',
            Email = 'ana.lopez@test.com'
        );
        contactos.add(contactoSinCuenta);
        
        // Contact with existing account
        Contact contactoConCuenta = new Contact(
            FirstName = 'Carlos',
            LastName = 'Martín',
            Email = 'carlos.martin@test.com',
            AccountId = cuentaExistente.Id
        );
        contactos.add(contactoConCuenta);
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactos);
        Test.stopTest();
        
        // Verify results
        Account cuentaGenerica = [SELECT Id FROM Account WHERE Name = 'Sin cuenta' LIMIT 1];
        System.assertEquals(cuentaGenerica.Id, contactoSinCuenta.AccountId, 'Contact without account should be assigned generic account');
        System.assertEquals(cuentaExistente.Id, contactoConCuenta.AccountId, 'Contact with account should keep existing account');
    }
    
    @isTest static void testAsignarCuentaGenericaConListaVacia() {
        // Test with empty list
        List<Contact> contactosVacios = new List<Contact>();
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactosVacios);
        Test.stopTest();
        
        // Should not throw exception
        System.assert(true, 'Method should handle empty list without errors');
    }
    
    @isTest static void testAsignarCuentaGenericaConListaNull() {
        // Test with null list
        List<Contact> contactosNull = null;
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactosNull);
        Test.stopTest();
        
        // Should not throw exception
        System.assert(true, 'Method should handle null list without errors');
    }
    
    @isTest static void testAsignarCuentaGenericaCreaAccountSiNoExiste() {
        // Delete the existing generic account to test creation
        delete [SELECT Id FROM Account WHERE Name = 'Sin cuenta'];
        
        List<Contact> contactos = new List<Contact>();
        Contact contactoSinCuenta = new Contact(
            FirstName = 'Pedro',
            LastName = 'Ramírez',
            Email = 'pedro.ramirez@test.com'
        );
        contactos.add(contactoSinCuenta);
        
        Test.startTest();
        ContactHandler.asignarCuentaGenerica(contactos);
        Test.stopTest();
        
        // Verify the generic account was created and assigned
        List<Account> cuentasGenericas = [SELECT Id FROM Account WHERE Name = 'Sin cuenta'];
        System.assertEquals(1, cuentasGenericas.size(), 'Generic account should be created');
        System.assertEquals(cuentasGenericas[0].Id, contactoSinCuenta.AccountId, 'Contact should be assigned to newly created generic account');
    }
}