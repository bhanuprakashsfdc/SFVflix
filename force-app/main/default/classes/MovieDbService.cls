public class MovieDbService {
    public void processRecords(List<MovieDb__c> records) {
        for (MovieDb__c record : records) {
            if (record.Match_Score__c != null) {
                record.Match_Score_Value__c = parseScore(record.Match_Score__c);
            }
            if (record.Duration__c != null) {
                record.Duration_Minutes__c = parseDuration(record.Duration__c);
            }
            if (record.Rating__c != null) {
                record.Normalized_Rating__c = normalizeRating(record.Rating__c);
            }
            if (record.Genres__c != null) {
                record.Genre_List__c = record.Genres__c.replace(';', '|');
            }
            if (record.Cast__c != null) {
                String[] parts = record.Cast__c.split(',');
                record.Cast_Count__c = parts.size();
            }
            if (record.Video_ID__c != null) {
                record.YouTube_Thumbnail_1280__c = 'https://img.youtube.com/vi/' + record.Video_ID__c + '/maxresdefault.jpg';
                record.YouTube_Embed_URL__c = 'https://www.youtube.com/embed/' + record.Video_ID__c;
            }
            Boolean isTop10 = record.Is_Top_10__c != null && record.Is_Top_10__c;
            Decimal score = record.Match_Score_Value__c;
            record.Is_Featured__c = isTop10 || (score != null && score >= 7.0);
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
    public void enrichFromExternalSource(List<MovieDb__c> records, Set<String> ids) {}
}