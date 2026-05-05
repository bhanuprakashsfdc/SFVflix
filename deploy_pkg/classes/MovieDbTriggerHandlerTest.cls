@isTest
class MovieDbTriggerHandlerTest {
    static testMethod void testHandler() {
        bhanu9666__MoviesDB__c m = new bhanu9666__MoviesDB__c(bhanu9666__Title__c = 'Test', bhanu9666__Video_ID__c = 'xyz');
        MovieDbTriggerHandler.handleTrigger(new List<bhanu9666__MoviesDB__c>{ m }, new Map<Id, bhanu9666__MoviesDB__c>());
        System.assertEquals('https://img.youtube.com/vi/xyz/maxresdefault.jpg', m.bhanu9666__YouTube_Thumbnail_1280__c);
    }
}