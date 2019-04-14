public with sharing class MilestoneDeveloperTriggerHandler extends TriggerHandler{
    public override void beforeInsert() {
        renameMilestoneDeveloper((List<Milestone_Developer__c>) Trigger.new);
    }

    private void renameMilestoneDeveloper(List<Milestone_Developer__c> milestoneDevelopers){
        for(Milestone_Developer__c ms: milestoneDevelopers){
            Developer__c developer = [SELECT Id, Name FROM Developer__c WHERE Id =: ms.Developer__c];
            ms.Name = developer.Name;
        }
    }
}