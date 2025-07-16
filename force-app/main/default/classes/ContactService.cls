public with sharing class ContactService {
    
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactosFiltrados(String apellido, Integer offsetValue, Integer pageSize) {
        String filtro = '%' + apellido + '%';

        return [
            SELECT Id, FirstName, LastName, Email, Account.Name
            FROM Contact
            WHERE LastName LIKE :filtro
            ORDER BY LastName ASC
            LIMIT :pageSize
            OFFSET :offsetValue
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactosPaginados(String apellido, Integer offsetValue, Integer pageSize) {
        String filtro = '%' + apellido + '%';

        return [
            SELECT Id, FirstName, LastName, Email, Account.Name
            FROM Contact
            WHERE LastName LIKE :filtro
            ORDER BY LastName
            LIMIT :pageSize
            OFFSET :offsetValue
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactos() {
        return [
            SELECT Id, LastName, Account.Name
            FROM Contact
            ORDER BY CreatedDate DESC
            LIMIT 10
        ];
    }
}