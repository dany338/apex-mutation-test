@isTest
private class ContactValidatorTest {
    
    @TestSetup
    static void setupTestData() {
        // Create existing contacts
        Contact existingContact = new Contact(
            FirstName = 'Existing',
            LastName = 'Contact',
            Email = 'existing@test.com'
        );
        insert existingContact;
    }
    
    @isTest static void testEvitarDuplicadosPorEmailConEmailExistente() {
        // Test preventing duplicate email
        List<Contact> nuevosContactos = new List<Contact>();
        Contact duplicateContact = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = 'existing@test.com' // Same email as existing contact
        );
        nuevosContactos.add(duplicateContact);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify error was added
        System.assert(duplicateContact.hasErrors(), 'Contact should have error for duplicate email');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailConEmailNuevo() {
        // Test allowing new email
        List<Contact> nuevosContactos = new List<Contact>();
        Contact newContact = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = 'new@test.com' // New email
        );
        nuevosContactos.add(newContact);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify no error was added
        System.assert(!newContact.hasErrors(), 'Contact should not have error for new email');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailCaseSensitive() {
        // Test case insensitive email comparison
        List<Contact> nuevosContactos = new List<Contact>();
        Contact duplicateContact = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = 'EXISTING@TEST.COM' // Same email but different case
        );
        nuevosContactos.add(duplicateContact);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify error was added (should be case insensitive)
        System.assert(duplicateContact.hasErrors(), 'Contact should have error for duplicate email regardless of case');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailConEmailNull() {
        // Test with null email
        List<Contact> nuevosContactos = new List<Contact>();
        Contact contactWithoutEmail = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = null
        );
        nuevosContactos.add(contactWithoutEmail);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify no error was added (null emails should be allowed)
        System.assert(!contactWithoutEmail.hasErrors(), 'Contact with null email should not have error');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailListaVacia() {
        // Test with empty list
        List<Contact> nuevosContactos = new List<Contact>();
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Should not throw exception with empty list
        System.assert(true, 'Method should handle empty list without errors');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailMultiplesContactos() {
        // Test with multiple contacts
        List<Contact> nuevosContactos = new List<Contact>();
        
        // Valid contact
        Contact validContact = new Contact(
            FirstName = 'Valid',
            LastName = 'Contact',
            Email = 'valid@test.com'
        );
        nuevosContactos.add(validContact);
        
        // Duplicate contact
        Contact duplicateContact = new Contact(
            FirstName = 'Duplicate',
            LastName = 'Contact',
            Email = 'existing@test.com'
        );
        nuevosContactos.add(duplicateContact);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify only duplicate has error
        System.assert(!validContact.hasErrors(), 'Valid contact should not have error');
        System.assert(duplicateContact.hasErrors(), 'Duplicate contact should have error');
    }
    
    @isTest static void testEvitarDuplicadosPorEmailConEmailVacio() {
        // Test with empty email string
        List<Contact> nuevosContactos = new List<Contact>();
        Contact contactWithEmptyEmail = new Contact(
            FirstName = 'New',
            LastName = 'Contact',
            Email = ''
        );
        nuevosContactos.add(contactWithEmptyEmail);
        
        Test.startTest();
        ContactValidator.evitarDuplicadosPorEmail(nuevosContactos);
        Test.stopTest();
        
        // Verify no error was added (empty emails should be treated like null)
        System.assert(!contactWithEmptyEmail.hasErrors(), 'Contact with empty email should not have error');
    }
}