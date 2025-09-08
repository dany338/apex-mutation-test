public class DiscountCalculator {
    @AuraEnabled(cacheable=true)
    public static Decimal calculateDiscount(Decimal totalAmount) {
        if (totalAmount >= 1000) {
            return totalAmount * 1 / 10;
        }
        return 0;
    }
}