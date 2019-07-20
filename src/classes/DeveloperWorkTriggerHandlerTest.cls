@IsTest
private class DeveloperWorkTriggerHandlerTest {
    @IsTest
    static void testBehavior() {
        Developer_Work__c developerWork = new Developer_Work__c(
                Name = '1243',
                Cost_Per_Hour__c = 123,
                Number_of_Hours__c = 12
        );
        insert developerWork;
        System.assertNotEquals('1234',developerWork.Name);
    }
}