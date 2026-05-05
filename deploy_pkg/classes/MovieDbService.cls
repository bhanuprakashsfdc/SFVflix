public class MovieDbService {
    public void processRecords(List<bhanu9666__MoviesDB__c> records) {
        for (bhanu9666__MoviesDB__c record : records) {
            if (record.bhanu9666__Match_Score__c != null) {
                record.bhanu9666__Match_Score_Value__c = parseScore(record.bhanu9666__Match_Score__c);
            }
            if (record.bhanu9666__Duration__c != null) {
                record.bhanu9666__Duration_Minutes__c = parseDuration(record.bhanu9666__Duration__c);
            }
            if (record.bhanu9666__Rating__c != null) {
                record.bhanu9666__Normalized_Rating__c = normalizeRating(record.bhanu9666__Rating__c);
            }
            if (record.bhanu9666__Genres__c != null) {
                record.bhanu9666__Genre_List__c = record.bhanu9666__Genres__c.replace(';', '|');
            }
            if (record.bhanu9666__Cast__c != null) {
                String[] parts = record.bhanu9666__Cast__c.split(',');
                record.bhanu9666__Cast_Count__c = parts.size();
            }
            if (record.bhanu9666__Video_ID__c != null) {
                record.bhanu9666__YouTube_Thumbnail_1280__c = 'https://img.youtube.com/vi/' + record.bhanu9666__Video_ID__c + '/maxresdefault.jpg';
                record.bhanu9666__YouTube_Embed_URL__c = 'https://www.youtube.com/embed/' + record.bhanu9666__Video_ID__c;
            }
            Boolean isTop10 = record.bhanu9666__Is_Top_10__c != null && record.bhanu9666__Is_Top_10__c;
            Decimal score = record.bhanu9666__Match_Score_Value__c;
            record.bhanu9666__Is_Featured__c = isTop10 || (score != null && score >= 7.0);
        }
    }
    private Decimal parseScore(String s) {
        try { return Decimal.valueOf(s.replaceAll('/.*', '').trim()); } catch(Exception e) { return null; }
    }
    private Integer parseDuration(String s) {
        Integer m = 0;
        if (s != null) {
            if (s.contains('h')) m += Integer.valueOf(s.substringBefore('h')) * 60;
            if (s.contains('m')) m += Integer.valueOf(s.substringAfter('h').substringBefore('m').replaceAll('[^0-9]', ''));
        }
        return m == 0 ? null : m;
    }
    private String normalizeRating(String r) {
        if (r == null) return null;
        String u = r.toUpperCase();
        if (u.contains('U/A') || u.contains('UA')) return 'UA';
        if (u.contains('A')) return 'A';
        if (u.contains('U')) return 'U';
        return 'Not_Rated';
    }
    public void enrichFromExternalSource(List<bhanu9666__MoviesDB__c> records, Set<String> ids) {}
}