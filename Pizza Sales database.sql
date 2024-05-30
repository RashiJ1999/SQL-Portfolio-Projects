Select * from pizza_sales

/*Total Revenue*/
Select Sum(total_price) as Total_Revenue from pizza_sales 

/*Average Order Value*/
Select sum(total_price) / count(distinct(order_id)) as Average_order_price 
from pizza_sales

/*Total pizza sold*/
Select sum(quantity) as total_pizza_sold
from pizza_sales

/*Total orders*/
Select Count(order_id) as total_orders 
from pizza_sales

/*Average pizza per order*/
Select round(sum(quantity)/count(distinct(order_id)),2)as average_oizza_per_order
from pizza_sales

/*Daily trend*/
Select DATENAME(DW, order_date) as oders_day, count(distinct order_id) as total_orders
from pizza_sales
Group by DATENAME(DW,order_date)


/*Hourly Trend*/
SELECT 
    DATEPART(HOUR, order_time) AS order_hours,
    COUNT(DISTINCT [order_id]) AS total_orders
FROM 
    pizza_sales
GROUP BY 
    DATEPART(HOUR, order_time)
ORDER BY
	DATEPART(HOUR, order_time);

/*Percentage of sales by pizza category*/
Select pizza_category, sum(total_price) as total_sales, sum(total_price)*100/(Select sum(total_price) from pizza_sales where MONTH(order_date) = 1 )as PCT 
from pizza_sales
where MONTH(order_date) = 1
Group by pizza_category

/*Percentage of sales by pizza size*/
SELECT 
    pizza_size, 
    ROUND(SUM(total_price), 2) AS total_sales, 
    ROUND(SUM(total_price) * 100.0 / (SELECT SUM(total_price) FROM pizza_sales WHERE DATEPART(QUARTER, order_date) = 1), 2) AS PCT
FROM 
    pizza_sales
WHERE 
    DATEPART(QUARTER, order_date) = 1
GROUP BY 
    pizza_size
ORDER BY 
    PCT DESC;

/*Total pizza sold by quantity*/
Select pizza_category, sum(quantity)as total_pizza_sold
from pizza_sales
Group By pizza_category

/*Top 5 best sellers by total pizza sold*/
Select TOP 5 pizza_name,sum(quantity)as total_pizza_sold
from pizza_sales
group by pizza_name
order by total_pizza_sold desc
 
/*Bottom 5 worst seller */
Select top 5 pizza_name,sum(quantity)as total_pizza_sold
from pizza_sales
group by pizza_name
order by total_pizza_sold Asc
 

