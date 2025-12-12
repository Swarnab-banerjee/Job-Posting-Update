/**
 * @description       : 
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-11-2025
 * @last modified by  : Swarnab Banerjee
**/
trigger PositionTrigger on Position__c (after update) {
    new PositionEventTriggerHandler().execute();
}