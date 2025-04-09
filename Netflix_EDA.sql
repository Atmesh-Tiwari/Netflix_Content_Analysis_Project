CREATE TABLE netflix
(
show_id VARCHAR(10),	
type VARCHAR(10),	
title VARCHAR(150),	
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
);


--Business Problems and Solutions
/*
1. Count the Number of Movies vs TV Shows
Objective: Determine the distribution of content types on Netflix.
*/
Select type, Count(*) as Total_Content
from netflix
Group by type;

/*
2. Find the Most Common Rating for Movies and TV Shows
Objective: Identify the most frequently occurring rating for each type of content.
*/
WITH RatingCounts AS (
    SELECT 
        type,
        rating,
        COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT 
        type,
        rating,
        rating_count,
        RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT 
    type,
    rating AS most_frequent_rating
FROM RankedRatings
WHERE rank = 1;


/*
3. List All Movies Released in a Specific Year (e.g., 2020)
Objective: Retrieve all movies released in a specific year.
*/
SELECT * 
FROM netflix
WHERE release_year = 2020;


/*
4. Find the Top 5 Countries with the Most Content on Netflix
Objective: Identify the top 5 countries with the highest number of content items.
*/
SELECT * 
FROM
(
    SELECT 
        UNNEST(STRING_TO_ARRAY(country, ',')) AS country,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;


/*
5. Identify the Longest Movie
Objective: Find the movie with the longest duration.
*/
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;


/*
6. Find Content Added in the Last 5 Years
Objective: Retrieve content added to Netflix in the last 5 years.
*/
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


/*
7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
Objective: List all content directed by 'Rajiv Chilaka'.
*/
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';


/*
8. List All TV Shows with More Than 5 Seasons
Objective: Identify TV shows with more than 5 seasons.
*/
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;


/*
9. Count the Number of Content Items in Each Genre
Objective: Count the number of content items in each genre.
*/
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;


/*
10.Find each year and the average numbers of content release in India on netflix.
return top 5 year with highest avg content release!
Objective: Calculate and rank years by the average number of content releases by India.
*/
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


/*
11. List All Movies that are Documentaries
Objective: Retrieve all movies classified as documentaries.
*/
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';


/*
12. Find All Content Without a Director
Objective: List content that does not have a director.
*/
SELECT * 
FROM netflix
WHERE director IS NULL;


/*
13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
*/
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;


/*
14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.
*/
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


/*
15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
*/
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad'
            ELSE 'Good'
        END AS category
    FROM netflix
) AS categorized_content
GROUP BY category;