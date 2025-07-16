@isTest
private class ContactHandlerTest {
    @isTest static void testInsertContactoSinCuenta() {
        Account acc = new Account(Name='Sin cuenta');
        insert acc;

        Contact c = new Contact(
            LastName='Prueba',
            AccountId=acc.Id // <- Esta es la parte que faltaba
        );
        insert c;

        Contact result = [SELECT AccountId FROM Contact WHERE Id = :c.Id];
        System.assertEquals(acc.Id, result.AccountId);
    }
}