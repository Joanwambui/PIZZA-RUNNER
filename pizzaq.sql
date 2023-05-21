#How many pizzas were ordered?
SELECT COUNT(*)
FROM customer_orders_clean

#How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id)
FROM customer_orders_clean

#How many successful orders were delivered by each runner?
WITH runner AS (
SELECT c.order_id,r.runner_id,r.distance
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r
ON c.order_id=r.order_id)

SELECT COUNT(order_id),runner_id
FROM runner
WHERE distance!= 0
GROUP BY runner_id

#How many of each type of pizza was delivered?
SELECT c.pizza_id,COUNT(r.order_id)
FROM customer_orders_clean c
INNER JOIN runner_orders_clean r
ON c.order_id=r.order_id
GROUP BY pizza_id

#How many Vegetarian and Meatlovers were ordered by each customer?
SELECT p.pizza_name,c.customer_id
FROM pizza_names p
INNER JOIN customer_orders_clean c
ON c.pizza_id=p.pizza_id
GROUP BY c.customer_id


#What was the maximum number of pizzas delivered in a single order?
WITH cte AS(
SELECT COUNT(c.pizza_id) maxorder,c.order_id
FROM customer_orders_clean c
JOIN runner_orders_clean r
ON c.order_id=r.order_id
WHERE distance != 0
GROUP BY order_id)

SELECT MAX(maxorder)
FROM cte

#For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH change AS (
SELECT c.customer_id,
 SUM(CASE 
  WHEN c.exclusions <> ' ' OR c.extras <> ' ' THEN 1
  ELSE 0
  END) AS at_least_1_change,
 SUM(CASE 
  WHEN c.exclusions = ' ' AND c.extras = ' ' THEN 1 
  ELSE 0
  END) AS no_change
FROM customer_orders_clean AS c
JOIN runner_orders_clean AS r
 ON c.order_id = r.order_id
WHERE r.distance != 0
GROUP BY c.customer_id
ORDER BY c.customer_id)

SELECT HOUR(order_time) AS hours
FROM customer_orders_clean;


#What was the total volume of pizzas ordered for each hour of the day?
ALTER TABLE customer_orders_clean
ADD COLUMN hours INT;

UPDATE customer_orders_clean
SET hours =HOUR(order_time);

SELECT COUNT(order_id),hours
FROM customer_orders_clean
GROUP BY hours

#What was the volume of orders for each day of the week?
SELECT COUNT(order_id),dow
FROM customer_orders_clean
GROUP BY dow
ORDER BY 1 DESC

SELECT DAYNAME(order_time) AS day_of_week
FROM customer_orders_clean;

ALTER TABLE customer_orders_clean
ADD COLUMN dow VARCHAR(12);

UPDATE customer_orders_clean
SET dow =DAYNAME(order_time);

SELECT DATEPART(WEEK, registration_date) AS registration_week,
 COUNT(runner_id) AS runner_signup
FROM runners
GROUP BY DATEPART(WEEK, registration_date);

#Is there any relationship between the number of pizzas and how long the order takes to prepare?
CREATE TEMPORARY TABLE pickup_temp_table
AS (
SELECT TIMESTAMPDIFF(MINUTE, c.order_time, r.pickup_time) AS pickup_minutes,c.order_time,r.pickup_time,COUNT(c.order_id) AS pizza_order
 FROM customer_orders_clean AS c
 JOIN runner_orders_clean AS r
  ON c.order_id = r.order_id
 WHERE r.distance != 0
 GROUP BY c.order_id, c.order_time, r.pickup_time)

SELECT pizza_order, AVG(pickup_minutes) AS avg_prep_time_minutes
FROM pickup_temp_table
WHERE pickup_minutes > 1
GROUP BY pizza_order;

#What was the average distance travelled for each customer?
CREATE TEMPORARY TABLE distance_tables
AS (
SELECT c.customer_id AS cust,r.order_id,r.distance AS dist
 FROM customer_orders_clean AS c
 JOIN runner_orders_clean AS r
  ON c.order_id = r.order_id
   WHERE r.distance != 0)
   
SELECT *
FROM distance_tables
   
SELECT AVG(dist),cust
FROM distance_tables
GROUP BY cust

#What was the difference between the longest and shortest delivery times for all orders?
SELECT order_id, duration
FROM runner_orders_clean
WHERE duration not like ' ';

SELECT 
    MAX(CAST(duration AS DECIMAL)) - MIN(CAST(duration AS DECIMAL)) AS delivery_time_difference
FROM runner_orders_clean
WHERE duration NOT LIKE '% %';

#What was the average speed for each runner for each delivery and do you notice any trend for these values?
SELECT r.runner_id, c.customer_id, c.order_id, 
 COUNT(c.order_id) AS pizza_count, 
 r.distance, (r.duration / 60) AS duration_hr , 
 ROUND((r.distance/r.duration * 60), 2) AS avg_speed
FROM runner_orders_clean AS r
JOIN customer_orders_clean AS c
 ON r.order_id = c.order_id
WHERE distance != 0
GROUP BY r.runner_id, c.customer_id, c.order_id, r.distance, r.duration
ORDER BY c.order_id;

