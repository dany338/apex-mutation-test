public class ContactValidator {
    public static void evitarDuplicadosPorEmail(List<Contact> nuevosContactos) {
        Set<String> emails = new Set<String>();

        for (Contact c : nuevosContactos) {
            if (c.Email != null) {
                emails.add(c.Email.toLowerCase());
            }
        }

        Map<String, Contact> contactosExistentes = new Map<String, Contact>();
        if (!emails.isEmpty()) {
            for (Contact existente : [
                SELECT Id, Email FROM Contact WHERE Email IN :emails
            ]) {
                contactosExistentes.put(
                    existente.Email.toLowerCase(), existente
                );
            }
        }

        for (Contact nuevo : nuevosContactos) {
            if (nuevo.Email != null && contactosExistentes.containsKey(nuevo.Email.toLowerCase())) {
                nuevo.addError('Ya existe un contacto con este correo: ' + nuevo.Email);
            }
        }
    }
}