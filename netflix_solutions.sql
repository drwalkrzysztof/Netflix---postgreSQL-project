--Netflix Project

CREATE TABLE netflix(
						show_id VARCHAR(6),
						type	VARCHAR(10),
						title	VARCHAR(150),
						director	VARCHAR(208),
						casts	VARCHAR(1000),
						country	VARCHAR(200),
						date_added	VARCHAR(50),
						release_year	int,
						rating	VARCHAR(10),
						duration	VARCHAR(15),
						listed_in	VARCHAR(79),
						description VARCHAR(250)

);

SELECT * FROM netflix;


-- 15 Busienss Problems 

-- 1. Count the Number of Movies vs TV Shows

SELECT 
		type,
		COUNT(*) as total_content
FROM netflix
GROUP BY type;


-- 2. Find the most common rating for a movie and TV Shows 

SELECT	
		type,
		rating
FROM 
(
	SELECT 
			type,
			rating,
			COUNT(*),
			RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) as ranking
	FROM netflix
	GROUP BY 1, 2
	) as t1
WHERE
	ranking = 1


-- 3. List all the movies released in a specific year (e.g.,2020)
--Movie
--year 2020
SELECT * FROM netflix WHERE release_year =2020 AND type ='Movie'

-- 4. Find the top 5 countries with the most content on Netflix 

SELECT 
	TRIM(UNNEST(STRING_TO_ARRAY(country,','))) as new_country,
	COUNT(*) as productions
FROM netflix
WHERE country IS NOT NULL 
GROUP BY 1
ORDER BY productions DESC 
LIMIT 5;

-- 5. Identify the longest movie

SELECT 
	title,
	MAX(CAST(REPLACE(duration,'min','')AS INTEGER)) as duration_in_min
FROM netflix
WHERE type ='Movie' AND duration IS NOT NULL
GROUP BY title
ORDER BY 2 DESC

-- 6. Find the content added in the last 5 years 

SELECT *
FROM netflix 
WHERE 
	TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

-- 7. Find all the movies/TV shows by director 'Barbra Streisand'

SELECT * FROM netflix WHERE director ILIKE '%Barbra Streisand%'

-- 8. List all the TV shows with more then 5 seasons

SELECT
	*
FROM netflix 
WHERE type = 'TV Show' 
	AND SPLIT_PART(duration,' ', 1)::numeric > 5 

-- 9. Count the number of content items in each genre

SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in,','))as genre,
	COUNT(show_id) as total_content
FROM netflix 
GROUP BY 1;

-- 10. Find each year and the average number number of contant release by Australia on netflix. 
--	Return top 5 year with highest avg content release!

SELECT
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD,YYYY')) as release_year,
	COUNT(*),
	ROUND(COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country ='Australia')::numeric *100,2) as avg_content_per_year	
FROM netflix
WHERE country ILIKE '%Australia%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- 11. List all the movies which are documentaries 

SELECT 
	*,
	listed_in
FROM netflix
WHERE listed_in ILIKE '%documentaries%'

-- 12. Find all content without a director

SELECT 
	*
FROM netflix 
WHERE director is NULL

-- 13. Find how many movies actor 'Hugh Jackman' appeared in last 20 years 

SELECT * 
FROM netflix
WHERE casts ILIKE '%Hugh Jackman%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 20

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in Australia 

SELECT
	UNNEST(STRING_TO_ARRAY(casts,',')),
	COUNT (*) as total_content
FROM netflix
WHERE country ILIKE'%Australia%'
GROUP BY 1
ORDER BY 2 DESC;

--15. Categorize the content based on the presence of the keywords 'kill' and 'violence' in the descrption field.
--Label content containing these keywords as 'bad' and all other content as 'good'. Count how many items fall into each category. 

WITH new_table as 
(
SELECT *,
	CASE
		WHEN 	description ILIKE '%kill%' OR 
				description ILIKE '%violence%' THEN 'Bad_Content'
				ELSE 'Good_Content'
		END category
FROM netflix
)
SELECT
	category, 
	COUNT(*) as total_content
	FROM new_table
	GROUP BY 1