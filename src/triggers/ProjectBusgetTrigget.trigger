trigger ProjectBusgetTrigget on Project_s_Budget__c (after update) {
    new ProjectBusgetTriggetHandler().run();
}