@isTest
private class ContactServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        // Create test contacts
        List<Contact> testContacts = new List<Contact>();
        testContacts.add(new Contact(
            FirstName = 'John',
            LastName = 'Smith',
            Email = 'john.smith@test.com',
            AccountId = testAccount.Id
        ));
        testContacts.add(new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            Email = 'jane.smith@test.com',
            AccountId = testAccount.Id
        ));
        testContacts.add(new Contact(
            FirstName = 'Mike',
            LastName = 'Johnson',
            Email = 'mike.johnson@test.com',
            AccountId = testAccount.Id
        ));
        testContacts.add(new Contact(
            FirstName = 'Sarah',
            LastName = 'Williams',
            Email = 'sarah.williams@test.com',
            AccountId = testAccount.Id
        ));
        insert testContacts;
    }
    
    @isTest static void testGetContactosFiltrados() {
        // Test filtering by last name
        List<Contact> results = ContactService.getContactosFiltrados('Smith', 0, 10);
        System.assertEquals(2, results.size(), 'Should find 2 contacts with Smith last name');
        
        for (Contact c : results) {
            System.assert(c.LastName.contains('Smith'), 'All contacts should contain Smith in last name');
        }
    }
    
    @isTest static void testGetContactosFiltradosConOffset() {
        // Test with offset
        List<Contact> results = ContactService.getContactosFiltrados('Smith', 1, 1);
        System.assertEquals(1, results.size(), 'Should return 1 contact with offset');
    }
    
    @isTest static void testGetContactosFiltradosApellidoInexistente() {
        // Test with non-existent last name
        List<Contact> results = ContactService.getContactosFiltrados('NoExiste', 0, 10);
        System.assertEquals(0, results.size(), 'Should find no contacts with non-existent last name');
    }
    
    @isTest static void testGetContactosPaginados() {
        // Test pagination functionality
        List<Contact> results = ContactService.getContactosPaginados('Smith', 0, 1);
        System.assertEquals(1, results.size(), 'Should return 1 contact per page');
        
        List<Contact> allResults = ContactService.getContactosPaginados('Smith', 0, 10);
        System.assertEquals(2, allResults.size(), 'Should return all Smith contacts');
    }
    
    @isTest static void testGetContactos() {
        // Test getting recent contacts
        List<Contact> results = ContactService.getContactos();
        System.assert(results.size() <= 10, 'Should return maximum 10 contacts');
        System.assert(results.size() >= 4, 'Should return our test contacts');
        
        // Verify ordering by CreatedDate DESC
        if (results.size() > 1) {
            for (Integer i = 0; i < results.size() - 1; i++) {
                // Note: We can't directly compare CreatedDate in test context
                // but we can verify the query executes successfully
                System.assertNotEquals(null, results[i].Id, 'Contact should have Id');
            }
        }
    }
    
    @isTest static void testGetContactosFiltradosConApellidoVacio() {
        // Test with empty last name filter
        List<Contact> results = ContactService.getContactosFiltrados('', 0, 10);
        System.assert(results.size() >= 4, 'Empty filter should return all test contacts');
    }
    
    @isTest static void testGetContactosPaginadosConLimites() {
        // Test pagination limits
        List<Contact> results = ContactService.getContactosPaginados('', 0, 2);
        System.assert(results.size() <= 2, 'Should respect page size limit');
    }
}