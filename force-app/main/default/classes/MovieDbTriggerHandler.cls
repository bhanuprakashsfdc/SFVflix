public class MovieDbTriggerHandler {
    public static void handleTrigger(List<MovieDb__c> newRecords, Map<Id, MovieDb__c> oldMap) {
        Set<String> processed = new Set<String>();
        Set<String> videoIds = new Set<String>();
        for (MovieDb__c r : newRecords) {
            if (r.Video_ID__c != null && !processed.contains(r.Video_ID__c)) {
                videoIds.add(r.Video_ID__c);
                processed.add(r.Video_ID__c);
            }
        }
        MovieDbService svc = new MovieDbService();
        svc.processRecords(newRecords);
        if (!videoIds.isEmpty()) svc.enrichFromExternalSource(newRecords, videoIds);
    }
}