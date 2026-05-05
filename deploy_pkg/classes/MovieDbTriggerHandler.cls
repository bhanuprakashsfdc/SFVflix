public class MovieDbTriggerHandler {
    public static void handleTrigger(List<bhanu9666__MoviesDB__c> newRecords, Map<Id, bhanu9666__MoviesDB__c> oldMap) {
        Set<String> processed = new Set<String>();
        Set<String> videoIds = new Set<String>();
        for (bhanu9666__MoviesDB__c r : newRecords) {
            if (r.bhanu9666__Video_ID__c != null && !processed.contains(r.bhanu9666__Video_ID__c)) {
                videoIds.add(r.bhanu9666__Video_ID__c);
                processed.add(r.bhanu9666__Video_ID__c);
            }
        }
        MovieDbService svc = new MovieDbService();
        svc.processRecords(newRecords);
        if (!videoIds.isEmpty()) svc.enrichFromExternalSource(newRecords, videoIds);
    }
}