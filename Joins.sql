--1.Display employee names with their department names
Select e.first_name,e.last_name,d.department_name
from employees as e
join departments as d
on e.department_id=d.department_id;

--2.Display all employees, including those without departments
Select e.first_name,e.last_name,d.department_name
from employees as e
left join departments as d
on e.department_id=d.department_id;

--3.Find employees who do not belong to any existing department
Select e.first_name,e.last_name,d.department_name
from employees as e
left join departments as d
on e.department_id=d.department_id
where e.department_id is null;

--4.Display all departments, including those without employees
Select d.department_name,e.first_name,e.last_name
from employees  as e
right join departments as d
on d.department_id=e.department_id;

SELECT d.department_name, e.first_name
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id;

--5.Find departments that have no employees
Select d.department_name,e.first_name,e.last_name
from employees  as e
right join departments as d
on d.department_id=e.department_id
where e.first_name  is null;

--6.Display customer names with their order IDS 
Select c.customer_name,o.order_id
from customers as c
join orders as o
on c.customer_id=o.customer_id
order by o.order_id asc;

--7.Find customers who have never placed an order
Select c.customer_name,o.order_id
from customers as c
left join orders as o
on c.customer_id=o.customer_id
where o.order_id is null;

--8.Find customers who have placed at least one order
Select c.customer_name,count(order_id) as  total_orders
from customers as c
left join orders as o
on c.customer_id=o.customer_id
group by c.customer_name
having count(order_id)>=1
order by count(order_id) asc
;

--9.Find customers who have placed more than three orders

SELECT c.customer_id, c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3;

--10.Display each customer's total order amount
Select c.customer_id,c.customer_name ,
COALESCE(Sum(oi.unit_price*oi.quantity),0) as Total_order_Amount
from customers as c
left join orders as o
on c.customer_id=o.customer_id
left join order_items as oi
on o.order_id=oi.order_id
group by c.customer_id,c.customer_name
order by c.customer_id;

--11.Display product names with their order quantities
Select p.product_name,coalesce (oi.quantity,0) as quantities
from products as p
left join order_items as oi
on p.product_id=oi.product_id;

--12.Calculate total revenue for each product
Select p.product_name,coalesce (sum(oi.quantity*oi.unit_price),0) as revenue
from products as p
left join order_items as oi
on p.product_id=oi.product_id
group by p.product_name;

--13.Find products that have never been ordered
Select p.product_name,oi.quantity
from products as p
left join order_items as oi
on p.product_id=oi.product_id
where oi.quantity is null;

SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

--14.Display employee names alongside their managers' names
SELECT e.first_name AS employee_name,
       m.first_name AS manager_name
FROM employees e
LEFT JOIN employees m
    ON e.manager_id = m.employee_id;

--15.Find employees who earn more than their managers
SELECT e.first_name AS employee_name,
       e.salary AS employee_salary,
       m.first_name AS manager_name,
       m.salary AS manager_salary
FROM employees e
JOIN employees m
    ON e.manager_id = m.employee_id
WHERE e.salary > m.salary;

--16.Find employees who earn more than their department's average salary
SELECT e.first_name, e.salary, e.department_id
FROM employees e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees e2
    WHERE e2.department_id = e.department_id
);

--17.Find employees who belong to the same department as a given employee
SELECT *
FROM employees
WHERE department_id = (
    SELECT department_id
    FROM employees
    WHERE employee_id = 6
)
AND employee_id <> 6;

--18.Display departments with employee counts, including zero-employee departments
SELECT d.department_name,
       COUNT(e.employee_id) AS total_employees
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_id;

--19.Find customers who ordered products from a particular category
SELECT DISTINCT c.customer_id, c.customer_name
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
JOIN products p
    ON oi.product_id = p.product_id
JOIN categories cat
    ON p.category_id = cat.category_id
WHERE cat.category_name = 'Electronics';

--20.Find customers who purchased more than one different product
SELECT c.customer_id, c.customer_name,
       COUNT(DISTINCT oi.product_id) AS different_products
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
JOIN order_items oi
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(DISTINCT oi.product_id) > 1;