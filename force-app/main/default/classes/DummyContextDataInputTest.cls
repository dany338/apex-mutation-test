@isTest
private class DummyContextDataInputTest {
    @isTest
    static void testDummyContextDataInput() {
        // Crear una instancia de DummyContextDataInput
        DummyContextDataInput dummyInput = new DummyContextDataInput();
        dummyInput.nodeName = 'TestNode';
        dummyInput.nodeData = new Map<String, Object>{
            'key1' => 'value1',
            'key2' => 123
        };

        // Validaciones
        System.assertNotEquals(null, dummyInput, 'DummyContextDataInput no debe ser nulo');
        System.assertEquals('TestNode', dummyInput.nodeName, 'El nodeName debe ser TestNode');
        System.assertEquals(2, dummyInput.nodeData.size(), 'Debe haber dos entradas en nodeData');
        System.assert(dummyInput.nodeData.containsKey('key1'), 'nodeData debe contener key1');
        System.assertEquals('value1', dummyInput.nodeData.get('key1'), 'El valor de key1 debe ser value1');
    }
}