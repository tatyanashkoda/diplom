trigger MilestoneDeveloperTrigger on Milestone_Developer__c (before insert, after insert) {
    new MilestoneDeveloperTriggerHandler().run();
}