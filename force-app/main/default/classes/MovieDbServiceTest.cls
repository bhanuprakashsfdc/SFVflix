@isTest
class MovieDbServiceTest {
    static testMethod void testProcessRecords() {
        MovieDb__c m = new MovieDb__c(
            Title__c = 'Test Movie',
            Rating__c = 'UA',
            Match_Score__c = '8/10',
            Duration__c = '2h 30m',
            Genres__c = 'Action;Drama',
            Cast__c = 'Actor1,Actor2',
            Video_ID__c = 'abc123'
        );
        MovieDbService svc = new MovieDbService();
        svc.processRecords(new List<MovieDb__c>{ m });
        System.assertEquals(8.0, m.Match_Score_Value__c);
        System.assertEquals(150, m.Duration_Minutes__c);
    }
}