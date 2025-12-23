/**
 * @description       : Position Trigger Handler Class
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-23-2025
 * @last modified by  : Swarnab Banerjee
**/
public with sharing class PositionEventTriggerHandler extends ExtendedTriggerHandler {

    private final static String POSITION_EVENT_TRIGGER = 'PositionTrigger';

    /**
     * @description : Check if the trigger is enabled from metadata
     *@return
     */
    public override boolean isTriggerEnabled() {
        sobject_Trigger_Manager__mdt config =
            sobject_Trigger_Manager__mdt.getInstance(POSITION_EVENT_TRIGGER);

        // Default enabled if no config exists
        if (config == null) {
            return true;
        }

        return !config.disableTrigger__c;
    }

    /**
     * @description : After update trigger
     */
    public override void afterUpdate() {
        try {
            PositionEventTriggerHelper.publishPositionEvent();
        } catch (Exception e) {
            // System.debug('Error in publishing Position Event: ' + e.getMessage());
            LoggerException.logException(e, 'ERROR');
        }
    }                       
}
