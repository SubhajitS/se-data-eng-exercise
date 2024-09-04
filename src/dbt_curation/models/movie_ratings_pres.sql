{{ config(materialized='table') }}

WITH MOVIE_BY_MEDIAN_RATING AS (
    SELECT
        ratings.movieId, 
        movies.title,
        PERCENTILE_CONT(ratings.rating, 0.5) OVER(PARTITION BY ratings.movieId) AS median
    FROM 
        {{ ref("ratings_curate") }} ratings
    INNER JOIN 
        {{ ref("movies_curate") }} movies ON ratings.movieId=movies.id
)
SELECT 
    movieId, 
    title,
    median,
    COUNT(1) AS numberOfRatings,
    DENSE_RANK() OVER (ORDER BY median DESC) AS rank
FROM
    MOVIE_BY_MEDIAN_RATING
GROUP BY movieId,title,median
