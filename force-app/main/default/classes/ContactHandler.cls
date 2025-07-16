public class ContactHandler {
    public static void asignarCuentaGenerica(List<Contact> contactos) {
        Account cuentaGenerica = [SELECT Id FROM Account WHERE Name = 'Sin cuenta' LIMIT 1];
        for (Contact c : contactos) {
            if (c.AccountId == null) {
                c.AccountId = cuentaGenerica.Id;
            }
        }
    }
}