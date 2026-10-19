--1.Assign a row number to employees ordered by salary
Select first_name,salary,
row_number() 
over(order by salary)
as row_num
from employees;

--2.Rank employees according to salary using RANK()
Select first_name,salary,
rank()
over(order by salary)
as salary_rank
from employees;

--3.Rank employees according to salary using DENSE_RANK()
Select first_name,salary,
dense_rank()
over(order by salary)
as salary_rank
from employees;

--4. Find the second-highest distinct salary using DENSE_RANK()
SELECT DISTINCT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_rank
    FROM employees
    WHERE salary IS NOT NULL
) AS ranked_salaries
WHERE salary_rank = 2;

Select employee_id,first_name,last_name,salary
from (select employee_id,first_name,last_name,salary,
dense_rank ()
over(order by salary desc)
as salary_rank
from employees) as salaries_rank
where salary_rank=2;


--5. Find the top three highest-paid employees in each department
Select employee_id,first_name,last_name,department_id,salary
from (Select employee_id,first_name,last_name,department_id,salary,
dense_rank()
over(
partition by department_id
order by salary desc) as salary_rank 
from employees
) as salaries_rank
where salary_rank<=3;


SELECT *
FROM (
    SELECT e.*,
           DENSE_RANK() OVER (
               PARTITION BY department_id
               ORDER BY salary DESC
           ) AS salary_rank
    FROM employees e
) AS ranked
WHERE salary_rank <= 3;

--6. Find the highest-paid employee in every department, including ties
Select * from
(select e.* ,
rank()
over(partition by department_id
order by salary desc
) as  salary_rank
from employees  as e
) as salaries_ranked
where salary_rank=1;


--7. Find the second-highest-paid employee in each department
Select * from
(select e.* ,
dense_rank()
over(partition by department_id
order by salary desc
) as  salary_rank
from employees  as e
) as salaries_ranked
where salary_rank=2;

--8.Find the top two products by revenue in each category
SELECT *
FROM (
    SELECT p.product_id,
           p.product_name,
           p.category_id,
           SUM(oi.quantity * oi.unit_price) AS total_revenue,
           DENSE_RANK() OVER (
               PARTITION BY p.category_id
               ORDER BY SUM(oi.quantity * oi.unit_price) DESC
           ) AS revenue_rank
    FROM products p
    JOIN order_items oi
        ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, p.category_id
) AS ranked_products
WHERE revenue_rank <= 2;


--9. Calculate a running total of sales
Select product_id,product_name,price,
sum(price) over( order by product_id
rows between unbounded preceding
and current row
) as running_total
from products;

SELECT o.order_id,
       o.order_date,
       SUM(oi.quantity * oi.unit_price) AS order_total,
       SUM(SUM(oi.quantity * oi.unit_price)) OVER (
           ORDER BY o.order_date, o.order_id
       ) AS running_total
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY o.order_id, o.order_date
ORDER BY o.order_date, o.order_id;


--10.Calculate a running total of salary within each department
Select employee_id,first_name,last_name,department_id,salary,
sum(salary)
over(partition by department_id
order by salary
rows between unbounded preceding
and current row)
as running_total
from employees;

--11.Find the salary difference from the previous employee
Select first_name,last_name,salary,
lag(salary)
over(order by salary) as previous_salary,
salary-lag(salary)
over(order by salary) as difference
from employees;

--12.Compare monthly revenue with the previous month
With monthly_sales as(
select DATE_TRUNC('month',o.order_date)::date as sales_month,
sum(oi.quantity*oi.unit_price) as revenue
from orders as o
join order_items as oi
on o.order_id=oi.order_id
group by DATE_TRUNC('month', o.order_date)::date
)
 Select sales_month,revenue,
 lag(revenue)
 over(order by sales_month) as previous_revenue,
 revenue- lag(revenue)
 over(order by sales_month) as difference
 from monthly_sales
 ORDER BY sales_month;
 
 
--13.Find each customer's next order date
SELECT
    customer_id,
    order_id,
    order_date,
    LEAD(order_date) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS next_order_date
FROM orders;

--14.Display department average salary beside every employee
Select first_name,last_name,department_id,salary,
round(avg(salary)
over(partition by department_id
) ,2)as dept_avg
from employees;

--15.Find employees earning above their department average
SELECT *
FROM (
    SELECT
        employee_id,
        first_name,
        department_id,
        salary,
        AVG(salary) OVER (
            PARTITION BY department_id
        ) AS avg_salary
    FROM employees
) AS employee_data
WHERE salary > avg_salary;


--16.Calculate each employee's percentage contribution to department salary
Select first_name,last_name,department_id,
salary,
round(100*salary/
nullif (sum(salary)
over(partition by department_id),0),2
) as salary_percentage
from employees;


--17.Find the first order of every customer
SELECT *
FROM (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date, order_id
        ) AS rn
    FROM orders
) AS ranked
WHERE rn = 1;

--18.Find the latest order of every customer
SELECT *
FROM (
    SELECT
        customer_id,
        order_id,
        order_date,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY order_date DESC, order_id DESC
        ) AS rn
    FROM orders
) AS ranked
WHERE rn = 1;


--19.Find approximately the top 10% of employees by salary
SELECT *
FROM (
    SELECT
        employee_id,
        first_name,
        salary,
        CUME_DIST() OVER (
            ORDER BY salary DESC
        ) AS salary_distribution
    FROM employees
) AS ranked
WHERE salary_distribution <= 0.10;


--20.Calculate a three-month moving average of revenue
WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_date)::date AS sales_month,
        SUM(oi.quantity * oi.unit_price) AS revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    GROUP BY DATE_TRUNC('month', o.order_date)::date
)
SELECT
    sales_month,
    revenue,
    ROUND(
        AVG(revenue) OVER (
            ORDER BY sales_month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_average
FROM monthly_sales
ORDER BY sales_month;