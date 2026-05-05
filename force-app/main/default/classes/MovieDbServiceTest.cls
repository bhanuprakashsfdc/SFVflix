@isTest
class MovieDbServiceTest {
    static testMethod void testProcessRecords() {
        bhanu9666__MoviesDB__c m = new bhanu9666__MoviesDB__c(
            bhanu9666__Title__c = 'Test Movie',
            bhanu9666__Rating__c = 'UA',
            bhanu9666__Match_Score__c = '8/10',
            bhanu9666__Duration__c = '2h 30m',
            bhanu9666__Genres__c = 'Action;Drama',
            bhanu9666__Cast__c = 'Actor1,Actor2',
            bhanu9666__Video_ID__c = 'abc123'
        );
        MovieDbService svc = new MovieDbService();
        svc.processRecords(new List<bhanu9666__MoviesDB__c>{ m });
        System.assertEquals(8.0, m.bhanu9666__Match_Score_Value__c);
        System.assertEquals(150, m.bhanu9666__Duration_Minutes__c);
    }
}