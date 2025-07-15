/**
* @author Fernando Torres
* @date 08-07-2025
**/
public with sharing class ProductInvocableAction {
    
    // Constructor method
    public class inputVar {
        @InvocableVariable(required=true)
        public String productName;
        
        @InvocableVariable(required=true)
        public String varIdRecord;
        
    }
    
    // variables de salida
    public class outputVar {
        @InvocableVariable
        public runtime_industries_cpq.ContextDataInput[] aditionalInformation;
    }

    //invocable method
    @InvocableMethod(label='Test method invocable' description='this is a invocable methond for flows')
    public static List<outputVar> generateAditionalInformation(List<inputVar> inputs) {
        String apiVar;
        String idRecord;
        String typeVar;
        outputVar output = new outputVar();
        
        
        for(inputVar input : inputs ){
            apiVar = input.productName;
            idRecord = input.varIdRecord;
        }

        List<runtime_industries_cpq.ContextDataInput> resultData = new List<runtime_industries_cpq.ContextDataInput>();
        runtime_industries_cpq.ContextDataInput ouputContextData = new runtime_industries_cpq.ContextDataInput();
        ouputContextData.nodeName = Constants.OBJECT_QUOTE; 
        ouputContextData.nodeData = new Map<String,Object>();
        ouputContextData.nodeData.put(Constants.STRING_ID,idRecord);
        resultData.add(ouputContextData);
        
        output.aditionalInformation = resultData;
        return new List<outputVar>{output};
    }
}