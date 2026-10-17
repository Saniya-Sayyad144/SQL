--1.Find employees earning more than the overall average salary
SELECT *
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

--2.Find the second-highest distinct salary without using LIMIT or 
Select max(salary) as second_highest_salary
from employees 
where salary<(select max(salary)
from employees);

--3.Find the third-highest distinct salary
SELECT MAX(salary) AS third_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
    WHERE salary < (
        SELECT MAX(salary)
        FROM employees
    )
);

--4.Find employees earning the maximum salary
SELECT *
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);

--5.Find employees earning more than their department's average salary
SELECT *
FROM employees e
WHERE salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);


--6.Find the department with the highest average salary using a subquery
SELECT d.department_id, d.department_name
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) = (
    SELECT MAX(avg_salary)
    FROM (
        SELECT AVG(salary) AS avg_salary
        FROM employees
        WHERE department_id IS NOT NULL
        GROUP BY department_id
    ) AS department_averages
);


--7.Find customers whose total spending exceeds the average customer spending
Select c.customer_id,c.customer_name,
sum(oi.quantity*oi.unit_price) as total_spending
from customers as c
join orders as o
on c.customer_id=o.customer_id
join order_items as oi
on o.order_id=oi.order_id
group by c.customer_id,c.customer_name
having sum(oi.quantity*oi.unit_price)>
(
select avg(customer_spending)
from(
select o2.customer_id,
sum(oi2.quantity*oi2.unit_price) as customer_spending
from orders as o2
join order_items as oi2
on o2.order_id=oi2.order_id
group by o2.customer_id
) 
as spending
);


--8.Find employees who earn more than every employee in department 10
SELECT *
FROM employees
WHERE salary > ALL (
    SELECT salary
    FROM employees
    WHERE department_id = 10
      AND salary IS NOT NULL
);

--9.Find employees who earn more than at least one employee in department 10
SELECT *
FROM employees
WHERE salary > ANY (
    SELECT salary
    FROM employees
    WHERE department_id = 10
      AND salary IS NOT NULL
);

--10.Find customers who have placed at least one order using EXISTS
SELECT *
FROM customers c
WHERE EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);


--11.Find customers who have never placed an order using NOT EXISTS
SELECT *
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    WHERE o.customer_id = c.customer_id
);
    
----12.Find products that have never been sold using NOT EXISTS
SELECT *
FROM products p
WHERE NOT EXISTS (
    SELECT 1
    FROM order_items oi
    WHERE oi.product_id = p.product_id
);

--13.Find departments that contain at least one employee
SELECT *
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM employees e
    WHERE e.department_id = d.department_id
);

---14.Find employees whose salary is greater than the maximum salary in department 20
SELECT *
FROM employees
WHERE salary > (
    SELECT MAX(salary)
    FROM employees
    WHERE department_id = 20
);

--15.Find customers whose order count exceeds the average order count per customer
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > (
    SELECT AVG(order_count)
    FROM (
        SELECT COUNT(o2.order_id) AS order_count
        FROM customers c2
        LEFT JOIN orders o2
            ON c2.customer_id = o2.customer_id
        GROUP BY c2.customer_id
    ) AS customer_orders
);




