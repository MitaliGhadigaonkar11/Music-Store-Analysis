create database Music_Store;
USE Music_Store;

-- Q1. who is the senior most employee based on job title


SELECT TOP 1 *
FROM employee
ORDER BY levels DESC;

-- Q.2 which contries have most invoices

SELECT * FROM invoice;

SELECT COUNT (*) AS C, billing_country
FROM invoice
GROUP BY billing_country
ORDER BY C DESC

--Q. what are top 3 values of total invoices

SELECT * FROM invoice;

SELECT TOP 3 *
FROM invoice
ORDER BY CAST(total AS DECIMAL(10, 2)) DESC;

/*Q. Which city has best customers ? we would like to throw a promotional music festival in the city we made the most money.
write a query that returns one city that has the highest sum of invoice totals . return both city name and sum of 
all invoice totals  */

SELECT * FROM invoice;
SELECT SUM (CAST(total AS DECIMAL(10,2))) AS invoice_total, billing_city
FROM invoice
GROUP BY billing_city
ORDER BY invoice_total DESC

/* THE customer who has spend the money will be declared as best customer. write a query that returns the person who
has spent most money . */

SELECT * FROM customer;

SELECT TOP 1 customer.customer_id, customer.first_name, customer.last_name,
SUM(CAST(invoice.total AS DECIMAL(10,2))) AS invoice_total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id,customer.first_name, customer.last_name
ORDER BY invoice_total DESC


/* write a query to return the email, first_name, last_name and genre of all ROCK music listeners. Return your list ordered alphabetically
by email starting with A i.e in ascending order   */
select * from genre

SELECT DISTINCT email,first_name,last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN (
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'ROCK'
)
ORDER BY email;

/* Q. write a query that returns artist name and total count of top 10 rock bands */

SELECT TOP 10 artist.artist_id, artist.name,
COUNT (artist.artist_id) AS number_of_songs
FROM track
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
JOIN genre ON genre.genre_id = track.genre_id
WHERE genre.name LIKE 'ROCK'
GROUP BY artist.artist_id, artist.name
ORDER BY number_of_songs DESC


/* Q. return all track names that have song length longer than avg song length. return name & miliseconds for each track.
order by the song length with the longest songs listed first */

SELECT name,milliseconds
FROM track
WHERE milliseconds > (
	SELECT AVG(CAST(milliseconds AS DECIMAL(10,2))) AS avg_track_length
	FROM track)
ORDER BY milliseconds DESC;


SELECT AVG(CAST(milliseconds AS DECIMAL(10,2))) from track;


/* Find how much amount spent by each customer on artist? write a query to return customer name, artist name  and total spent */

WITH best_selling_artist AS (
SELECT TOP 1 artist.artist_id AS artist_id, artist.name AS artist_name,
SUM (CAST(CAST(invoice_line.unit_price AS DECIMAL (10,2))* CAST(invoice_line.quantity AS DECIMAL (10,2)) AS DECIMAL (10,2))) AS total_sales
FROM invoice_line
JOIN track ON track.track_id = invoice_line.track_id
JOIN album ON album.album_id = track.album_id
JOIN artist ON artist.artist_id = album.artist_id
GROUP BY artist.artist_id, artist.name
ORDER BY 3 DESC
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name,
SUM(CAST(CAST(il.unit_price AS DECIMAL(10,2)) *CAST(il.quantity AS DECIMAL (10,2)) AS DECIMAL (10,2))) AS amount_spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY c.customer_id, c.first_name, c.last_name, bsa.artist_name
ORDER BY amount_spent DESC


