/**
 * @description       : Test Class for PositionTrigger
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-23-2025
 * @last modified by  : Swarnab Banerjee
**/
@isTest
public with sharing class PositionTriggerTest {
    static User testUser = [SELECT Id, Email FROM User WHERE Id =: UserInfo.getUserId()];
    @TestSetup
    static void setup(){
        Position__c position = PositionTriggerTestHelper.createPosition();
        insert position;
    }

    /**
    * @description : Updates the Fields of Position__c and checks the Size and Position ID of the Published Event
    * @author Swarnab Banerjee | 12-23-2025 
    **/
    @isTest
    static void testPositionTrigger() {

        System.runAs(testUser) {
            Test.startTest();
            Position__c position = [SELECT Id, Name FROM Position__c LIMIT 1];
            position.Status__c = 'Closed - Filled';
            position.Close_Date__c = System.today();
            position.Type__c = 'Part Time';
            update position;
            List<Position_Update_Logger__c> positionEvents = [SELECT Id FROM Position_Update_Logger__c];
            Position_Update_Logger__c positionEvent = positionEvents[0];

            Test.stopTest();

            System.assertEquals(1, positionEvents.size(), '1 Position Event should be published');
            System.assertEquals(position.Id, positionEvent.Position_ID__c, 'Position Id should match');
        }    
    }
}