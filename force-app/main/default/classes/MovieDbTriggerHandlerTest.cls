@isTest
class MovieDbTriggerHandlerTest {
    static testMethod void testHandler() {
        MovieDb__c m = new MovieDb__c(Title__c = 'Test', Video_ID__c = 'xyz');
        MovieDbTriggerHandler.handleTrigger(new List<MovieDb__c>{ m }, new Map<Id, MovieDb__c>());
        System.assertEquals('https://img.youtube.com/vi/xyz/maxresdefault.jpg', m.YouTube_Thumbnail_1280__c);
    }
}