public with sharing class MilestoneTriggerHandler extends TriggerHandler{
    public override void beforeUpdate() {
        checkAndUpdateStatus((List<Milestone__c>) Trigger.new);
    }

    private void checkAndUpdateStatus(List<Milestone__c> milestones){
        for(Milestone__c ms: milestones){
            if(ms.Finished__c == true){
                ms.Status__c = Constants.MILESTONE_STATUS_CLOSED;
                ms.Finished_by__c = System.today();
            }
            if(ms.Start_date__c != null && ms.Finished__c == false){
                ms.Status__c = Constants.MILESTONE_STATUS_INPROGRESS;
            }
        }
    }
}