--Advanced SQL  project --spotify 


-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select COUNT(*) from spotify

select count(distinct(album)) from spotify

Q1--the names of all tracks that have more than 1 billion streams

select track from spotify 
 where stream > 1000000000


Q2-- removing table that have duration min = 0 or null
select  * from spotify where duration_min = 0
DELETE from spotify where duration_min = 0

Q3--all albums along with their respective artists.

select * from spotify

select distinct album,artist  from spotify order by 1 

Q4--Get the total number of comments for tracks where licensed = TRUE:

select SUM(comments) as total_comments from spotify where licensed = 'true'  

Q5--Find all tracks that belong to the album type single:

select * from spotify where album_type = 'single'


Q6--Count the total number of tracks by each artist:

select artist,count(*) as total_number_of_trackes from spotify group by 1 order by 2 ASC

Q7--Calculate the average danceability of tracks in each album:

select * from spotify 

select album, AVG(danceability) as the_average_of_danceability from spotify group by 1 order by 2  DESC

Q8--Find the top 5 tracks with the highest energy values :

 select track, MAX (energy)  from spotify group by 1 order by 2 DESC limit 5 

Q9--List all tracks along with their views and likes where official_video = TRUE : 

select track,SUM(views) as total_views,SUM(likes) as total_likes from spotify where official_video ='true' group by 1 order by 2 DESC limit 5 


Q10--For each album, calculate the total views of all associated tracks:

select album,track,SUM(views) as total_views from spotify group by 1,2 order by 3 DESC limit 10 

Q11--Retrieve the track names that have been streamed on Spotify more than YouTube:

select * from spotify 

with cte as ( select track,--most_played_on 
  COALESCE (SUM(case when most_played_on = 'Spotify' then stream end ),0) as streamed_on_spotify , 
  COALESCE (SUM (case when most_played_on = 'Youtube' then  stream end ),0) as streamed_on_youtube
from spotify 
group by 1 )
select * from cte where streamed_on_spotify > streamed_on_youtube and streamed_on_youtube <> 0

Q12--Find the top 3 most-viewed tracks for each artist using window functions:

with cte as (select artist,track,sum(views) as total_views, dense_rank() over(  partition by artist order by sum(views) DESC) as rk  from spotify  

group by 1,2 order by 1,3  DESC)

select artist,track from cte where rk <= 3


Q13--Write a query to find tracks where the liveness score is above the average :

select artist,track,liveness from spotify where liveness > 

(select AVG(liveness) AS avg_liv
    FROM spotify )
    
Q14--Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album : 


WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC

Q15--Find tracks where the energy-to-liveness ratio is greater than 1.2 : 



select track from spotify where energy_liveness > 1.2


Q16--Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions : 

 select track,sum(likes) sum_of_likes,sum(views) as number_of_views,

 
dense_rank()over( order by sum(views) DESC ) as rk from spotify group by 1 order by sum(views)  DESC limit 10 




