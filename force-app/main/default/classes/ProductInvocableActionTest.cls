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
}