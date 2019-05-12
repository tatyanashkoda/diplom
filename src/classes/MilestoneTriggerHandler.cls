public with sharing class MilestoneTriggerHandler extends TriggerHandler {
    public override void beforeUpdate() {
        updateStatus((List<Milestone__c>) Trigger.new);
    }

    private void updateStatus(List<Milestone__c> milestones) {
        for (Milestone__c ms : milestones) {
            Milestone__c oldMilestone = (Milestone__c) System.Trigger.oldMap.get(ms.Id);
            if (oldMilestone.Finished__c == false && ms.Finished__c == true) {
                ms.Status__c = Constants.MILESTONE_STATUS_CLOSED;
                return;
            }

            if (oldMilestone.Finished__c == true && ms.Finished__c == false
                    && ms.Status__c == Constants.MILESTONE_STATUS_CLOSED) {
                ms.Status__c = Constants.MILESTONE_STATUS_INPROGRESS;
                ms.Finished_by__c = null;
                return;
            }

            if (ms.Status__c == Constants.MILESTONE_STATUS_CLOSED) {
                ms.Finished__c = true;
                return;
            }

            if(ms.Finished_by__c != null || (oldMilestone.Finished_by__c != ms.Finished_by__c)){
                ms.Finished__c = true;
                ms.Status__c = Constants.MILESTONE_STATUS_CLOSED;
            }
        }
    }
}