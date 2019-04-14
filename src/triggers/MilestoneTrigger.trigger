trigger MilestoneTrigger on Milestone__c (before update) {
    new MilestoneTriggerHandler().run();
}