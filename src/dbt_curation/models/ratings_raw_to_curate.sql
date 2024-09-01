{{ config(
    alias='ratings_curate',
    materialized='incremental',
    unique_key=['userId','movieId'],
    on_schema_change='sync_all_columns'
) }}

WITH CURATED_DATA AS (
    SELECT 
        SAFE_CAST(userId as INT) AS userId,
        SAFE_CAST(movieId as INT) AS movieId,
        SAFE_CAST(rating as FLOAT64) AS rating,
        TIMESTAMP_SECONDS(SAFE_CAST(timestamp as INT64)) AS timestamp,
        CURRENT_TIMESTAMP() AS load_date
    FROM
        {{ source('raw_source', 'ratings_raw')}}
)

SELECT userId, movieId, rating, timestamp, load_date
FROM CURATED_DATA

{% if is_incremental() %}

where load_date >= (select coalesce(max(load_date),'1900-01-01') from {{ this }} )

{% endif %}