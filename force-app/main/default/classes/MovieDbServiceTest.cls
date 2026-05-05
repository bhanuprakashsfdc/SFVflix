@IsTest
private class MovieDbServiceTest {
    @IsTest
    static void testProcessRecords_ParsesDurationAndScore() {
        MovieDb__c record = new MovieDb__c(
            Title__c = 'Test Movie',
            Duration__c = '2h 37m',
            Match_Score__c = '7.8/10',
            Is_Top_10__c = false
        );

        Test.startTest();
        new MovieDbService().processRecords(new List<MovieDb__c>{ record });
        Test.stopTest();

        System.assertEquals(157, record.Duration_Minutes__c, 'Duration should be 157 minutes');
        System.assertEquals(7.8, record.Match_Score_Value__c, 'Score should be 7.8');
        System.assertEquals('UA', record.Normalized_Rating__c, 'Default rating normalization');
        System.assertEquals(true, record.Is_Featured__c, 'High score should mark as featured');
    }

    @IsTest
    static void testProcessRecords_NormalizesRatings() {
        List<MovieDb__c> records = new List<MovieDb__c>();

        MovieDb__c r1 = new MovieDb__c(Title__c = 'Test1', Rating__c = 'U/A (India)');
        records.add(r1);

        MovieDb__c r2 = new MovieDb__c(Title__c = 'Test2', Rating__c = 'A');
        records.add(r2);

        MovieDb__c r3 = new MovieDb__c(Title__c = 'Test3', Rating__c = 'U');
        records.add(r3);

        new MovieDbService().processRecords(records);

        System.assertEquals('UA', r1.Normalized_Rating__c);
        System.assertEquals('A', r2.Normalized_Rating__c);
        System.assertEquals('U', r3.Normalized_Rating__c);
    }

    @IsTest
    static void testProcessRecords_GenresAndCast() {
        MovieDb__c record = new MovieDb__c(
            Title__c = 'Test Movie',
            Genres__c = 'Comedy;Drama;Romance',
            Cast__c = 'Actor1, Actor2, Actor3'
        );

        new MovieDbService().processRecords(new List<MovieDb__c>{ record });

        System.assertEquals('Comedy|Drama|Romance', record.Genre_List__c);
        System.assertEquals(3, record.Cast_Count__c);
    }

    @IsTest
    static void testProcessRecords_BuildsUrls() {
        String videoId = 'testVideo123';
        MovieDb__c record = new MovieDb__c(
            Title__c = 'Test Movie',
            Video_ID__c = videoId
        );

        new MovieDbService().processRecords(new List<MovieDb__c>{ record });

        System.assertEquals('https://img.youtube.com/vi/' + videoId + '/maxresdefault.jpg',
            record.YouTube_Thumbnail_1280__c);
        System.assertEquals('https://www.youtube.com/embed/' + videoId,
            record.YouTube_Embed_URL__c);
    }

    @IsTest
    static void testParseDuration_EdgeCases() {
        MovieDbService service = new MovieDbService();

        // Test various formats
        MovieDb__c r1 = new MovieDb__c(Duration__c = '2h 37m');
        service.processRecords(new List<MovieDb__c>{ r1 });
        System.assertEquals(157, r1.Duration_Minutes__c);

        MovieDb__c r2 = new MovieDb__c(Duration__c = '1h');
        service.processRecords(new List<MovieDb__c>{ r2 });
        System.assertEquals(60, r2.Duration_Minutes__c);

        MovieDb__c r3 = new MovieDb__c(Duration__c = '45m');
        service.processRecords(new List<MovieDb__c>{ r3 });
        System.assertEquals(45, r3.Duration_Minutes__c);

        MovieDb__c r4 = new MovieDb__c(Duration__c = 'The language entered is not supported at this time.');
        service.processRecords(new List<MovieDb__c>{ r4 });
        System.assertEquals(null, r4.Duration_Minutes__c);
    }

    @IsTest
    static void testDetermineFeatured_Logic() {
        MovieDb__c r1 = new MovieDb__c(Is_Top_10__c = true, Match_Score_Value__c = 5.0);
        new MovieDbService().processRecords(new List<MovieDb__c>{ r1 });
        System.assertEquals(true, r1.Is_Featured__c, 'Top 10 should be featured');

        MovieDb__c r2 = new MovieDb__c(Is_Top_10__c = false, Match_Score_Value__c = 8.5);
        new MovieDbService().processRecords(new List<MovieDb__c>{ r2 });
        System.assertEquals(true, r2.Is_Featured__c, 'High score should be featured');

        MovieDb__c r3 = new MovieDb__c(Is_Top_10__c = false, Match_Score_Value__c = 5.0);
        new MovieDbService().processRecords(new List<MovieDb__c>{ r3 });
        System.assertEquals(false, r3.Is_Featured__c, 'Low score and not top 10 should not be featured');
    }
}
