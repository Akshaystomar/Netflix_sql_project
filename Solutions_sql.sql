-- Netflix Project

Create Table netflix (
show_id	varchar(6),
type varchar(10),	
title varchar(150),
director varchar(208),
casts varchar(1000),
country varchar(150),
date_added varchar(50),
release_year int,
rating varchar(10),
duration varchar(15),
listed_in varchar(100),
description varchar(250)
);

select * from netflix;

Select count(*) as Total_Content from netflix

select distinct type from netflix;

select * from netflix;

-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows

Select type, count(*) as Total_count from netflix group by type;

-- 2. Find the most common rating for movies and TV shows

Select type, rating
from
(
select type, rating, count(*), 
rank() over(Partition by type Order by count(*) Desc)  as ranking
from netflix
group by 1, 2 ) as t1
where ranking = 1

-- 3. List all movies released in a specific year (e.g., 2020)

select * from netflix where type = 'Movie' And release_year = 2020

-- 4. Find the top 5 countries with the most content on Netflix

Select trim(unnest(String_to_array(country, ','))) as new_country, COUNT(show_id) as total_content 
from netflix group by 1 order by total_content desc limit 5;

-- 5. Identify the longest movie

SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

6. Find content added in the last 5 years

Select * from netflix where To_Date(date_added, 'FMMonth DD, YYYY') >= Current_Date - Interval '5 years'

7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

Select * from netflix where director = 'Rajiv Chilaka'

8. List all TV shows with more than 5 seasons

select * from netflix
where type = 'TV Show' And SPLIT_PART(duration, ' ', 1)::INT > 5;

9. Count the number of content items in each genre

select trim(unnest(string_to_array(listed_in, ','))) as genre,
count(*) as total_content from netflix group by 1;

10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!

select release_year, count(*) as Total_Release, avg(count(*)) over() as Avg_release_all_years from netflix 
where country like '%India%'
group by release_year
order by Total_release desc
limit 5;

11. List all movies that are documentaries

select * from netflix where type = 'Movie' And listed_in ilike '%Documentaries%'

12. Find all content without a director

Select * from netflix
where director is Null

13. Find how many movies actor 'Salman Khan' appeared in last 10 years!

Select * from netflix
where casts ilike '%Salman Khan%' And
release_year >= Extract(Year from current_date) - 10;

14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

Select trim(unnest(string_to_array(casts, ','))), count(*) as Total_movies from netflix
where country ilike '%India%'
group by 1
order by Total_movies desc
limit 10;

15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category

Select
  case
	  when description ilike'%kill%'
	  or description ilike '%Violence'
	  then 'Bed'
	  else 'Good'
End as Category,
Count(*) as Total_Content
from netflix
group by category
