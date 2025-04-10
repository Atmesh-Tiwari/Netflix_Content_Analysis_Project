# Netflix_Content_Analysis_Project
![Netflix logo](https://github.com/Atmesh-Tiwari/Netflix_Content_Analysis_Project/blob/main/N_Logo_Alpha.png)

## Problem Statement
As part of netflix's ongoing efforts to optimize our global content strategy and better align with viewer preferences, the Content Strategy team is seeking a comprehensive analysis of the Netflix content library. The task is to explore and uncover actionable insights from our content catalog across dimensions such as content type, ratings, genres, regional performance, and key contributors (directors, actors).

We are particularly interested in understanding the following:

- Content Type Distribution: How is our catalog divided between Movies and TV Shows? This helps us assess content strategy balance.

- Audience Ratings Patterns: What are the most common ratings, and how do they vary between content types? This will assist in aligning acquisitions and production with target demographics.

- Content Availability by Geography: Which countries dominate our catalog, and how does India's release pattern compare over time?

- Influential Contributors: Who are the most frequent directors and actors, particularly in the Indian market? This aids talent partnerships and localization strategy.

- Keyword-Based Sentiment Categorization: Can we flag content as potentially sensitive based on themes like “kill” or “violence”?

- Content Lifecycle and Trends: What is the age of our catalog? Are we adding more recent content, and how frequently?

- Genre and Format Trends: What are our strongest genres? How do season lengths of TV Shows vary?

## Objectives & Deliverables

Conduct an exploratory data analysis (EDA) using the provided Netflix dataset. Your SQL-driven insights should help answer strategic questions across content distribution, genre dominance, audience suitability, geographic preferences, and contributor influence. This will directly support decisions related to content acquisition, recommendation optimization, and regional strategy development.

- Clear, concise SQL queries addressing each business problem
- Summary of findings with charts or tables (if applicable)
- Key recommendations based on the insights
- Highlight any data limitations or improvement suggestions

## Dataset 
![Dataset_link](https://www.kaggle.com/datasets/shivamb/netflix-shows)

## Schema

```sql
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## SQL Exploratory Queries

## Business Problems and Solutions

1. Count the Number of Movies vs TV Shows
Objective: Determine the distribution of content types on Netflix.

```sql
SELECT type, COUNT(*) AS Total_Content
FROM netflix
GROUP BY type;
```

2. Find the Most Common Rating for Movies and TV Shows
Objective: Identify the most frequently occurring rating for each type of content.

```sql
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
```
  
3. List All Movies Released in a Specific Year (e.g., 2020)
Objective: Retrieve all movies released in a specific year.
```sql
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
```

5. Identify the Longest Movie
Objective: Find the movie with the longest duration.
```sql
SELECT *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

6. Find Content Added in the Last 5 Years
Objective: Retrieve content added to Netflix in the last 5 years.
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
Objective: List all content directed by 'Rajiv Chilaka'.
```sql
SELECT *
FROM (
    SELECT 
        *,
        UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name
    FROM netflix
) AS t
WHERE director_name = 'Rajiv Chilaka';
```

8. List All TV Shows with More Than 5 Seasons
Objective: Identify TV shows with more than 5 seasons.
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
  AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

9. Count the Number of Content Items in Each Genre
Objective: Count the number of content items in each genre.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;
```

10. Find each year and the average numbers of content release in India on Netflix.
Return top 5 years with highest avg content release!
Objective: Calculate and rank years by the average number of content releases by India.
```
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
```

11. List All Movies that are Documentaries
Objective: Retrieve all movies classified as documentaries.
```sql
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries%';
```

12. Find All Content Without a Director
Objective: List content that does not have a director.
```sql
SELECT * 
FROM netflix
WHERE director IS NULL;
```

13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
Objective: Count the number of movies featuring 'Salman Khan' in the last 10 years.
```sql
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
  AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
Objective: Identify the top 10 actors with the most appearances in Indian-produced movies.
```sql
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;
```

15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
Objective: Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.
```sql
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
```

## Findings and conclusion 
### Content Distribution: 
- The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
### Common Ratings: 
- Insights into the most common ratings provide an understanding of the content's target audience.
### Geographical Insights: 
- The top countries and the average content releases by India highlight regional content distribution.
### Content Categorization: 
- Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
