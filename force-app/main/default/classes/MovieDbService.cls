public class MovieDbService {
    /**
     * Process records: compute derived fields, parse durations/scores, normalize URLs
     */
    public void processRecords(List<MovieDb__c> records) {
        for (MovieDb__c record : records) {
            // Parse Match Score to numeric value
            if (record.Match_Score__c != null) {
                record.Match_Score_Value__c = parseScore(record.Match_Score__c);
            }

            // Parse Duration to minutes
            if (record.Duration__c != null) {
                record.Duration_Minutes__c = parseDuration(record.Duration__c);
            }

            // Normalize rating
            if (record.Rating__c != null) {
                record.Normalized_Rating__c = normalizeRating(record.Rating__c);
            }

            // Build Genre_List pipe-separated string
            if (record.Genres__c != null) {
                record.Genre_List__c = buildGenreList(record.Genres__c);
            }

            // Count cast members
            if (record.Cast__c != null) {
                record.Cast_Count__c = countCastMembers(record.Cast__c);
            }

            // Build YouTube Thumbnail 1280 URL
            if (record.Video_ID__c != null) {
                record.YouTube_Thumbnail_1280__c = 'https://img.youtube.com/vi/' + record.Video_ID__c + '/maxresdefault.jpg';
            }

            // Standardize YouTube Embed URL
            if (record.Video_ID__c != null) {
                record.YouTube_Embed_URL__c = 'https://www.youtube.com/embed/' + record.Video_ID__c;
            }

            // Determine if featured
            determineFeatured(record);
        }
    }

    /**
     * Parse score like "7.8/10" to decimal 7.8
     */
    private Decimal parseScore(String score) {
        try {
            String clean = score.replaceAll('/.*', '').trim();
            return Decimal.valueOf(clean);
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Parse duration like "2h 37m" to total minutes
     */
    private Integer parseDuration(String duration) {
        Integer totalMinutes = 0;
        Pattern hoursPattern = Pattern.compile('(\\d+)h');
        Pattern minsPattern = Pattern.compile('(\\d+)m');

        Matcher hoursMatcher = hoursPattern.matcher(duration);
        Matcher minsMatcher = minsPattern.matcher(duration);

        if (hoursMatcher.find()) {
            totalMinutes += Integer.valueOf(hoursMatcher.group(1)) * 60;
        }
        if (minsMatcher.find()) {
            totalMinutes += Integer.valueOf(minsMatcher.group(1));
        }
        return totalMinutes == 0 ? null : totalMinutes;
    }

    /**
     * Normalize rating picklist to standardized code
     */
    private String normalizeRating(String rating) {
        if (rating == null) return null;

        String upper = rating.toUpperCase();
        if (upper.contains('U/A') || upper.contains('UA')) {
            return 'UA';
        } else if (upper.contains('A')) {
            return 'A';
        } else if (upper.contains('U')) {
            return 'U';
        }
        return 'Not_Rated';
    }

    /**
     * Build pipe-separated genre list from multiselect picklist
     */
    private String buildGenreList(String genres) {
        if (genres == null) return null;
        // Genres are stored as ';' separated in multiselect picklist
        return genres.replace(';', '|');
    }

    /**
     * Count cast members from comma-separated string
     */
    private Integer countCastMembers(String cast) {
        if (cast == null || cast.trim().isEmpty()) return 0;
        String[] members = cast.split(',');
        return members.size();
    }

    /**
     * Set Is_Featured__c based on Match_Score_Value__c and Is_Top_10__c
     */
    private void determineFeatured(MovieDb__c record) {
        Boolean isTop10 = record.Is_Top_10__c != null && record.Is_Top_10__c;
        Decimal score = record.Match_Score_Value__c;

        Boolean isHighScore = score != null && score >= 7.0;
        record.Is_Featured__c = isTop10 || isHighScore;
    }

    /**
     * Enrich records with data from external source (stub for future API calls)
     */
    public void enrichFromExternalSource(List<MovieDb__c> records, Set<String> videoIds) {
        // Placeholder for future external API enrichment
        // Could call YouTube API to get actual stats, etc.
        // For now, just a stub to maintain architecture
    }
}
