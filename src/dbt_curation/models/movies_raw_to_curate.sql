{{ config(alias='movies_curate') }}
WITH CURATED_DATA AS (
    SELECT 
        CASE
            WHEN adult='True' THEN true
            WHEN adult='False' THEN false
            ELSE null
        END AS adult,
        TO_JSON(belongs_to_collection) AS belongs_to_collection,
        SAFE_CAST(budget as BIGDECIMAL) AS budget,
        TO_JSON(genres) AS genres,
        RTRIM(homepage, '/') AS homepage,
        SAFE_CAST(id as INT) AS id,
        TRIM(imdb_id) AS imdb_id,
        TRIM(original_language) AS original_language,
        TRIM(original_title) AS original_title,
        CASE
            WHEN LOWER(overview)="no overview" THEN null
            WHEN LOWER(overview)="no overview found." THEN null
            WHEN LOWER(overview)="No movie overview available." THEN null
            WHEN TRIM(overview)="" THEN null
            ELSE overview
        END AS overview,
        SAFE_CAST(popularity as DECIMAL) AS popularity,
        TRIM(poster_path) AS poster_path,
        TO_JSON(production_companies) AS production_companies,
        TO_JSON(production_countries) AS production_countries,
        SAFE_CAST(release_date as DATE) AS release_date,
        SAFE_CAST(revenue as BIGDECIMAL) AS revenue,
        SAFE_CAST(runtime as FLOAT64) AS runtime,
        TO_JSON(spoken_languages) AS spoken_languages,
        TRIM(status) AS status,
        TRIM(tagline) AS tagline,
        TRIM(title) AS title,
        CASE
            WHEN video='True' THEN true
            WHEN video='False' THEN false
            ELSE null
        END AS video,
        SAFE_CAST(vote_average as FLOAT64) AS vote_average,
        SAFE_CAST(vote_count as INT) AS vote_count,
        load_date
    FROM {{ source('raw_source', 'movies_raw') }}
)

SELECT 
    adult, 
    belongs_to_collection,
    budget,
    genres,
    homepage,
    id,
    imdb_id,
    original_language,
    original_title,
    overview,
    popularity,
    poster_path,
    production_companies,
    production_countries,
    release_date,
    revenue,
    runtime,
    spoken_languages,
    status,
    tagline,
    title,
    video,
    vote_average,
    vote_count,
    load_date
FROM CURATED_DATA