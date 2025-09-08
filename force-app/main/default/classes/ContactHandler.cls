public class ContactHandler {
    public static void asignarCuentaGenerica(List<Contact> contactos) {
        // Validate input
        if (contactos == null || contactos.isEmpty()) {
            return;
        }
        
        try {
            // Query for the generic account
            List<Account> cuentasGenericas = [SELECT Id FROM Account WHERE Name = 'Sin cuenta' LIMIT 1];
            
            if (cuentasGenericas.isEmpty()) {
                // Create the generic account if it doesn't exist
                Account cuentaGenerica = new Account(Name = 'Sin cuenta');
                insert cuentaGenerica;
                cuentasGenericas.add(cuentaGenerica);
                System.debug('Created generic account: Sin cuenta');
            }
            
            Account cuentaGenerica = cuentasGenericas[0];
            
            // Assign generic account to contacts without AccountId
            for (Contact c : contactos) {
                if (c.AccountId == null) {
                    c.AccountId = cuentaGenerica.Id;
                }
            }
        } catch (Exception e) {
            System.debug('Error in asignarCuentaGenerica: ' + e.getMessage());
            // Add error to the first contact if possible
            if (contactos != null && !contactos.isEmpty()) {
                contactos[0].addError('Error asignando cuenta genérica: ' + e.getMessage());
            }
        }
    }
}