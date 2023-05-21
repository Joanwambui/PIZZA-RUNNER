# PIZZA-RUNNER
SQL  Exploratory Analysis on a pizza restaurant 
## Introduction
Danny was scrolling through his Instagram feed when something really caught his eye — “80s Retro Styling 🎸 and Pizza 🍕 Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going to help him get seed funding to expand his new Pizza Empire — so he had one more genius idea to combine with it — he was going to Uberize it — and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and also maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.

## Table Relationship
customer_orders — Customers’ pizza orders with 1 row each for individual pizza with topping exclusions and extras, and order time.
runner_orders — Orders assigned to runners documenting the pickup time, distance and duration from Pizza Runner HQ to customer, and cancellation remark.
runners — Runner IDs and registration date
pizza_names — Pizza IDs and name
pizza_recipes — Pizza IDs and topping names
pizza_toppings — Topping IDs and name

## Data Cleaning and Transformation
Before I start with the solutions, I investigate the data and found that there are some cleaning and transformation to do, specifically on the

null values and data types in the customer_orders table
null values and data types in the runner_orders table
Alter data type in pizza_names table
Firstly, to clean up exclusions and extras in the customer_orders — we create TEMP TABLE #customer_orders and use CASE WHEN.

Then, we clean the runner_orders table with CASE WHEN and TRIM and create TEMP TABLE #runner_orders.

## In summary,

pickup_time — Remove nulls and replace with ‘ ‘
distance — Remove ‘km’ and nulls
duration — Remove ‘minutes’ and nulls
cancellation — Remove NULL and null and replace with ‘ ‘

# CASE STUDY QUESTIONS
## A. Pizza Metrics
How many pizzas were ordered?
How many unique customer orders were made?
How many successful orders were delivered by each runner?
How many of each type of pizza was delivered?
How many Vegetarian and Meatlovers were ordered by each customer?
What was the maximum number of pizzas delivered in a single order?
For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
How many pizzas were delivered that had both exclusions and extras?
What was the total volume of pizzas ordered for each hour of the day?
What was the volume of orders for each day of the week?
## B. Runner and Customer Experience
How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
Is there any relationship between the number of pizzas and how long the order takes to prepare?
What was the average distance travelled for each customer?
What was the difference between the longest and shortest delivery times for all orders?
What was the average speed for each runner for each delivery and do you notice any trend for these values?
What is the successful delivery percentage for each runner?
