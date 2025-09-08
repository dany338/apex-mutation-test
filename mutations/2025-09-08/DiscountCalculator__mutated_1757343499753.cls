public class DiscountCalculator {
    @AuraEnabled(cacheable=true)
    public static Decimal calculateDiscount(Decimal totalAmount) {
        if (totalAmount >= 1000) {
            return totalAmount * 0.05;
        }
        return 0;
    }
}