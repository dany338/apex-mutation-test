@isTest
private class DiscountCalculatorTest {
    @isTest static void testDiscountOverThreshold() {
        Decimal discount = DiscountCalculator.calculateDiscount(1500);
        System.assertEquals(150, discount, 'Debe aplicar 10% de descuento');
    }

    @isTest static void testDiscountBelowThreshold() {
        Decimal discount = DiscountCalculator.calculateDiscount(500);
        System.assertEquals(0, discount, 'No debe aplicar descuento');
    }

    @isTest static void testDiscountExactlyThreshold() {
        Decimal discount = DiscountCalculator.calculateDiscount(1000);
        System.assertEquals(100, discount, 'Debe aplicar 10% de descuento en el umbral');
    }

    @isTest static void testDiscountNegativeAmount() {
        Decimal discount = DiscountCalculator.calculateDiscount(-500);
        System.assertEquals(0, discount, 'No debe aplicar descuento para montos negativos');
    }
}