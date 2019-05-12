trigger TransactionTrigger on Transactions__c (before insert, after insert, after delete) {
    new TransactionTriggerHandler().run();
}