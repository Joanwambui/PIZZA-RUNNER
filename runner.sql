DROP TABLE IF EXISTS runner_orders_clean;
CREATE TABLE runner_orders_clean (
  order_id INT,
  runner_id INT,
  pickup_time DATETIME,
  distance VARCHAR(50),
  duration VARCHAR(50),
  cancellation VARCHAR(255)
);

INSERT INTO runner_orders_clean 
SELECT order_id, runner_id,
  CASE 
    WHEN pickup_time LIKE 'null' THEN NULL
    ELSE pickup_time 
  END AS pickup_time,
  CASE 
    WHEN distance LIKE 'null' THEN ' '
    WHEN distance LIKE '%km' THEN TRIM('km' from distance) 
    ELSE distance 
  END AS distance,
  CASE 
    WHEN duration LIKE 'null' THEN ' ' 
    WHEN duration LIKE '%mins' THEN TRIM('mins' from duration) 
    WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)        
    WHEN duration LIKE '%minutes' THEN TRIM('minutes' from duration)       
    ELSE duration 
  END AS duration,
  CASE 
    WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
    ELSE cancellation 
  END AS cancellation
FROM runner_orders;

SELECT *
FROM  runner_orders_clean 
