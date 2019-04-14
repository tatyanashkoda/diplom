trigger MilestoneDeveloperTrigger on Milestone_Developer__c (before insert) {
    new MilestoneDeveloperTriggerHandler().run();
}