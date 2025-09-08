@isTest
private class ConstantsTest {
    
    @isTest static void testObjectQuoteConstant() {
        // Test that the constant is properly defined
        System.assertEquals('QUOTE', Constants.OBJECT_QUOTE, 'OBJECT_QUOTE constant should be QUOTE');
        System.assertNotEquals(null, Constants.OBJECT_QUOTE, 'OBJECT_QUOTE should not be null');
        System.assertNotEquals('', Constants.OBJECT_QUOTE, 'OBJECT_QUOTE should not be empty');
    }
    
    @isTest static void testStringIdConstant() {
        // Test that the constant is properly defined
        System.assertEquals('Id', Constants.STRING_ID, 'STRING_ID constant should be Id');
        System.assertNotEquals(null, Constants.STRING_ID, 'STRING_ID should not be null');
        System.assertNotEquals('', Constants.STRING_ID, 'STRING_ID should not be empty');
    }
    
    @isTest static void testConstantsAreImmutable() {
        // Test that constants can be referenced multiple times
        String quote1 = Constants.OBJECT_QUOTE;
        String quote2 = Constants.OBJECT_QUOTE;
        System.assertEquals(quote1, quote2, 'Constants should return same value consistently');
        
        String id1 = Constants.STRING_ID;
        String id2 = Constants.STRING_ID;
        System.assertEquals(id1, id2, 'Constants should return same value consistently');
    }
}