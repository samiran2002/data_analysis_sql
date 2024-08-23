/* Easy */ 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--Q1: who is the senior most emp based on job title?
-- limit 1 will show only 1 tuple
-- select * from employee order by levels desc limit 1
-----------------------------------------------------------------------------------------------
--Q2: which countries have the most invoices ?
-- group by will grp a particular country and count will help to give the number
--select COUNT(*) as c , billing_country from invoice group by billing_country order by c desc
-----------------------------------------------------------------------------------------------
--Q3: what are top 3 values of total invoice 
--select total from invoice order by total desc limit 3
-----------------------------------------------------------------------------------------------
/*Q4: Which city has the best customers ? We would like to throw a promotional music fest in 
the city we made the most money . Write a query that returns one city that has the highest sum 
   of invoice totals. Return both city name and sum of all invoice totals .*/

-- select SUM(total) as invoice_total , billing_city from invoice group by billing_city
-- order by invoice_total desc limit 1
-----------------------------------------------------------------------------------------------
--Q5: Who is the best customer? The cust who has spent the most money will be declared the best
--   cust. write a query that returns the person who has spent the most money 

/*select customer.customer_id,customer.first_name,customer.last_name,
SUM(invoice.total) as total
from customer
join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc limit 1 */
-----------------------------------------------------------------------------------------------

/* Medium */ 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
/* Q1: write a query to return the email , first name ,last name , and genre of all Rock music
	listeners . Return your list ordered alphabetically by email starting with A 

-- Join Genre <- Track <- Invoice_Line <- Invoice <- Customer

SELECT DISTINCT email , first_name , last_name 
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track 
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;

--  OR  --

SELECT DISTINCT email , first_name , last_name , genre.name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
JOIN track ON invoice_line.track_id = track.track_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
ORDER BY email;
*/
-----------------------------------------------------------------------------------------------
/* Q2: Let's invite the artists who have written the most Rock music in our dataset. Write a 
	query that returns the Artist Name and total track count of the top 10 rock bands 

SELECT artist.artist_id , artist.name , COUNT(artist.artist_id) AS no_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY no_of_songs DESC LIMIT 10
*/
-----------------------------------------------------------------------------------------------
/*Q3: Return all the track names that has a song length longer than the avg song length.Return
	the Name and milliseconds for each track. Order by the song length with the longest songs 
	listed first 

SELECT name , milliseconds 
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) AS avg_track_len FROM track
)
ORDER BY milliseconds DESC */
-----------------------------------------------------------------------------------------------

/* Advance */ 
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
/* Q1: find how much amount spent by each customer on artists? write a query to return cust
	name , artist name and total spent */

/*
WITH best_selling_artist AS (
	SELECT artist.artist_id AS artist_id , artist.name AS artist_name , 
		SUM( invoice_line.unit_price * invoice_line.quantity )
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC LIMIT 3
)
SELECT c.customer_id,c.first_name,c.last_name,bsa.artist_name,
	SUM( il.unit_price*il.quantity ) AS amt_spend
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC
*/
-----------------------------------------------------------------------------------------------
/* we want to find out the most popular music genre for each country. we determine the most 
	popular genre as the genre with the highest amt of purchases . write a query that returns 
	each country along with top genre . for countries where the max no. of purchases is shared
	return all genres. */

--method1 
/*
WITH popular_genre AS (
	SELECT COUNT(il.quantity) AS purchases , c.country,g.name,g.genre_id,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS RowNo
	FROM invoice_line il
	JOIN invoice i ON i.invoice_id = il.invoice_id
	JOIN customer c ON c.customer_id = i.customer_id
	JOIN track t ON t.track_id = il.track_id
	JOIN genre g ON g.genre_id = t.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC , 1 DESC
)
SELECT * from popular_genre WHERE RowNo<=1
*/
-----------------------------------------------------------------------------------------------
/*Q3: write a query that determines the customer that has spent the most on music for each
	country.write a query that returns the country along with the top customer and how much
	they spent. For countries where the top amount spent is shared , provide all customers 
	who spent this amt. */
	
--method 1
/* WITH RECURSIVE
	customer_with_country AS (
		SELECT c.customer_id,first_name,last_name,billing_country,SUM(total) as total_spent
		FROM invoice i
		JOIN customer c ON c.customer_id = i.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 1,5 DESC
	),
	country_max_spent AS (
		SELECT billing_country, MAX(total_spent) AS max_spent
		FROM customer_with_country
		GROUP BY billing_country
	)
SELECT cc.billing_country,cc.total_spent,cc.first_name,cc.last_name,cc.customer_id
FROM customer_with_country cc
JOIN country_max_spent ms ON ms.billing_country = cc.billing_country
WHERE cc.total_spent = ms.max_spent
ORDER BY 1
*/
--Method 2 
/* WITH customer_with_country AS (
		SELECT c.customer_id,first_name,last_name,billing_country,SUM(total) as total_spent,
		ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC )AS RowNo
		FROM invoice i
		JOIN customer c ON c.customer_id = i.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 4 ASC ,5 DESC
	)

SELECT * FROM customer_with_country WHERE RowNo<=1
*/
-----------------------------------------------------------------------------------------------




