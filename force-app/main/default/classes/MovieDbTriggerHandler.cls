public class MovieDbTriggerHandler {
    public static void handleTrigger(List<MovieDb__c> newRecords, Map<Id, MovieDb__c> oldMap) {
        Set<String> processedIds = new Set<String>();

        // Collect YouTube Video IDs for API calls
        Set<String> videoIds = new Set<String>();
        for (MovieDb__c record : newRecords) {
            if (record.Video_ID__c != null && !processedIds.contains(record.Video_ID__c)) {
                videoIds.add(record.Video_ID__c);
                processedIds.add(record.Video_ID__c);
            }
        }

        // Call service for processing (URL transformations, derivations)
        MovieDbService service = new MovieDbService();
        service.processRecords(newRecords);

        // Enrich data from external source if needed
        if (!videoIds.isEmpty()) {
            service.enrichFromExternalSource(newRecords, videoIds);
        }
    }
}
