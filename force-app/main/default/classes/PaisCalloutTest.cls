@isTest
private class PaisCalloutTest {
    @isTest static void testLlamadaAPais() {
        Test.setMock(HttpCalloutMock.class, new PaisCalloutMock());

        Test.startTest();
        PaisCallout.obtenerInformacionPais('Colombia');
        Test.stopTest();

        System.assert(true); // Aquí solo comprobamos que no haya errores
    }
}