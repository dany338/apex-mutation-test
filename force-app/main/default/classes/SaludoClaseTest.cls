@isTest
private class SaludoClaseTest {
    
    @isTest static void testDecirHolaEstatico() {
        // Test basic functionality
        String resultado = SaludoClase.decirHolaEstatico('Juan');
        System.assertEquals('Hola desde VS Code, Juan!', resultado, 'El saludo debe ser correcto');
    }
    
    @isTest static void testDecirHolaEstaticoConNombreVacio() {
        // Test with empty name
        String resultado = SaludoClase.decirHolaEstatico('');
        System.assertEquals('Hola desde VS Code, !', resultado, 'Debe manejar nombre vacío');
    }
    
    @isTest static void testDecirHolaEstaticoConEspacios() {
        // Test with spaces
        String resultado = SaludoClase.decirHolaEstatico('María José');
        System.assertEquals('Hola desde VS Code, María José!', resultado, 'Debe manejar nombres con espacios');
    }
    
    @isTest static void testDecirHolaEstaticoConCaracteresEspeciales() {
        // Test with special characters
        String resultado = SaludoClase.decirHolaEstatico('José-María');
        System.assertEquals('Hola desde VS Code, José-María!', resultado, 'Debe manejar caracteres especiales');
    }
}