@IsTest
private class MovieDbTriggerHandlerTest {
    @IsTest
    static void testTriggerHandler_BasicProcessing() {
        MovieDb__c record = new MovieDb__c(
            Title__c = 'Trigger Test Movie',
            Duration__c = '2h 0m',
            Match_Score__c = '6.5/10',
            Is_Top_10__c = false
        );

        Test.startTest();
        insert record;
        Test.stopTest();

        // Reload from database
        MovieDb__c result = [SELECT Id, Duration_Minutes__c, Match_Score_Value__c, Is_Featured__c
                             FROM MovieDb__c WHERE Id = :record.Id];

        System.assertEquals(120, result.Duration_Minutes__c);
        System.assertEquals(6.5, result.Match_Score_Value__c);
        System.assertEquals(true, result.Is_Featured__c);
    }

    @IsTest
    static void testTriggerHandler_Update() {
        MovieDb__c record = new MovieDb__c(
            Title__c = 'Update Test',
            Duration__c = '1h 30m',
            Match_Score__c = '5.0/10'
        );
        insert record;

        record.Match_Score__c = '8.0/10';
        record.Is_Top_10__c = true;

        Test.startTest();
        update record;
        Test.stopTest();

        MovieDb__c result = [SELECT Match_Score_Value__c, Is_Featured__c FROM MovieDb__c WHERE Id = :record.Id];
        System.assertEquals(8.0, result.Match_Score_Value__c);
        System.assertEquals(true, result.Is_Featured__c);
    }

    @IsTest
    static void testTriggerHandler_Bulk() {
        List<MovieDb__c> records = new List<MovieDb__c>();
        for (Integer i = 0; i < 200; i++) {
            records.add(new MovieDb__c(
                Title__c = 'Bulk Test ' + i,
                Duration__c = '2h',
                Match_Score__c = '7.0/10'
            ));
        }

        Test.startTest();
        insert records;
        Test.stopTest();

        Integer featuredCount = [SELECT COUNT() FROM MovieDb__c WHERE Is_Featured__c = true];
        System.assertEquals(200, featuredCount);
    }
}
