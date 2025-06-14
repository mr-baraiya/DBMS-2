CREATE DATABASE CSE_4A_223;

USE CSE_4A_223;
select * from Artists;
select * from Albums;
select * from Songs;

--Part � A
--1. Retrieve a unique genre of songs.
SELECT DISTINCT Genre FROM Songs;

--2. Find top 2 albums released before 2010.
SELECT TOP 2 * FROM Albums
WHERE Release_year < 2010;

--3. Insert Data into the Songs Table. (1245, �Zaroor�, 2.55, �Feel good�, 1005)
INSERT INTO Songs VALUES (1245, 'Zaroor', 2.55, 'Feel good', 1005);
select * from Songs;

--4. Change the Genre of the song �Zaroor� to �Happy�
UPDATE Songs
SET Genre = 'Happy'
WHERE Genre = 'Zaroor';
select * from Songs;

--5. Delete an Artist �Ed Sheeran�
DELETE FROM Artists
WHERE Artist_name = 'Ed Sheeran';
select * from Artists;

--6. Add a New Column for Rating in Songs Table. [Ratings decimal(3,2)]
alter table Songs
add Ratings decimal(3,2);
select * from Songs;

--7. Retrieve songs whose title starts with 'S'.
select * from Songs
where Song_title like 'S%';

--8. Retrieve all songs whose title contains 'Everybody'.
select * from Songs
where Song_title like '%Everybody%';

--9. Display Artist Name in Uppercase.
select UPPER(Artist_name) as Artist_Name_in_upper from Artists;

--10. Find the Square Root of the Duration of a Song �Good Luck�
select SQRT(Duration) from Songs
where Song_title = 'Good Luck';

--11. Find Current Date.
select GETDATE() as CurrentDate;

--12. Find the number of albums for each artist.
select Artist_name , count(Album_id) as No_Album
from Artists join Albums
on Artists.Artist_id = Albums.Artist_id
group by Artists.Artist_name;

--13. Retrieve the Album_id which has more than 5 songs in it.
select Album_id , count(Song_id) 
from Songs
group by Album_id
having count(Song_id) > 5;

--14. Retrieve all songs from the album 'Album1'. (using Subquery)
select Song_title from Songs
where Album_id = (select Album_id from Albums where Album_title = 'Album1');

--15. Retrieve all albums name from the artist �Aparshakti Khurana� (using Subquery)
select Album_title from Albums
where Artist_id = (select Artist_id from Artists where Artist_name = 'Aparshakti Khurana');

--16. Retrieve all the song titles with its album title.
select Song_title , Album_title 
from Songs s join Albums a
on s.Album_id = a.Album_id;

--17. Find all the songs which are released in 2020.
select Song_title , Release_year
from Songs s join Albums a
on s.Album_id = a.Album_id
where Release_year = 2020;

--18. Create a view called �Fav_Songs� from the songs table having songs with song_id 101-105.
create view Fav_Songs 
AS
select Song_id , Song_title from Songs
where Song_id between 101 and 105;

select * from Fav_Songs;

--19. Update a song name to �Jannat� of song having song_id 101 in Fav_Songs view.
Update Fav_Songs
set Song_title = 'Jannat'
where Song_id = 101;

--20. Find all artists who have released an album in 2020.
select Artist_name , Release_year 
from Artists ar join Albums al
on ar.Artist_id = al.Artist_id
where Release_year = 2020;

--21. Retrieve all songs by Shreya Ghoshal and order them by duration.
select Artist_name , Song_title , Duration
FROM Songs 
JOIN Albums ON Songs.Album_id = Albums.Album_id 
JOIN Artists ON Artists.Artist_id = Albums.Artist_id 
WHERE Artists.Artist_name = 'Shreya Ghoshal' 
ORDER BY Songs.DURATION;

--Part � B
--22. Retrieve all song titles by artists who have more than one album.
SELECT S.SONG_TITLE
FROM Songs S
JOIN Albums A ON S.Album_id = A.Album_id
JOIN Artists AR ON A.Artist_id = AR.Artist_id
WHERE AR.Artist_id IN (
    SELECT Artist_id
    FROM Albums
    GROUP BY Artist_id
    HAVING COUNT(DISTINCT Album_id) > 1
);
--23. Retrieve all albums along with the total number of songs.
select Album_title , COUNT(Song_id) AS Toal_song
from Albums a join Songs s
on a.Album_id = s.Album_id
group by Album_title;

--24. Retrieve all songs and release year and sort them by release year.
select Song_title , Release_year
from Albums a join Songs s
on a.Album_id = s.Album_id
order by Release_year;

--25. Retrieve the total number of songs for each genre, showing genres that have more than 2 songs.
select Genre , count(Song_title)
from Songs
group by Genre
having count(Song_title) > 2;

--26. List all artists who have albums that contain more than 3 songs.
SELECT ARTISTS.ARTIST_NAME
FROM ARTISTS
JOIN ALBUMS ON ARTISTS.ARTIST_ID = ALBUMS.ARTIST_ID
JOIN SONGS ON ALBUMS.ALBUM_ID = SONGS.ALBUM_ID
GROUP BY ARTISTS.ARTIST_NAME, ALBUMS.ALBUM_ID
HAVING COUNT(SONGS.SONG_ID) > 3;

--Part � C
--27. Retrieve albums that have been released in the same year as 'Album4'
select Album_title , Release_year from Albums
where Release_year = (
						select Release_year from Albums
						where Album_title = 'Album4');

--28. Find the longest song in each genre
SELECT S1.GENRE, S1.SONG_TITLE, S1.DURATION
FROM SONGS S1
JOIN (
    SELECT GENRE, MAX(DURATION) AS MAX_DURATION
    FROM SONGS
    GROUP BY GENRE
) S2
ON S1.GENRE = S2.GENRE AND S1.DURATION = S2.MAX_DURATION;

--29. Retrieve the titles of songs released in albums that contain the word 'Album' in the title.
select Song_title 
from  Songs s join Albums a
on s.Album_id = a.Album_id
where Album_title like '%Album%';

--30. Retrieve the total duration of songs by each artist where total duration exceeds 15 minutes.
select ar.Artist_name , sum(s.Duration) as Total_Duration
from Songs s
join Albums al on s.Album_id = al.Album_id
join Artists ar on al.Artist_id = ar.Artist_id
group by ar.Artist_name
having sum(s.Duration) > 15;
