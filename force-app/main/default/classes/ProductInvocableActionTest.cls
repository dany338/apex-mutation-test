@isTest
private class ProductInvocableActionTest {

    @isTest
    static void testGenerateAditionalInformation() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'Producto de prueba';
        input.varIdRecord = '001XXXXXXXXXXXXXXX';

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        System.assertNotEquals(null, result, 'Resultado no debe ser null');
        System.assertEquals(1, result.size(), 'Debe haber un solo resultado');

        DummyContextDataInput info = result[0].aditionalInformation[0];
        System.assertEquals(Constants.OBJECT_QUOTE, info.nodeName);
        System.assert(info.nodeData.containsKey(Constants.STRING_ID), 'Debe contener el ID');
        System.assertEquals('001XXXXXXXXXXXXXXX', String.valueOf(info.nodeData.get(Constants.STRING_ID)));
    }
    
    @isTest
    static void testGenerateAditionalInformationWithNullId() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'Producto sin ID';
        input.varIdRecord = null;

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        System.assertNotEquals(null, result, 'Resultado no debe ser null');
        System.assertEquals(1, result.size(), 'Debe haber un solo resultado');

        DummyContextDataInput info = result[0].aditionalInformation[0];
        System.assertEquals(Constants.OBJECT_QUOTE, info.nodeName);
        System.assert(info.nodeData.containsKey(Constants.STRING_ID), 'Debe contener el ID');
        System.assertEquals(null, info.nodeData.get(Constants.STRING_ID), 'ID debe ser null');
    }
    
    @isTest
    static void testGenerateAditionalInformationWithEmptyId() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'Producto con ID vacío';
        input.varIdRecord = '';

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        System.assertNotEquals(null, result, 'Resultado no debe ser null');
        System.assertEquals(1, result.size(), 'Debe haber un solo resultado');

        DummyContextDataInput info = result[0].aditionalInformation[0];
        System.assertEquals(Constants.OBJECT_QUOTE, info.nodeName);
        System.assertEquals('', String.valueOf(info.nodeData.get(Constants.STRING_ID)), 'ID debe ser cadena vacía');
    }
    
    @isTest
    static void testGenerateAditionalInformationWithMultipleInputs() {
        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>();
        
        ProductInvocableAction.inputVar input1 = new ProductInvocableAction.inputVar();
        input1.productName = 'Producto 1';
        input1.varIdRecord = '001XXXXXXXXXXXXXXX';
        inputs.add(input1);
        
        ProductInvocableAction.inputVar input2 = new ProductInvocableAction.inputVar();
        input2.productName = 'Producto 2';
        input2.varIdRecord = '001YYYYYYYYYYYYYYY';
        inputs.add(input2);

        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        System.assertNotEquals(null, result, 'Resultado no debe ser null');
        System.assertEquals(1, result.size(), 'Debe haber un solo resultado consolidado');

        DummyContextDataInput info = result[0].aditionalInformation[0];
        System.assertEquals(Constants.OBJECT_QUOTE, info.nodeName);
        // Note: With multiple inputs, the loop uses the last value
        System.assertEquals('001YYYYYYYYYYYYYYY', String.valueOf(info.nodeData.get(Constants.STRING_ID)));
    }
    
    @isTest
    static void testGenerateAditionalInformationWithLongProductName() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'Este es un nombre de producto muy largo que puede tener muchos caracteres y símbolos especiales áéíóú';
        input.varIdRecord = '001ZZZZZZZZZZZZZZZ';

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        System.assertNotEquals(null, result, 'Resultado no debe ser null');
        System.assertEquals(1, result.size(), 'Debe haber un solo resultado');

        DummyContextDataInput info = result[0].aditionalInformation[0];
        System.assertEquals(Constants.OBJECT_QUOTE, info.nodeName);
        System.assertEquals('001ZZZZZZZZZZZZZZZ', String.valueOf(info.nodeData.get(Constants.STRING_ID)));
    }
    
    @isTest
    static void testGenerateAditionalInformationStructure() {
        ProductInvocableAction.inputVar input = new ProductInvocableAction.inputVar();
        input.productName = 'Test Structure';
        input.varIdRecord = '001TESTSTRUCTUREID';

        List<ProductInvocableAction.inputVar> inputs = new List<ProductInvocableAction.inputVar>{ input };
        List<ProductInvocableAction.outputVar> result = ProductInvocableAction.generateAditionalInformation(inputs);

        // Verify the structure is correct
        ProductInvocableAction.outputVar output = result[0];
        System.assertNotEquals(null, output.aditionalInformation, 'Additional information should not be null');
        System.assertEquals(1, output.aditionalInformation.size(), 'Should have exactly one information item');
        
        DummyContextDataInput contextData = output.aditionalInformation[0];
        System.assertNotEquals(null, contextData.nodeData, 'Node data should not be null');
        System.assertNotEquals(null, contextData.nodeName, 'Node name should not be null');
    }
}