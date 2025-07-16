@isTest
private class ContactAccountHandlerTest {
    @isTest static void testAsociarContactoConCuenta() {
        // Crear una cuenta con identificador externo
        Account acc = new Account(Name = 'EmpresaX', Identificador_Externo__c = 'EXT-999');
        insert acc;

        // Crear un contacto con ese mismo identificador externo
        Contact c = new Contact(
            FirstName = 'Ana',
            LastName = 'Test',
            Email = 'ana@test.com',
            Identificador_Externo__c = 'EXT-999'
        );
        insert c;

        // Consultar el contacto y verificar que esté asociado a la cuenta
        Contact contactoGuardado = [SELECT Id, AccountId FROM Contact WHERE Id = :c.Id];

        System.assertEquals(acc.Id, contactoGuardado.AccountId, 'El contacto debe estar relacionado a la cuenta por identificador externo.');
    }
}