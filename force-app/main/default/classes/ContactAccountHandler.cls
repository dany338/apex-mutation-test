public class ContactAccountHandler {
    public static void asociarContactos(List<Contact> contactos) {
        Set<String> idsExternos = new Set<String>();

        for (Contact c : contactos) {
            if (c.Identificador_Externo__c != null) {
                idsExternos.add(c.Identificador_Externo__c);
            }
        }

        Map<String, Account> cuentasMap = new Map<String, Account>();

        if (!idsExternos.isEmpty()) {
            for (Account acc : [
                SELECT Id, Identificador_Externo__c
                FROM Account
                WHERE Identificador_Externo__c IN :idsExternos
            ]) {
                cuentasMap.put(acc.Identificador_Externo__c, acc);
            }
        }

        for (Contact c : contactos) {
            if (c.Identificador_Externo__c != null &&
                cuentasMap.containsKey(c.Identificador_Externo__c)) {
                c.AccountId = cuentasMap.get(c.Identificador_Externo__c).Id;
            }
        }
    }
}