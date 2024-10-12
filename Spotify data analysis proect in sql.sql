create database Spotify_SQL_project;

use Spotify_SQL_project;

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

select count(*) from cleaned_dataset;
select * from cleaned_dataset;
-- artist
select count(distinct(artist)) from cleaned_dataset;
-- album
select count(distinct(album)) from cleaned_dataset;
-- album_type
select distinct(album_type) from cleaned_dataset;

--  duration_min
select avg(duration_min) from cleaned_dataset;

select min(duration_min) from cleaned_dataset;

select * from cleaned_dataset where duration_min = 0;
SET SQL_SAFE_UPDATES = 0;
delete from cleaned_dataset where duration_min = 0;
SET SQL_SAFE_UPDATES = 1;
select * from cleaned_dataset where duration_min = 0;

-- channel
select distinct(channel) from cleaned_dataset;

select count(distinct(channel)) from cleaned_dataset;

-- Easy Level
-- 1.Retrieve the names of all tracks that have more than 1 billion streams.

select track,stream from cleaned_dataset where stream > 1000000000 order by stream desc;

select count(track) from cleaned_dataset where stream > 1000000000 order by stream desc;

-- 2.List all albums along with their respective artists.
select Album,Artist from cleaned_dataset;

select Artist,count(*) from cleaned_dataset group by Artist;

-- 3.Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments from cleaned_dataset where licensed = 'true';

-- 4.Find all tracks that belong to the album type single.
select Track,Album,Album_type from cleaned_dataset where Album_type = 'single';

-- 5.Count the total number of tracks by each artist.

SELECT 
    Artist, COUNT(Artist) AS total_songs
FROM
    cleaned_dataset
GROUP BY Artist
ORDER BY COUNT(Artist) DESC;

SELECT 
    Artist, COUNT(Artist) AS total_songs
FROM
    cleaned_dataset
GROUP BY Artist
ORDER BY COUNT(Artist) ASC;

-- Medium Level

-- 1.Calculate the average danceability of tracks in each album.


SELECT 
    Album, AVG(Danceability) AS Dance
FROM
    cleaned_dataset
GROUP BY Album
ORDER BY AVG(Danceability) DESC;

-- 2.Find the top 5 tracks with the highest energy values.
select Track,Energy from cleaned_dataset order by Energy desc limit 5;

-- 3.List all tracks along with their views and likes where official_video = TRUE.
 
  select Track,sum(Views),sum(Likes) 
 from cleaned_dataset where official_video = 'true' group by
 Track order by sum(Views) desc;
 
 -- 4.For each album, calculate the total views of all associated tracks.
SELECT Album, 
       Track, 
       SUM(Views) OVER(PARTITION BY Album ORDER BY Views desc) as cum 
FROM cleaned_dataset order by cum desc;

-- Advanced Level
-- 1.Find the top 3 most-viewed tracks for each artist using window functions.
select * from cleaned_dataset;

with top_3_art as (select Artist,Track,sum(Views) as total_views,
dense_rank() over(partition by Artist order by sum(Views) desc) as rank_number
from cleaned_dataset group by Artist,Track order by Artist,total_views desc) 
select * from top_3_art where rank_number <=3;

-- 2.Write a query to find tracks where the liveness score is above the average.
select Track,Liveness from cleaned_dataset where Liveness >(
select avg(Liveness) as Avg_liveness from cleaned_dataset) order by Liveness desc;


-- 3.Use a WITH clause to calculate the difference 
-- between the highest and lowest energy values for tracks in each album.

select * from cleaned_dataset;

with energy_difference as (select Album,
max(energy) as highest_energy,
min(energy) as lowest_energy from cleaned_dataset
group by Album)
select *,(highest_energy-lowest_energy) as differene from energy_difference;


