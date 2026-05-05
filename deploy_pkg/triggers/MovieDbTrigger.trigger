trigger MovieDbTrigger on bhanu9666__MoviesDB__c (before insert, before update) {
    MovieDbTriggerHandler.handleTrigger(Trigger.new, Trigger.oldMap);
}