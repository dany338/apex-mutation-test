@isTest
private class InsertarContactosQueueableTest {
    
    @isTest static void testExecuteConContactosValidos() {
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            Email = 'john.doe@test.com'
        ));
        testContacts.add(new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@test.com'
        ));
        
        Test.startTest();
        // Execute the queueable job
        InsertarContactosQueueable job = new InsertarContactosQueueable(testContacts);
        System.enqueueJob(job);
        Test.stopTest();
        
        // Verify contacts were inserted
        List<Contact> insertedContacts = [SELECT Id, FirstName, LastName, Email FROM Contact];
        System.assertEquals(2, insertedContacts.size(), 'Should have inserted 2 contacts');
        
        // Verify the contact data
        Map<String, Contact> contactsByEmail = new Map<String, Contact>();
        for (Contact c : insertedContacts) {
            contactsByEmail.put(c.Email, c);
        }
        
        System.assert(contactsByEmail.containsKey('john.doe@test.com'), 'Should contain John Doe');
        System.assert(contactsByEmail.containsKey('jane.smith@test.com'), 'Should contain Jane Smith');
        
        Contact johnDoe = contactsByEmail.get('john.doe@test.com');
        System.assertEquals('John', johnDoe.FirstName, 'John first name should be correct');
        System.assertEquals('Doe', johnDoe.LastName, 'John last name should be correct');
    }
    
    @isTest static void testExecuteConListaVacia() {
        // Test with empty list
        List<Contact> emptyContacts = new List<Contact>();
        
        Test.startTest();
        InsertarContactosQueueable job = new InsertarContactosQueueable(emptyContacts);
        System.enqueueJob(job);
        Test.stopTest();
        
        // Verify no contacts were inserted
        List<Contact> insertedContacts = [SELECT Id FROM Contact];
        System.assertEquals(0, insertedContacts.size(), 'Should not have inserted any contacts');
    }
    
    @isTest static void testExecuteConContactoInvalido() {
        // Create contact with missing required field (LastName)
        List<Contact> invalidContacts = new List<Contact>();
        invalidContacts.add(new Contact(
            FirstName = 'John'
            // Missing LastName - this should cause an error
        ));
        
        Test.startTest();
        InsertarContactosQueueable job = new InsertarContactosQueueable(invalidContacts);
        System.enqueueJob(job);
        Test.stopTest();
        
        // The job should handle the exception gracefully
        // No contacts should be inserted due to the error
        List<Contact> insertedContacts = [SELECT Id FROM Contact];
        System.assertEquals(0, insertedContacts.size(), 'Should not have inserted invalid contacts');
    }
    
    @isTest static void testConstructor() {
        // Test constructor
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            Email = 'test@example.com'
        ));
        
        InsertarContactosQueueable job = new InsertarContactosQueueable(testContacts);
        
        // Verify constructor worked (we can't directly access private field, but creation should succeed)
        System.assertNotEquals(null, job, 'Job should be created successfully');
    }
    
    @isTest static void testExecuteConMultiplesContactos() {
        // Test with larger number of contacts
        List<Contact> manyContacts = new List<Contact>();
        for (Integer i = 0; i < 5; i++) {
            manyContacts.add(new Contact(
                FirstName = 'Contact',
                LastName = 'Number' + i,
                Email = 'contact' + i + '@test.com'
            ));
        }
        
        Test.startTest();
        InsertarContactosQueueable job = new InsertarContactosQueueable(manyContacts);
        System.enqueueJob(job);
        Test.stopTest();
        
        // Verify all contacts were inserted
        List<Contact> insertedContacts = [SELECT Id, LastName FROM Contact ORDER BY LastName];
        System.assertEquals(5, insertedContacts.size(), 'Should have inserted 5 contacts');
        
        // Verify the contacts are correctly ordered
        for (Integer i = 0; i < 5; i++) {
            System.assertEquals('Number' + i, insertedContacts[i].LastName, 'Contact ' + i + ' should have correct last name');
        }
    }
}