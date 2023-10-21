GO
use demo;

GO
CREATE SCHEMA pizza_runner;

--GO
--SET search_path = pizza_runner;
GO
DROP TABLE IF EXISTS runners;

GO
CREATE TABLE runners (
  "runner_id" INTEGER,
  "registration_date" DATE
);

GO
INSERT INTO runners
  ("runner_id", "registration_date")
VALUES
  (1, '2021-01-01'),
  (2, '2021-01-03'),
  (3, '2021-01-08'),
  (4, '2021-01-15');


GO 
DROP TABLE IF EXISTS customer_orders;

GO
CREATE TABLE customer_orders (
  "order_id" INTEGER,
  "customer_id" INTEGER,
  "pizza_id" INTEGER,
  "exclusions" VARCHAR(4),
  "extras" VARCHAR(4),
  "order_time" DATETIME
);

GO
INSERT INTO customer_orders
  ("order_id", "customer_id", "pizza_id", "exclusions", "extras", "order_time")
VALUES
  ('1', '101', '1', '', '', '2020-01-01 18:05:02'),
  ('2', '101', '1', '', '', '2020-01-01 19:00:52'),
  ('3', '102', '1', '', '', '2020-01-02 23:51:23'),
  ('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
  ('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
  ('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
  ('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
  ('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
  ('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
  ('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
  ('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
  ('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');

-- Removing Null Values
GO
UPDATE customer_orders
SET
    exclusions = CASE
                   WHEN exclusions = 'null' OR exclusions IS NULL THEN ''
                   ELSE exclusions
                 END,
    extras = CASE
                WHEN extras = 'null' OR extras IS NULL THEN ''
                ELSE extras
             END;

GO
select *
from customer_orders;


DROP TABLE IF EXISTS runner_orders;
CREATE TABLE runner_orders (
  "order_id" INTEGER,
  "runner_id" INTEGER,
  "pickup_time" VARCHAR(19),
  "distance" VARCHAR(7),
  "duration" VARCHAR(10),
  "cancellation" VARCHAR(23)
);

GO
INSERT INTO runner_orders
  ("order_id", "runner_id", "pickup_time", "distance", "duration", "cancellation")
VALUES
  ('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
  ('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
  ('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
  ('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
  ('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
  ('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
  ('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
  ('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
  ('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
  ('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');

  GO
  select *
  from runner_orders;

---                                     A. Pizza Metrics

  --1. Need to remove null values
GO
UPDATE runner_orders
SET
    pickup_time = CASE
                   WHEN pickup_time = 'null' OR pickup_time IS NULL THEN ''
                   ELSE pickup_time
                 END,
    distance = CASE
                WHEN distance = 'null' OR distance IS NULL THEN ''
                ELSE distance
             END,
    duration = CASE
                WHEN duration = 'null' OR distance IS NULL THEN ''
                ELSE duration
             END,
    cancellation = CASE
                WHEN cancellation = 'null' OR cancellation IS NULL THEN ''
                ELSE cancellation
             END;

-- 2. Need to remove KM sign
GO
UPDATE runner_orders
SET distance = REPLACE(distance, 'km', '')
WHERE distance LIKE '%km';

-- 3. Duration (minutes , mins)
GO
UPDATE runner_orders
SET duration = REPLACE(REPLACE(REPLACE(REPLACE(duration, 'minute', ''), 'minutes', ''), 'mins', ''),'s','')
WHERE duration LIKE '%minute%' OR duration LIKE '%minutes%' OR duration LIKE '%mins%' or duration LIKE '%s%';

-- Table
GO
select *
from runner_orders

-- Pizza Names
GO
DROP TABLE IF EXISTS pizza_names;

GO
CREATE TABLE pizza_names (
  "pizza_id" INTEGER,
  "pizza_name" TEXT
);

GO
ALTER TABLE pizza_names alter column pizza_name varchar(10);

INSERT INTO pizza_names
  ("pizza_id", "pizza_name")
VALUES
  (1, 'Meatlovers'),
  (2, 'Vegetarian');

GO
DROP TABLE IF EXISTS pizza_recipes;

GO
CREATE TABLE pizza_recipes (
  "pizza_id" INTEGER,
  "toppings" TEXT
);

GO
INSERT INTO pizza_recipes
  ("pizza_id", "toppings")
VALUES
  (1, '1, 2, 3, 4, 5, 6, 8, 10'),
  (2, '4, 6, 7, 9, 11, 12');


GO
DROP TABLE IF EXISTS pizza_toppings;
CREATE TABLE pizza_toppings (
  "topping_id" INTEGER,
  "topping_name" TEXT
);

GO
INSERT INTO pizza_toppings
  ("topping_id", "topping_name")
VALUES
  (1, 'Bacon'),
  (2, 'BBQ Sauce'),
  (3, 'Beef'),
  (4, 'Cheese'),
  (5, 'Chicken'),
  (6, 'Mushrooms'),
  (7, 'Onions'),
  (8, 'Pepperoni'),
  (9, 'Peppers'),
  (10, 'Salami'),
  (11, 'Tomatoes'),
  (12, 'Tomato Sauce');


  -- 1. How many pizzas were ordered?
  select count(order_id) as 'Pizzas Ordered '
  from customer_orders;

  --2. How many unique customer orders were made?
select count(distinct order_id) as 'Pizza Ordered '
from customer_orders;

-- 3. How many successful orders were delivered by each runner?
select runner_id,count(cancellation) as 'Successfull Orders'
from runner_orders
where cancellation not in ('Restaurant Cancellation','Customer Cancellation')
group by runner_id;

-- 4. How many of each type of pizza was delivered
select p.pizza_name,COUNT(p.pizza_name) as 'Delivery Count'
from  pizza_names p
join customer_orders c 
on p.pizza_id=c.pizza_id
join runner_orders r 
on r.order_id=c.order_id
where r.cancellation not in ('Restaurant Cancellation','Customer Cancellation')
group by p.pizza_name


--5. How many Vegetarian and Meatlovers were ordered by each customer?

select c.customer_id,
sum (case 
            when p.pizza_name='Meatlovers' then 1 else 0 end) as 'Meatlovers',
sum(case 
        when p.pizza_name='Vegetarian' then 1 else 0 end) as 'Vegetarian'
from  pizza_names p
join customer_orders c 
on p.pizza_id=c.pizza_id
join runner_orders r 
on r.order_id=c.order_id
group by c.customer_id;

--6. What was the maximum number of pizzas delivered in a single order?

with cte as 
(
    select c.order_id,count(c.pizza_id) as "Max Number of Pizza's",
    dense_rank() over(order by count(c.pizza_id) desc) as 'Rank'
    from customer_orders c 
    join runner_orders r 
    on c.order_id=r.order_id
    where r.cancellation not in ('Restaurant Cancellation','Customer Cancellation')
    group by c.order_id
)
select order_id, "Max Number of Pizza's"
from cte 
where rank=1

--7. For each customer, how many delivered pizzas had at least 1 change and how many had no changes?

    select c.customer_id,
    sum(case
            when c.exclusions <> ' ' or c.extras <> ' ' then 1 else 0 end ) as "Change",
    sum ( case 
            when c.exclusions = ' ' and c.extras= ' '  then 1 else 0 end ) as " No Change"
    from customer_orders c 
    join runner_orders r 
    on c.order_id=r.order_id
    where r.cancellation not in ('Restaurant Cancellation','Customer Cancellation')
    group by c.customer_id;

--8. How many pizzas were delivered that had both exclusions and extras?

with cte as 
(
    select
    sum(case
            when c.exclusions <> ' ' and c.extras <> ' ' then 1 else 0 end ) as "Total Pizzas"
    from customer_orders c 
    join runner_orders r 
    on c.order_id=r.order_id
    where r.cancellation not in ('Restaurant Cancellation','Customer Cancellation') --Delivered 
    --group by c.customer_id
)
select sum("Total Pizzas") as 'Both'
from cte;

--9. What was the total volume of pizzas ordered for each hour of the day?
select DATEPART(hour,order_time) as 'Hour', count(pizza_id) as 'Pizzas Ordered'
from customer_orders
GROUP by DATEPART(hour,order_time);

--10. What was the volume of orders for each day of the week?
select DATEname(weekday,order_time) as 'Day of Week', count(pizza_id) as 'Pizzas Ordered'
from customer_orders
GROUP by DATEname(weekday,order_time);



---                                   B. Runner and Customer Experience

--1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)

select DATEPART(iso_week,registration_date) as 'iso_week',count(runner_id) as 'signups'
from runners
where registration_date>'2021-01-01'
group by DATEPART(iso_week,registration_date);

--2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?

with cte AS
(
    select runner_id,datepart(minute,pickup_time) as 'Minute'
    from runner_orders
)
select runner_id, avg(Minute) as 'Avg. Minute'
from cte
group by runner_id;

--3. Is there any relationship between the number of pizzas and how long the order takes to prepare?

with cte AS
(
    select c.order_id,count(c.order_id) as pizza_count,datediff(minute,c.order_time,r.pickup_time) as 'Diff'
    from customer_orders c 
    join runner_orders r 
    on c.order_id=r.order_id
    where datediff(minute,c.order_time,r.pickup_time)>0
    group by c.order_id,r.pickup_time,c.order_time
    
)
select pizza_count,AVG(Diff)
from cte
group by pizza_count;

--4 . What was the average distance travelled for each customer?
GO
alter  table runner_orders
alter column distance float;

select c.customer_id,round(avg(r.distance),2) as 'Distance Travelled'
from customer_orders c 
join runner_orders r 
on c.order_id=r.order_id
where r.cancellation not in ('Restaurant Cancellation','Customer Cancellation')
group by c.customer_id;

--5. What was the difference between the longest and shortest delivery times for all orders?
GO
alter  table runner_orders
alter column duration int;

select max(duration)-MIN(duration) as 'Difference'
from runner_orders
where cancellation not in ('Restaurant Cancellation','Customer Cancellation') --Delivered 

--6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
with cte as
(
    select runner_id,order_id,round(((distance)/(duration))*60,2) as 'Speed'
    from runner_orders
    where cancellation not in ('Restaurant Cancellation','Customer Cancellation')
)
select runner_id,count(order_id) as 'Orders',round(avg(Speed),2) as 'Speed'
from cte
group by runner_id;

--7. What is the successful delivery percentage for each runner?

with cte as --(Delivered Orders)
(
    select runner_id,count(order_id) as DeliveredOrders
    from runner_orders
    where cancellation not in ('Restaurant Cancellation','Customer Cancellation')
    group by runner_id
),
cte2 AS  -- Total Orders
( 
    select runner_id,count(order_id) as C
    from runner_orders
    group by runner_id
)
select cte.runner_id, cast(cte.DeliveredOrders as float)/cast(cte2.C as float)*100 as 'P' ---round(cast(DeliveredOrders as float)/cast (C as float),2)*100 as 'P'
from cte
join cte2
on cte.runner_id=cte2.runner_id

