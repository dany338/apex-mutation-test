@isTest
private class ProductInvocableActionTest_Mutations {

    // Test normal: debe pasar si el método funciona como se espera
    @isTest
    static void testValidInput() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'TestProduct';
        input.varIdRecord = '001XXXXXXXXXXXXXXX';

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAdditionalInformation(inputs);

        System.assertEquals(1, result.size(), 'Debe retornar un solo output');
        System.assertNotEquals(null, result[0].aditionalInformation, 'Debe tener información adicional');
        System.assertEquals(1, result[0].aditionalInformation.size(), 'Debe tener un contexto');
    }

    // 🧪 MUTACIÓN 1: El método no agrega elementos al resultData (cambiar línea de código o comentarla)
    @isTest
    static void testShouldFailIfNoContextDataIsAdded() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'P1';
        input.varIdRecord = '001FakeID';

        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAdditionalInformation(
            new List<ProductInvocableAction.inputVar>{ input }
        );

        // Esta prueba falla si se comenta: resultData.add(outputContextData);
        System.assertEquals(1, result[0].aditionalInformation.size(), 'Mutación: No se agregó el contexto correctamente');
    }

    // 🧪 MUTACIÓN 2: El ID no se agrega al mapa nodeData (cambiar o eliminar línea nodeData.put)
    @isTest
    static void testShouldFailIfNodeDataMissingId() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'P2';
        input.varIdRecord = '001XYZXYZXYZ';

        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAdditionalInformation(
            new List<ProductInvocableAction.inputVar>{ input }
        );

        // Esta prueba falla si se elimina o cambia: nodeData.put(Constants.STRING_ID_idRecord, idRecord);
        Map<String, Object> nodeData = result[0].aditionalInformation[0].nodeData;
        System.assert(nodeData.containsKey(Constants.STRING_ID_idRecord), 'Mutación: Falta el ID en el nodeData');
    }

    // 🧪 MUTACIÓN 3: El tipo de objeto cambia (modificar nodeName)
    @isTest
    static void testShouldFailIfWrongNodeName() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'P3';
        input.varIdRecord = '001TESTID';

        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAdditionalInformation(
            new List<ProductInvocableAction.inputVar>{ input }
        );

        String expectedNodeName = Constants.OBJECT_QUOTE;
        String actualNodeName = result[0].aditionalInformation[0].nodeName;

        System.assertEquals(expectedNodeName, actualNodeName, 'Mutación: El nodeName fue alterado');
    }

}
