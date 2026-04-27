select * from spotify_tracks

-----1.Retrieve the names of all tracks that have more than 1 billion streams.
select track from spotify_tracks
where stream>100000000

----2.List all albums along with their respective artists.
select distinct album,artist from spotify_tracks

----3.Get the total number of comments for tracks where licensed = TRUE.
select sum(comments) as total_comments from spotify_tracks
where licensed ='true'

----4.Find all tracks that belong to the album type single.
select track from spotify_tracks 
where album_type='single'

----5.Count the total number of tracks by each artist.
select artist,count(track) as total_tracks from spotify_tracks
group by artist
order by total_tracks desc

----6.Calculate the average danceability of tracks in each album.
select album,round(avg(danceability),2)as avg_danceability from spotify_tracks
group by album
order by avg_danceability desc

----7.Find the top 5 tracks with the highest energy values.
select top 5 track, avg(energy) as avg_energy from spotify_tracks
group by track
order by avg_energy desc

----8.List all tracks along with their views and likes where official_video = TRUE.
select track,sum(views)as total_views,sum(likes) as total_likes from spotify_tracks
where official_video=1
group by track
order by total_views desc,total_likes desc

----9.For each album, calculate the total views of all associated tracks.
select album,sum(views) as total_views from spotify_tracks 
group by album 

----10.Retrieve the track names that have been streamed on Spotify more than YouTube.
select track from spotify_tracks
where most_playedon='spotify'

----11.Find the top 3 most-viewed tracks for each artist using window functions.
with most_viewed as(select track,artist,views,
dense_rank() over (partition by artist order by views desc) as rnk  from spotify_tracks)
select track,artist,views,rnk from most_viewed
where rnk<=3

----12.Write a query to find tracks where the liveness score is above the average.
select track from spotify_tracks
where liveness>(select avg(liveness) as avg_liveness_score from spotify_tracks)

----13.Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with max_and_min_energy as (select album,
     max(energy)as max_energy,
     min(energy) as min_energy 
from spotify_tracks 
group by album
)
select album
      ,max_energy-min_energy as diff_energy
from max_and_min_energy
order by diff_energy desc

----14.Find tracks where the energy-to-liveness ratio is greater than 1.2.
with enery_ratio as(select track,(energy/liveness)as energy_to_liveness 
from spotify_tracks 
where liveness>0)
select track,energy_to_liveness 
from enery_ratio
where energy_to_liveness >1.2

----15.Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select track,likes
,sum(likes) over (partition by track order by views desc) as cumulative_sum from spotify_tracks