trigger CaseTrigger on Case (before update, after update, before delete) {
    switch on Trigger.operationType {
        when BEFORE_UPDATE {
            CaseTriggerHandler.preventUpdatingClosedCase(Trigger.new, Trigger.oldMap);
        }
        when AFTER_UPDATE {
            CaseTriggerHandler.updateAccountRatingAfterUpdate(Trigger.new, Trigger.oldMap);
        }
        when BEFORE_DELETE{
            CaseTriggerHandler.updateAccountRatingAfterDelete(Trigger.oldMap);
        }
    }
}