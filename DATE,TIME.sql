--1.Find employees who joined in the current year
Select * from employees
where 
Extract(year from joining_date)=extract(year from current_date);

--2.Find employees who joined in the last 30 days
SELECT *
FROM employees
WHERE joining_date >= CURRENT_DATE - INTERVAL '30 days'
  AND joining_date < CURRENT_DATE + INTERVAL '1 day';

--3.Calculate employee tenure in years
Select employee_id,first_name,last_name,joining_date,
Age(current_date,joining_date) tenure
from employees;

--4.Count employees hired in each month
Select 
Extract(month from joining_date) as month_number,
to_char(joining_date,'month') as month_name,
count(*) as employee_count
from employees
group by
Extract(month from joining_date),
to_char(joining_date,'month')
order by month_number;


--5.Calculate monthly sales revenue
Select 
Extract(month from o.order_date) as month_number,
To_CHAR(o.order_date,'month') as month_name,
sum(oi.quantity*oi.Unit_price) as revenue
from orders as o
join order_items as oi
on o.order_id=oi.order_id
group by Extract(month from o.order_date) ,
To_CHAR(o.order_date,'month')
order by month_number;

SELECT
    DATE_TRUNC('month', o.order_date)::date AS sales_month,
    SUM(oi.quantity * oi.unit_price) AS revenue
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY DATE_TRUNC('month', o.order_date)::date
ORDER BY sales_month;


--6.Find orders placed today
Select * from orders
where order_date>=Current_date
AND order_date<current_date+Interval'1 day';

--7.Find customers who have not placed an order in the last six months
SELECT c.*
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= CURRENT_DATE - INTERVAL '6 months'
      AND o.order_date < CURRENT_DATE + INTERVAL '1 day'
);

--8.Calculate the number of days between two order dates
SELECT
    customer_id,
    order_id,
    order_date,
    LAG(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
    ) AS previous_order_date,
    order_date::date -
    LAG(order_date::date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date, order_id
    ) AS days_between
FROM orders;

--9.Find the month with the highest revenue
Select 
Date_Trunc('month',o.order_date):: date as sales_month,
sum(oi.quantity*oi.unit_price) as revenue
from orders as o
join order_items as oi
on o.order_id=oi.order_id
group by Date_Trunc('month',o.order_date):: date
order by revenue desc
limit 1;


--10.Calculate month-over-month revenue growth
with monthly_sales as
(select date_trunc('month',o.order_date)::date as sales_month,
sum(oi.quantity*oi.unit_price) as revenue
from orders as o
join order_items as oi
on o.order_id=oi.order_id
group by date_trunc('month',o.order_date)::date
),

comparision as(
select sales_month,
revenue,
lag(revenue)
over ( order by sales_month)
as previous_revenue
from monthly_sales
)

select sales_month,revenue,previous_revenue,
round(100.0*(revenue-previous_revenue)/
nullif(previous_revenue,0),2) as growth_percentage
from comparision;


--11.Find customers who placed orders in both January and February
SELECT customer_id
FROM orders
WHERE order_date >= DATE_TRUNC('year', CURRENT_DATE)
  AND order_date < DATE_TRUNC('year', CURRENT_DATE)
                   + INTERVAL '2 months'
GROUP BY customer_id
HAVING COUNT(*) FILTER (
    WHERE EXTRACT(MONTH FROM order_date) = 1
) > 0
AND COUNT(*) FILTER (
    WHERE EXTRACT(MONTH FROM order_date) = 2
) > 0;

--Find employees who joined in the same year.
SELECT
    employee_id,
    first_name,
    joining_date,
    EXTRACT(YEAR FROM joining_date) AS joining_year
FROM employees
WHERE EXTRACT(YEAR FROM joining_date) IN (
    SELECT EXTRACT(YEAR FROM joining_date)
    FROM employees
    GROUP BY EXTRACT(YEAR FROM joining_date)
    HAVING COUNT(*) > 1
)
ORDER BY joining_year, joining_date;

--13.Find the first and last order dates for each customer
SELECT
    customer_id,
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM orders
GROUP BY customer_id;

--14.Find customers who placed orders on consecutive days
WITH customer_orders AS (
    SELECT DISTINCT
        customer_id,
        order_date::date AS order_day
    FROM orders
),
ordered_days AS (
    SELECT
        customer_id,
        order_day,
        LAG(order_day) OVER (
            PARTITION BY customer_id
            ORDER BY order_day
        ) AS previous_order_day
    FROM customer_orders
)
SELECT
    customer_id,
    previous_order_day,
    order_day
FROM ordered_days
WHERE order_day = previous_order_day + 1;

--15.Find months with zero sales
WITH months AS (
    SELECT GENERATE_SERIES(
        DATE_TRUNC('year', CURRENT_DATE),
        DATE_TRUNC('year', CURRENT_DATE) + INTERVAL '11 months',
        INTERVAL '1 month'
    ) AS month_start
),
monthly_sales AS (
    SELECT
        DATE_TRUNC('month', order_date) AS month_start,
        COUNT(*) AS order_count
    FROM orders
    GROUP BY DATE_TRUNC('month', order_date)
)
SELECT
    m.month_start::date AS sales_month
FROM months m
LEFT JOIN monthly_sales s
    ON m.month_start = s.month_start
WHERE COALESCE(s.order_count, 0) = 0
ORDER BY sales_month;