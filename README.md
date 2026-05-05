# MovieDb Salesforce Application

A complete Salesforce DX implementation for managing movie database entries, built on the `MovieDb__c` custom object with 28 fields, trigger-based automation, and a dedicated Lightning app.

## Object Overview

**Object:** `MovieDb__c` (Label: Movie Database)

**Purpose:** Store movie metadata scraped from YouTube sources with automated transformations and computed fields set via Apex triggers.

## Custom Fields (28 Total)

### Source Data Fields (20 fields)

| API Name | Label | Type | Description |
|----------|-------|------|-------------|
| `External_ID__c` | External Id | Text(20) | Unique identifier from source (External ID) |
| `Type__c` | Type | Picklist | Movie / Series / Documentary |
| `Input_Language__c` | Input Language | Picklist | Telugu / Tamil / Hindi / English / Malayalam / Kannada |
| `Title__c` | Title | Text(255) | Movie title |
| `Description__c` | Description | Long Text Area | Full synopsis |
| `YouTube_URL__c` | YouTube URL | Long Text Area | Source YouTube URL |
| `Video_ID__c` | Video ID | Text(50) | YouTube video identifier |
| `Thumbnail_URL__c` | Thumbnail URL | Long Text Area | Standard thumbnail |
| `Banner_Image_URL__c` | Banner Image URL | Long Text Area | Banner image |
| `Category__c` | Category | Picklist | Comedy / Drama / Romance / Action / Fantasy / etc. |
| `Year__c` | Year | Text(10) | Release year |
| `Rating__c` | Rating | Picklist | U/A (India) / U / A / UA |
| `Duration__c` | Duration | Text(50) | Human-readable (e.g. "2h 37m") |
| `Match_Score__c` | Match Score | Text(20) | Score like "7.8/10" |
| `Is_Top_10__c` | Is Top 10 | Checkbox | TRUE if top 10 |
| `Genres__c` | Genres | Multi-Select Picklist | Comedy;Drama;Romance;Action... |
| `Cast__c` | Cast | Long Text Area | Comma-separated actor names |
| `Movie_Language__c` | Movie Language | Picklist | Tamil / Telugu / Hindi / Malayalam / Kannada |
| `Full_URL__c` | Full URL | Long Text Area | Full source URL |
| `Trim_URL__c` | Trim URL | Long Text Area | Trimmed source URL |

### Derived/Computed Fields (8 fields - set by trigger, NO formula fields)

| API Name | Label | Type | Computed From |
|----------|-------|------|---------------|
| `Normalized_Rating__c` | Normalized Rating | Picklist | `Rating__c` (U/A → UA, A → A, U → U) |
| `Match_Score_Value__c` | Match Score Value | Number(3,1) | `Match_Score__c` ("7.8/10" → 7.8) |
| `Duration_Minutes__c` | Duration Minutes | Number | `Duration__c` ("2h 37m" → 157) |
| `Is_Featured__c` | Is Featured | Checkbox | `Is_Top_10__c` OR `Match_Score_Value__c >= 7.0` |
| `Genre_List__c` | Genre List | Text(500) | `Genres__c` (semicolon → pipe separated) |
| `Cast_Count__c` | Cast Count | Number | Count of comma-separated `Cast__c` |
| `YouTube_Thumbnail_1280__c` | YouTube Thumbnail 1280 | Long Text Area | Built from `Video_ID__c` |
| `YouTube_Embed_URL__c` | YouTube Embed URL | Long Text Area | Built from `Video_ID__c` |

## Apex Architecture

### Trigger
- **`MovieDbTrigger`** on `MovieDb__c` (before insert, before update)
- Delegates all logic to handler class

### Classes
- **`MovieDbTriggerHandler`** - Entry point for trigger logic, coordinates processing
- **`MovieDbService`** - Business logic layer:
  - `processRecords()` - Main processing method
  - `parseScore()` - Extracts numeric from "7.8/10"
  - `parseDuration()` - Converts "2h 37m" to minutes
  - `normalizeRating()` - Standardizes rating codes
  - `buildGenreList()` - Converts multiselect to pipe-delimited
  - `countCastMembers()` - Counts cast
  - `determineFeatured()` - Sets Is_Featured flag
  - `enrichFromExternalSource()` - Stub for future API enrichment

### Test Classes
- **`MovieDbServiceTest`** - Unit tests for all Service methods
- **`MovieDbTriggerHandlerTest`** - Integration tests for trigger behavior (bulk, update)

## Lightning Application

**App Name:** MovieDb App

**Features:**
- Custom tab for `MovieDb__c` object
- Custom page layout with organized sections:
  - Basic info (Title, Type, Language, Year)
  - Description
  - Video URLs & Thumbnails
  - Classification (Rating, Duration, Score, Top 10)
  - Content Details (Category, Genres, Cast)
  - System fields (External ID, URLs)
- Custom button "View on YouTube" on detail page
- App navigation configured in Permission Set

## Permission Set

**`MovieDb_Access`** grants:
- Full CRUD on `MovieDb__c` object
- Read access to all 28 fields
- Edit access to all source data fields (20 fields)
- Read-only for computed fields (8 derived fields)
- Access to `MovieDbTriggerHandler` and `MovieDbService` classes
- Tab visibility and app visibility

## Deployment

### Prerequisites
- Salesforce DX CLI installed
- Authenticated to target org with `sfdx`

### Deploy
```bash
sfdx force:source:deploy -p force-app
```

### Run Tests
```bash
sfdx force:apex:test:run -c -r human
```

## Data Model Reference

This implementation aligns with the Google Sheets data model provided, with each column mapped to a corresponding Salesforce field. All transformations happen in Apex triggers - no formula fields are used.

## Notes
- All computed fields are `before insert/update` trigger context for optimal performance
- External ID field (`External_ID__c`) enabled for upsert operations
- Multi-select picklist for `Genres__c` stored as semicolon-delimited; `Genre_List__c` stores pipe-delimited version for easier SOQL queries
- `enrichFromExternalSource()` method is a stub for future YouTube API integrations
