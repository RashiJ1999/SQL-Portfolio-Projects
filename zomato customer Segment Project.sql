CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 
Insert into goldusers_signup(userid,gold_signup_date)
values(1,'09-22-2017'),
(3,'04-21-2017');

CREATE TABLE users(userid integer , signup_date date);

Insert into users(userid,signup_date)
values(1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

CREATE TABLE sales(userid integer , created_date date , product_id integer)

Insert into sales(userid,created_date,product_id)
values(1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);

CREATE Table product(product_id integer, product_name text, price integer)

Insert into product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

/*What is the total amount each customer spent on zomato?*/
Select a.userid,sum(b.price) from sales a
inner join product b on a.product_id = b.product_id 
group by a.userid

/*How many days has each customer visited zomato*/
Select userid,count(distinct created_date)as distinct_days from sales
group by userid;

/*What was the first product purchased by each customer*/
Select * from
(Select *,rank() over(partition by userid order by created_date)rnk from sales)a where rnk = 1

/*What is the most purchased item on the menu and how many times was it purchased by the customer*/
Select userid,count(product_id)cnt from sales where product_id = 
(Select top 1 product_id from sales
group by product_id
order by count(product_id)desc)
group by userid

/*Which item was the most popular for each customer*/
Select * from
(Select *,rank() over(partition by userid order by cnt desc)rnk from
(Select userid,product_id,count(product_id)cnt from sales 
group by userid,product_id)a)b
where rnk = 1

/*Which item was purchased first by the customer after the became a member*/
Select * from
(Select c.*,rank() over(partition by userid order by created_date)rnk from
(Select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b on a.userid = b.userid and created_date>=gold_signup_date)c)d where rnk = 1

/*Which item was purchased just before the customer became a member*/
Select * from
(Select c.*,rank() over(partition by userid order by created_date desc)rnk from
(Select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b on a.userid = b.userid and created_date<gold_signup_date)c)d where rnk = 1

/*What is the total order and amount spent on for each member before they became a member*/
Select userid,count(created_date)order_purchased,sum(price) total_amt_spent from
(Select c.*,d.price from
(Select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b on a.userid = b.userid and created_date<gold_signup_date)c
inner join product d on c.product_id=d.product_id)e
group by userid;

/*If buying each product generates points for eg 5rs = 2 zomato points and for each product 
has different product points for eg for p1 5rs = 1 zomato point , for p2 10rs = 5 zomato point, 
for p3 5rs = 1 zomato point calculate points collected ny each customer and for which product most
pints have been given till now*/
Select userid,sum(total_points)*2.5 total_money_earned from
(Select e.*,total_price/points as total_points from
(SELECT d.*, 
       CASE 
           WHEN product_id = 1 THEN 5 
           WHEN product_id = 2 THEN 2 
           WHEN product_id = 3 THEN 5 
           ELSE 0 
       END AS points 
FROM
(
    SELECT c.userid, c.product_id, SUM(price) AS total_price
    FROM
    (
        SELECT a.*, b.price
        FROM sales a 
        INNER JOIN product b ON a.product_id = b.product_id
    ) c
    GROUP BY userid, product_id
) d)e)f group by userid;


Select * from
(Select *, rank() over(order by total_money_earned desc)rnk from
(Select product_id,sum(total_points)*2.5 total_money_earned from
(Select e.*,total_price/points as total_points from
(SELECT d.*, 
       CASE 
           WHEN product_id = 1 THEN 5 
           WHEN product_id = 2 THEN 2 
           WHEN product_id = 3 THEN 5 
           ELSE 0 
       END AS points 
FROM
(
    SELECT c.userid, c.product_id, SUM(price) AS total_price
    FROM
    (
        SELECT a.*, b.price
        FROM sales a 
        INNER JOIN product b ON a.product_id = b.product_id
    ) c
    GROUP BY userid, product_id
) d)e)f group by product_id)f)g where rnk = 1;

/*In the first one year after a customer joins a gold program(including their joining date) irespective
of what the customer has purchased they earn 5 zomato point for every 10rs spent who earned more 1 or 3
and what was their point earning in first year
1 zomato point = 2 rs
0.5 zomato point = 1rs*/

Select c.*,d.price*0.5 total_points_earned from
(Select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
inner join goldusers_signup b on a.userid = b.userid and created_date>=gold_signup_date and created_date<=DATEADD(year, 1,gold_signup_date))c
inner join product d on c.product_id = d.product_id

/*rnk all the transactions of the customers*/
Select *,rank() over(partition by userid order by created_date)rnk from sales

/*rank all the transactions for each member whenever they are zomato gold member for every non gold member
transaction mark as na*/
Select c.*,case when gold_signup_date is null then 'na' else cast(rank() over(partition by userid order by created_date desc)as varchar) end as rnk from
(Select a.userid,a.created_date,a.product_id,b.gold_signup_date from sales a
left join goldusers_signup b on a.userid = b.userid and created_date>=gold_signup_date)c;

SELECT c.*,
       CASE 
           WHEN gold_signup_date IS NULL THEN 'na' 
           ELSE CAST(RANK() OVER (PARTITION BY userid ORDER BY created_date DESC) AS VARCHAR)
       END AS rnk 
FROM
(
    SELECT a.userid, a.created_date, a.product_id, b.gold_signup_date 
    FROM sales a
    LEFT JOIN goldusers_signup b ON a.userid = b.userid AND a.created_date >= b.gold_signup_date
) c;

