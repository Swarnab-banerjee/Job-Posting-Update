/**
 * @description       : 
 * @author            : Swarnab Banerjee
 * @group             : 
 * @last modified on  : 12-12-2025
 * @last modified by  : Swarnab Banerjee
**/
public with sharing class PositionEventTriggerHandler extends ExtendedTriggerHandler {

    private final static String POSITION_EVENT_TRIGGER = 'PositionTrigger';
    private final static List<String> TARGET_FIELDS = new List<String>{'Status__c', 'Close_Date__c', 'Type__c'};

    /**
     * @description Check if the trigger is enabled from metadata
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
     * @description After update trigger logic
     */
    public override void afterUpdate() {
        try {
            publishPositionEvent();
        } catch (Exception e) {
            // Log the exception to understand what's going wrong
            System.debug('Error in publishing Position Event: ' + e.getMessage());
        }
    }

    /**
     * @description Publish Platform Event for updated Position__c records
     */
    private void publishPositionEvent() {
        List<Position_Update__e> positionEvents = new List<Position_Update__e>();

        // Loop through updated Position records
        for(Position__c newPosition : (List<Position__c>)Trigger.new) {
            Position__c oldPosition = (Position__c)Trigger.oldMap.get(newPosition.Id);

            List<String> changes = new List<String>();
            Map<String, Object> oldValues = new Map<String, Object>();
            Map<String, Object> newValues = new Map<String, Object>();

            // Loop over specific fields we care about: Status, Open Date, Type
            for(String fieldName : TARGET_FIELDS) {
                Object oldVal = oldPosition.get(fieldName);
                Object newVal = newPosition.get(fieldName);

                // Check if the field has changed
                if ((oldVal == null && newVal != null) || (oldVal != null && !oldVal.equals(newVal))) {
                    changes.add(
                        fieldName + 
                        '|Old: ' + String.valueOf(oldVal) + 
                        '|New: ' + String.valueOf(newVal)
                    );
                    
                    // Add the old and new values to their respective maps
                    oldValues.put(fieldName, oldVal);
                    newValues.put(fieldName, newVal);
                }
            }

            // Only publish an event if there are changes
            if (!changes.isEmpty()) {
                Position_Update__e event = new Position_Update__e(
                    Position_Id__c     = newPosition.Id,
                    Updated_By__c      = UserInfo.getUserId(),
                    Updated_Fields__c  = String.join(changes, '\n'),
                    Old_Values__c      = JSON.serialize(oldValues),
                    New_Values__c      = JSON.serialize(newValues),
                    Timestamp__c       = System.now()
                );

                positionEvents.add(event);
            }
        }

        // Publish all events in bulk
        if (!positionEvents.isEmpty()) {
            EventBus.publish(positionEvents);
        }
    }
}
