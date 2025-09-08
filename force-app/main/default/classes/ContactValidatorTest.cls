@isTest
private class ContactValidatorTest {
    
    @isTest 
    static void testEvitarDuplicadosPorEmail() {
        // Crear un contacto existente
        Contact existingContact = new Contact(
            FirstName = 'Juan',
            LastName = 'Existente',
            Email = 'juan@test.com'
        );
        insert existingContact;
        
        // Intentar crear un contacto nuevo con el mismo email
        Contact newContact = new Contact(
            FirstName = 'Pedro',
            LastName = 'Nuevo',
            Email = 'juan@test.com'
        );
        
        Test.startTest();
        try {
            ContactValidator.evitarDuplicadosPorEmail(new List<Contact>{newContact});
            insert newContact;
            System.assert(false, 'Debería haber fallado por email duplicado');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Ya existe un contacto'), 'Mensaje de error esperado');
        }
        Test.stopTest();
    }
    
    @isTest 
    static void testEvitarDuplicadosPorEmailConNull() {
        // Crear contacto con email null - no debe causar errores
        Contact contactWithNullEmail = new Contact(
            FirstName = 'Sin',
            LastName = 'Email',
            Email = null
        );
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(new List<Contact>{contactWithNullEmail});
        insert contactWithNullEmail;
        Test.stopTest();
        
        // Verificar que se insertó correctamente
        Contact inserted = [SELECT Id, Email FROM Contact WHERE Id = :contactWithNullEmail.Id];
        System.assertEquals(null, inserted.Email, 'Email debe ser null');
    }
    
    @isTest 
    static void testEvitarDuplicadosEmailDiferentesMinusculas() {
        // Crear contacto con email en mayúsculas
        Contact existingContact = new Contact(
            FirstName = 'Ana',
            LastName = 'Existente', 
            Email = 'ANA@TEST.COM'
        );
        insert existingContact;
        
        // Intentar crear contacto con mismo email en minúsculas
        Contact newContact = new Contact(
            FirstName = 'Maria',
            LastName = 'Nueva',
            Email = 'ana@test.com'
        );
        
        Test.startTest();
        try {
            ContactValidator.evitarDuplicadosPorEmail(new List<Contact>{newContact});
            insert newContact;
            System.assert(false, 'Debería detectar duplicado independiente de mayúsculas/minúsculas');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Ya existe un contacto'), 'Mensaje de error esperado');
        }
        Test.stopTest();
    }
    
    @isTest 
    static void testEvitarDuplicadosPorEmailVariosContactos() {
        // Crear varios contactos con diferentes escenarios
        List<Contact> contactosNuevos = new List<Contact>();
        
        // Contacto válido
        contactosNuevos.add(new Contact(
            FirstName = 'Valid',
            LastName = 'Contact',
            Email = 'valid@test.com'
        ));
        
        // Contacto con email null
        contactosNuevos.add(new Contact(
            FirstName = 'Null',
            LastName = 'Email',
            Email = null
        ));
        
        // Otro contacto válido
        contactosNuevos.add(new Contact(
            FirstName = 'Another',
            LastName = 'Valid',
            Email = 'another@test.com'
        ));
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(contactosNuevos);
        insert contactosNuevos;
        Test.stopTest();
        
        // Verificar que todos los contactos válidos se insertaron
        List<Contact> insertedContacts = [
            SELECT Id, Email FROM Contact 
            WHERE Email IN ('valid@test.com', 'another@test.com') OR Email = null
        ];
        
        System.assertEquals(3, insertedContacts.size(), 'Todos los contactos deberían haberse insertado');
    }
}