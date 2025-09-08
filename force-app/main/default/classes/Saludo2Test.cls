@isTest
private class Saludo2Test {
    
    @isTest static void testDecirHola2() {
        // Test basic functionality
        String resultado = Saludo2.decirHola2('Ana');
        System.assertEquals('Hola, Ana!', resultado, 'El saludo debe ser correcto');
    }
    
    @isTest static void testDecirHola2ConNombreVacio() {
        // Test with empty name
        String resultado = Saludo2.decirHola2('');
        System.assertEquals('Hola, !', resultado, 'Debe manejar nombre vacío');
    }
    
    @isTest static void testDecirHola2ConNombreLargo() {
        // Test with long name
        String nombreLargo = 'Christopher Alexander Montgomery';
        String resultado = Saludo2.decirHola2(nombreLargo);
        System.assertEquals('Hola, ' + nombreLargo + '!', resultado, 'Debe manejar nombres largos');
    }
    
    @isTest static void testDecirHola2ConNull() {
        // Test with null - will cause exception but we test the behavior
        String resultado = Saludo2.decirHola2(null);
        System.assertEquals('Hola, null!', resultado, 'Debe manejar null como string');
    }
}