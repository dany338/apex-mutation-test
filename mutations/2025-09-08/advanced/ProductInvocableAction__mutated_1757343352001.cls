/**
* @author Fernando Torres
* @date 08-07-2025
**/
public with sharing class ProductInvocableAction {
    
    // Clase de entrada
    public class inputVar {
        @InvocableVariable(required=true)
        public String productName;
        
        @InvocableVariable(required=true)
        public String varIdRecord;
    }
    
    // Clase de salida
    public class outputVar {
        @InvocableVariable
        public DummyContextDataInput[] aditionalInformation;
    }

    // Método invocable para Flows
    @InvocableMethod(label='Test method invocable' description='This is an invocable method for flows')
    public static List<outputVar> generateAditionalInformation(List<inputVar> inputs) {
        String apiVar;
        String idRecord;
        outputVar output = new outputVar();

        for(inputVar input : inputs) {
            apiVar = input.productName;
            idRecord = null; // 📝 Description: Set `idRecord` to `null` to simulate a failure in handling input data. - 💥 Expected impact: `testGenerateAditionalInformation` should fail because the assertion checking the value of `info.nodeData.get(Constants.STRING_ID)` will not match the expected ID.
        }

        List<DummyContextDataInput> resultData = new List<DummyContextDataInput>();
        DummyContextDataInput outputContextData = new DummyContextDataInput();
        outputContextData.nodeName = Constants.OBJECT_QUOTE;
        outputContextData.nodeData = new Map<String, Object>();
        outputContextData.nodeData.put(Constants.STRING_ID, idRecord.toString());
        resultData.add(outputContextData);

        output.aditionalInformation = resultData;
        return new List<outputVar>{ output };
    }
}