trigger AccountPhoneChangeTrigger on Account (before update) {
    for (Account acc : Trigger.new) {
        Account oldAcc = Trigger.oldMap.get(acc.Id);
        if (acc.Phone != oldAcc.Phone) { // Check if the phone number has changed
            // Create a new PhoneChange__c record to log the change
            // Assuming PhoneChange__c is a custom object with fields Account__c, OldPhone
            PhoneChange__c change = new PhoneChange__c();
            change.Account__c = acc.Id;
            change.OldPhone__c = oldAcc.Phone;
            change.NewPhone__c = acc.Phone;
            insert change;
        }
    }
}