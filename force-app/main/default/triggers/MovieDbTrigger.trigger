trigger MovieDbTrigger on MovieDb__c (before insert, before update) {
    MovieDbTriggerHandler.handleTrigger(Trigger.new, Trigger.oldMap);
}
