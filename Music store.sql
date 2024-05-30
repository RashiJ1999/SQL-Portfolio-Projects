/*Who is the senior most employee based on job title*/

Select top 1 * from music_database.dbo.employee
order by levels desc;

/*Which countries have the most invoice?*/

Select COUNT(*) as count_of_bills, [billing_country] 
from [music_database].[dbo].[invoice]
group by [billing_country]
order by count_of_bills desc

/*What are the top 3 values of total invoice*/

Select top 3 * 
from  [music_database].[dbo].[invoice]
order by total desc

/*Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money.
  Write a query that returns one city that has the highest sum of invoice totals.Return both the city name & sum of all invoice totals.*/

  Select top 1 c.customer_id,c.first_name,c.last_name,sum(i.total) as total
  from [music_database].[dbo].[customer] c
  join [music_database].[dbo].[invoice] i on c.customer_id = i.customer_id 
  Group by c.customer_id,c.first_name,c.last_name
  order by total desc;

/*Write a query to return the email,first name,last name and genre of all Rock Music listeners. Return your list alphabetically by email 
  starting with A*/
  
SELECT
	Distinct(c.email),
    c.first_name,
    c.last_name
FROM 
    [music_database].[dbo].[customer] c
JOIN 
    [music_database].[dbo].[invoice] i 
    ON c.customer_id = i.customer_id
JOIN 
    [music_database].[dbo].[invoice_line] il 
    ON i.invoice_id = il.invoice_id
WHERE 
    il.track_id IN (
        SELECT t.track_id 
        FROM [music_database].[dbo].[track] t
        JOIN [music_database].[dbo].[genre] g 
        ON t.genre_id = g.genre_id
        WHERE g.name LIKE 'Rock'
    )
ORDER BY 
    c.email; 

/*Lets invite the artist who has written the most Rock music in our dataset. Write a query that returns the artist name and total Track count 
  of the top 10 rock bands*/
 Select top 10
	a.artist_id,
    a.name,
	count(t.track_id) as no_of_songs
 from 
	[music_database].[dbo].[track] t
 join
	[music_database].[dbo].[album] al on t.album_id = al.album_id
 join
	[music_database].[dbo].[artist] a on al.artist_id = a.artist_id
 join
	[music_database].[dbo].[genre] g on t.genre_id = g.genre_id
 where
	g.name like 'Rock'
 Group by 
	a.artist_id,a.name
 order by 
	no_of_songs desc

/*Return all the track names that have a song length longer than the average song length.Return the name and milliseconds for each track.
 Order by the song length with the longest song listed first.*/
 Select * from [music_database].[dbo].[track]

Select name,milliseconds from [music_database].[dbo].[track]
where milliseconds >
      (Select Avg(milliseconds) as avg_miliseconds
	   from [music_database].[dbo].[track])
order by milliseconds desc

/*Find how much amount spent by each customer on each artist?Write a query to return customer name, artist name and total spent*/
WITH bestsellingartist AS (
    SELECT TOP 1 
        a.artist_id,
        a.name, 
        SUM(il.unit_price * il.quantity) AS total_sales
    FROM  
        [music_database].[dbo].[invoice_line] il
    JOIN 
        [music_database].[dbo].[track] t ON il.track_id = t.track_id
    JOIN 
        [music_database].[dbo].[album] al ON t.album_id = al.album_id
    JOIN 
        [music_database].[dbo].[artist] a ON al.artist_id = a.artist_id
    GROUP BY 
        a.artist_id, a.name
    ORDER BY 
        total_sales DESC
)
SELECT 
    c.first_name,
    c.last_name,
    bsa.artist_id,
    SUM(il.unit_price * il.quantity) AS amount_spent
FROM 
    [music_database].[dbo].[invoice] i
JOIN 
    [music_database].[dbo].[customer] c ON i.customer_id = c.customer_id
JOIN 
    [music_database].[dbo].[invoice_line] il ON i.invoice_id = il.invoice_id
JOIN 
    [music_database].[dbo].[track] t ON il.track_id = t.track_id
JOIN 
    [music_database].[dbo].[album] al ON t.album_id = al.album_id
JOIN 
    bestsellingartist bsa ON al.artist_id = bsa.artist_id
GROUP BY 
    c.first_name,
    c.last_name,
    bsa.artist_id
ORDER BY 
    amount_spent DESC;

/*We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres*/
With popular_genre as(
	Select 
		count(il.quantity) as purchase ,
		c.country,
		g.genre_id,
		g.name,
		ROW_NUMBER() Over (Partition by c.country order by count( il.quantity) desc)as row_no
	from  [music_database].[dbo].[invoice_line] il
	join  
		[music_database].[dbo].[invoice] i on il.invoice_id = i.invoice_id
	join  
		[music_database].[dbo].[customer] c on i.customer_id  = c.customer_id
	join  
		[music_database].[dbo].[track] t on il.track_id = t.track_id
	join  
		[music_database].[dbo].[genre] g on t.genre_id = g.genre_id
	group by  
		c.country,
		g.genre_id,
		g.name
	
)
Select * 
from popular_genre 
where row_no <=1;

/*Method 2*/
WITH sales_per_country AS (
    SELECT 
        COUNT(*) AS purchase_per_genre,
        c.country,
        g.genre_id,
        g.name
    FROM  
        [music_database].[dbo].[invoice_line] il
    JOIN  
        [music_database].[dbo].[invoice] i ON il.invoice_id = i.invoice_id
    JOIN  
        [music_database].[dbo].[customer] c ON i.customer_id = c.customer_id
    JOIN  
        [music_database].[dbo].[track] t ON il.track_id = t.track_id
    JOIN  
        [music_database].[dbo].[genre] g ON t.genre_id = g.genre_id
    GROUP BY  
        c.country,
        g.genre_id,
        g.name
),
max_genre_per_country AS (
    SELECT 
        country,
        MAX(purchase_per_genre) AS max_genre_number
    FROM 
        sales_per_country
    GROUP BY 
        country
)
SELECT 
    spc.*
FROM 
    sales_per_country spc
JOIN 
    max_genre_per_country mgpc 
    ON spc.country = mgpc.country 
    AND spc.purchase_per_genre = mgpc.max_genre_number;


/*Write a query that determines the customer that has spent the most on music for each
country. Write a query that returns the country along with the top customer and how
much they spent. For countries where the top amount spent is shared, provide all
customers who spent this amount*/
 
 WITH customer_with_country AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country,
        SUM(i.total) AS total_spending
    FROM 
        [music_database].[dbo].[invoice] i
    JOIN 
        [music_database].[dbo].[customer] c ON i.customer_id = c.customer_id
    GROUP BY 
        c.customer_id,
        c.first_name,
        c.last_name,
        i.billing_country
),
customer_max_spending AS (
    SELECT 
        billing_country,
        MAX(total_spending) AS max_spending
    FROM 
        customer_with_country
    GROUP BY 
        billing_country
)
SELECT 
    cc.billing_country,
    cc.total_spending,
    cc.first_name,
    cc.last_name
FROM 
    customer_with_country cc
JOIN 
    customer_max_spending ms ON cc.billing_country = ms.billing_country
    AND cc.total_spending = ms.max_spending
ORDER BY 
    cc.billing_country;
