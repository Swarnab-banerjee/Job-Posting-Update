/**
 * @description       : 
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-12-2025
 * @last modified by  : Swarnab Banerjee
**/
public inherited sharing class PositionTriggerTestHelper {
    /**
    * @description 
    * @author Swarnab Banerjee | 12-12-2025 
    * @return Position__c 
    **/
    public static Position__c createPosition() {
        Position__c position = new Position__c();
        position.Name = 'Software Engineer';
        position.Max_Pay__c = 100000;
        position.Min_Pay__c = 80000;
        position.Open_Date__c = System.today();
        position.Job_Description__c = 'This is a test position';
        position.Close_Date__c = System.today().addDays(30);
        position.Status__c = 'New Position';
        position.Type__c = 'Full Time';
        return position;
    }
}