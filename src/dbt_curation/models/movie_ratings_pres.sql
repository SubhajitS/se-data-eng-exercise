{{ config(materialized='table') }}

SELECT 
    movieId, 
    title,
    median,
    COUNT(1) AS numberOfRatings,
    DENSE_RANK() OVER (ORDER BY median DESC) AS rank
FROM
    (SELECT
        ratings.movieId, 
        movies.title,
        PERCENTILE_CONT(ratings.rating, 0.5) OVER(PARTITION BY ratings.movieId) AS median
    FROM 
        {{ ref("ratings_raw_to_curate") }} ratings
    INNER JOIN 
        {{ ref("movies_raw_to_curate") }} movies ON ratings.movieId=movies.id
    )
GROUP BY movieId,title,median
