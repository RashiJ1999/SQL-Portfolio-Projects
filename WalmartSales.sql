SELECT TOP (1000) [Invoice ID]
      ,[Branch]
      ,[City]
      ,[Customer type]
      ,[Gender]
      ,[Product line]
      ,[Unit price]
      ,[Quantity]
      ,[Tax 5%]
      ,[Total]
      ,[Date]
      ,[Time]
      ,[Payment]
      ,[cogs]
      ,[gross margin percentage]
      ,[gross income]
      ,[Rating]
      ,[NewTime]
      ,[time_of_day]
  FROM [Sales Analysis].[dbo].[WalmartSales]
  
 -----------------------------------------------------------------Feature Engineering--------------------------------------------------------------------
  ----------------------------------------------------------------------------------------------------------------------------------------------------------------
  --Add column time_of_day--

  Select *
  from [Sales Analysis].[dbo].[WalmartSales]


  Select [Time] ,
  CONVERT(TIME,[Time]) as NewTime
  from [Sales Analysis].[dbo].[WalmartSales]

  UPDATE [Sales Analysis].[dbo].[WalmartSales]
  SET Time = CONVERT(TIME,[Time]) 

  Alter Table [Sales Analysis].[dbo].[WalmartSales]
  ADD NewTime TIME

  UPDATE [Sales Analysis].[dbo].[WalmartSales]
  SET NewTime = CONVERT(TIME,[Time]) 

 

 SELECT
    NewTime,
    CASE
        WHEN NewTime BETWEEN '00:00:00.000' AND '12:00:00.000' THEN 'Morning'
        WHEN NewTime BETWEEN '12:01:00.000' AND '16:00:00.000' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM
    [Sales Analysis].[dbo].[WalmartSales]

Alter Table [Sales Analysis].[dbo].[WalmartSales]
Add time_of_day VARCHAR(20)

UPDATE [Sales Analysis].[dbo].[WalmartSales]
SET time_of_day =  CASE
        WHEN NewTime BETWEEN '00:00:00.000' AND '12:00:00.000' THEN 'Morning'
        WHEN NewTime BETWEEN '12:01:00.000' AND '16:00:00.000' THEN 'Afternoon'
        ELSE 'Evening'
		END;

--Add column Day_name
-----------------------------------------------------------------------------------------------------------------------------------------
Select
    date,
    DATENAME(WEEKDAY,date) AS Day_name
from  [Sales Analysis].[dbo].[WalmartSales]

Alter Table [Sales Analysis].[dbo].[WalmartSales]
Add Day_name Varchar(10);

Update [Sales Analysis].[dbo].[WalmartSales]
Set Day_name = DATENAME(WEEKDAY,date)

--Month_name

Select
    date,
	DATENAME(MONTH,date) AS Month_name
	from [Sales Analysis].[dbo].[WalmartSales]

Alter Table [Sales Analysis].[dbo].[WalmartSales]
Add Month_name Varchar(20)

Update [Sales Analysis].[dbo].[WalmartSales]
Set Month_name = DATENAME(MONTH,date) 

Select *
From [Sales Analysis].[dbo].[WalmartSales]
-------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------EDA---------------------------------------------------------------------------------------

-----------------------------------------------------------------GENERIC-------------------------------------------------------------------------------------

--How many unique cities does the data have?
Select Distinct(city)
from [Sales Analysis].[dbo].[WalmartSales]

--In which city is branch?
Select Distinct(city),
Branch
from [Sales Analysis].[dbo].[WalmartSales]

-----------------------------------------------------------------PRODUCT-------------------------------------------------------------------------------------
--How many unique product line does the data have?
Select Distinct([Product line])
from [Sales Analysis].[dbo].[WalmartSales]

--What is the most common Payment method?
Select Payment, Count(Payment)
from [Sales Analysis].[dbo].[WalmartSales]
Group by Payment

--What is the most selling product line?
SELECT 
    [Product line],
    COUNT([Product line]) AS ProductLineCount
FROM 
    [Sales Analysis].[dbo].[WalmartSales]
GROUP BY 
    [Product line]
ORDER BY 
    ProductLineCount DESC;

--What is the total revenue by month?
Select 
    DISTINCT(Month_name)as Months 
	,Sum(Total) as Total_revenue
From [Sales Analysis].[dbo].[WalmartSales]
GROUP BY 
       Month_name
Order By 
       Total_revenue Desc;

--What month had the largest COGS?
Select
    Month_name as Months
	,Sum(COGS) as cogs
From [Sales Analysis].[dbo].[WalmartSales]
Group by Month_name
Order by cogs;


--What Product line had the largest revenue?
Select 
     [Product line]
	 ,Sum(total) as Total_revenue
from [Sales Analysis].[dbo].[WalmartSales]
Group by
      [Product line]
Order By
      Total_revenue desc;

--What is the city with the largest revenue?
Select
     Branch
     ,City
	 ,Sum(total) as Total_revenue
from [Sales Analysis].[dbo].[WalmartSales]
Group by
      City,Branch
Order By
      Total_revenue desc;

--What Product line has the largest VAT?
Select 
     [Product line]
	 ,AVG([Tax 5%]) as AVG_Tax
from [Sales Analysis].[dbo].[WalmartSales]
Group by
      [Product line]
Order By
      AVG_Tax desc

--Fetch each Product line and add a column to those product line showing 'Good','Bad'.Good if its greater than avg sales.
Select [Product line]
       , AVG(Total) as Avg_sales
	   ,CASE
	        When total > AVG(Total) THEN 'Good'
			Else 'Bad'
        End Sales_Category
From [Sales Analysis].[dbo].[WalmartSales]
Group by [Product line],Total






--Which branch sold more products than average Product sold?
Select Branch
       , Sum(quantity) as qty
from [Sales Analysis].[dbo].[WalmartSales]
Group By Branch
Having SUM(quantity) > (Select AVG(quantity) from [Sales Analysis].[dbo].[WalmartSales])


--What is the most common product line by gender
Select
      Gender 
     ,[Product line]
	 ,Count(Gender) as total_gender_cnt
From [Sales Analysis].[dbo].[WalmartSales]
Group By Gender, [Product line]
Order By total_gender_cnt desc;

--What is the AVG rating of each product line?
Select 
     [Product line]
	 ,Round(AVG(Rating),2) as avg_rating
from [Sales Analysis].[dbo].[WalmartSales]
Group by [Product line]
Order by avg_rating desc;


-------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------SALES--------------------------------------------------------------------------------------------

--Number of sales made in each time of the day per weekday?
Select *
from [Sales Analysis].[dbo].[WalmartSales]

Select time_of_day
      ,COUNT(*) as total_sales
from [Sales Analysis].[dbo].[WalmartSales]
Where Day_name = 'Monday'
Group by time_of_day
Order by total_sales desc


--Which of the customer type bring the most revenue?
Select [Customer type]
       ,SUM(Total) as revenue
From [Sales Analysis].[dbo].[WalmartSales]
Group by [Customer type]
Order by revenue desc

--Which city has the largest tax percent?
Select City
      ,AVG([Tax 5%]) AS Tax
From [Sales Analysis].[dbo].[WalmartSales]
Group by City
Order by Tax desc;

--Which Customer Type pays the most Tax?
Select [Customer type]
       ,AVG([Tax 5%]) AS Tax
From [Sales Analysis].[dbo].[WalmartSales]
Group by [Customer type]
Order by Tax desc

----------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------CUSTOMER----------------------------------------------------------------------------------------
--How many unique Customer type does the data have?
Select Distinct([Customer type])
From [Sales Analysis].[dbo].[WalmartSales]


--How many Unique Payment methods does the data have?
Select Distinct(Payment)
From [Sales Analysis].[dbo].[WalmartSales]

--What is the most common customer type?
Select [Customer type]
       ,COUNT(*) as cnt
From [Sales Analysis].[dbo].[WalmartSales]
Group by [Customer type]
Order by cnt desc;

-- Which customer type buys the most?
Select [Customer type]
       ,Count(*)
From [Sales Analysis].[dbo].[WalmartSales]
Group by [Customer type]

-- What is the gender of most of the customers?
Select Gender
       ,Count(*) as Gender_cnt
from [Sales Analysis].[dbo].[WalmartSales]
Group by Gender
Order by Gender_cnt desc

-- What is the gender distribution per branch?
Select Gender
       ,Count(*) as Gender_cnt
from [Sales Analysis].[dbo].[WalmartSales]
Where Branch = 'A'
Group by Gender
Order by Gender_cnt desc
-- Gender per branch is more or less the same hence, I don't think has
-- an effect of the sales per branch and other factors.

-- Which time of the day do customers give most ratings?
Select time_of_day
      , AVG(rating) as Avg_rating
From [Sales Analysis].[dbo].[WalmartSales]
Group by time_of_day
Order by Avg_rating desc
-- Looks like time of the day does not really affect the rating, its
-- more or less the same rating each time of the day.alter


-- Which time of the day do customers give most ratings per branch?
Select time_of_day
      , AVG(rating) as Avg_rating
From [Sales Analysis].[dbo].[WalmartSales]
Where Branch = 'A'
Group by time_of_day
Order by Avg_rating desc
-- Branch A and C are doing well in ratings, branch B needs to do a 
-- little more to get better ratings.


-- Which day fo the week has the best avg ratings?
Select Day_name
      , AVG(rating) as Avg_rating
From [Sales Analysis].[dbo].[WalmartSales]
Group by Day_name
Order by Avg_rating desc
-- Mon, Tue,Sun and Friday are the top best days for good ratings
-- why is that the case, how many sales are made on these days?



-- Which day of the week has the best average ratings per branch?
Select Day_name
      , AVG(rating) as Avg_rating
From [Sales Analysis].[dbo].[WalmartSales]
Where Branch = 'C'
Group by Day_name
Order by Avg_rating desc
--In case of Branch A and C best day is Friday and for branch B its Monday




	   
	   
