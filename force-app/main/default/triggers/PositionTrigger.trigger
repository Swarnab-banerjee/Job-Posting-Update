/**
 * @description       : After Update Trigger is fired Whenever A Position is updated
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-23-2025
 * @last modified by  : Swarnab Banerjee
**/
trigger PositionTrigger on Position__c (after update) {
    new PositionEventTriggerHandler().execute();
}