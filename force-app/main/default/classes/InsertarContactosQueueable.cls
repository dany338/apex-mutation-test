public class InsertarContactosQueueable implements Queueable {

    private List<Contact> contactos;

    public InsertarContactosQueueable(List<Contact> contactos) {
        this.contactos = contactos;
    }

    public void execute(QueueableContext context) {
        try {
            insert contactos;
            System.debug('✅ Contactos insertados exitosamente: ' + contactos.size());
        } catch (Exception e) {
            System.debug('❌ Error al insertar contactos: ' + e.getMessage());
        }
    }
}