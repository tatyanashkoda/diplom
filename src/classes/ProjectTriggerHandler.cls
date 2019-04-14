public with sharing class ProjectTriggerHandler extends TriggerHandler {

    public override void beforeUpdate() {
        checkAndUpdateDateFnished((List<Project__c>) Trigger.new);
    }

    private void checkAndUpdateDateFnished(List<Project__c> projects){
        List<Milestone__c> milestone = [SELECT Id, Finished__c, Finished_by__c From Milestone__c WHERE Project__c IN: projects];
        Date milestoneDateFinished;
        Date maxMilestoneDateFinished;
        for(Milestone__c ms: milestone){
            milestoneDateFinished = ms.Finished_by__c;
            if(milestoneDateFinished > ms.Finished_by__c){
                maxMilestoneDateFinished = milestoneDateFinished;
            }
            else{
                maxMilestoneDateFinished = ms.Finished_by__c;
            }
        }
        for (Project__c project: projects){
            System.debug('milestone-->' + milestone);
            if(project.Project_is_finished__c == true && System.today() >= maxMilestoneDateFinished){
                project.Finished_by__c = System.today();
            }
            else if(System.today() < maxMilestoneDateFinished){
            project.addError('Not all milestones is finished');
            }
        }

    }
}