public with sharing class MilestoneDeveloperTriggerHandler extends TriggerHandler {
    public override void beforeInsert() {
        renameMilestoneDeveloper((List<Milestone_Developer__c>) Trigger.new);
    }
    public override void afterInsert() {
        updateDevelopingCost((List<Milestone_Developer__c>) Trigger.new);
    }

    private void renameMilestoneDeveloper(List<Milestone_Developer__c> milestoneDevelopers) {
        for (Milestone_Developer__c msDev : milestoneDevelopers) {
            Developer__c developer = [SELECT Id, Name FROM Developer__c WHERE Id = :msDev.Developer__c];
            msDev.Name = developer.Name;
        }
    }

    private void updateDevelopingCost(List<Milestone_Developer__c> milestoneDevelopers) {
        for (Milestone_Developer__c msDev : milestoneDevelopers) {
            Milestone__c milestone = [SELECT Id, Developing_cost__c FROM Milestone__c WHERE Id = :msDev.Milestone__c];
            if (msDev.Developing_cost__c != null) {
                if (milestone.Developing_cost__c == null) {
                    milestone.Developing_cost__c = msDev.Developing_cost__c;
                } else {
                    milestone.Developing_cost__c = milestone.Developing_cost__c + msDev.Developing_cost__c;
                }
            }
            if (msDev.Developer_Work__c != null) {
                Developer_Work__c developerWork = [SELECT Developing_cost__c FROM Developer_Work__c WHERE Id = :msDev.Developer_Work__c];
                if (milestone.Developing_cost__c == null) {
                    milestone.Developing_cost__c = developerWork.Developing_cost__c;
                } else {
                    milestone.Developing_cost__c = milestone.Developing_cost__c + developerWork.Developing_cost__c;
                }
            }
            update milestone;
        }
    }
}