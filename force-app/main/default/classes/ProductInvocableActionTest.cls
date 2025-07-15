@isTest
private class ProductInvocableActionTest {

    @isTest
    static void testGenerateAdditionalInformation() {
        // Crear un input de prueba
        ProductInvocableAction.inputVar testInput = new ProductInvocableAction.inputVar();
        testInput.productName = 'TestProduct';
        testInput.varIdRecord = '001XXXXXXXXXXXXXXX';

        // Ejecutar el método invocable con el input
        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ testInput };
        List<ProductInvocableAction.outputVar> results = ProductInvocableAction.generateAdditionalInformation(inputs);

        // Validaciones
        System.assertNotEquals(null, results, 'Los resultados no deben ser nulos');
        System.assertEquals(1, results.size(), 'Debe haber un solo resultado');
        System.assertNotEquals(null, results[0].aditionalInformation, 'La información adicional no debe ser nula');
        System.assertEquals(1, results[0].aditionalInformation.size(), 'Debe haber un ContextDataInput');
        System.assertEquals(Constants.OBJECT_QUOTE, results[0].aditionalInformation[0].nodeName, 'El nodeName debe ser OBJECT_QUOTE');
        System.assert(results[0].aditionalInformation[0].nodeData.containsKey(Constants.STRING_ID_idRecord), 'Debe contener el ID en nodeData');
    }
}
