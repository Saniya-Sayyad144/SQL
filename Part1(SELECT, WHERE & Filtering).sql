Select * from departments;
Select * from employees;
Select * from  customers;
Select * from categories;
Select * from products;
Select * from orders;
Select * from order_items;

---1.Find employees whose salary is greater than ₹40,000.
select * from employees
where salary>40000;

---2.Find employees whose salary is between ₹25,000 and ₹60,000.
Select * from employees 
where salary Between 25000 and 40000;

---3.Find employees who work in the IT department
Select * from employees
where department_id=(
select department_id from departments
where department_name='IT'
);

--4.Find employees who work in IT or HR
select e.*from employees as e
join departments as d
on e.department_id=d.department_id
where d.department_name='IT' or d.department_name='HR';

--5.Find employees whose names start with 'A'.
select * from employees
where first_name like 'a%';

--6.Find employees whose names end with 'n'.
Select * from employees
where first_name like '%n';

--7.Find employees whose names contain 'an'.
Select * from employees
where first_name like '%an%';

--8.Find employees whose salary is not between ₹30,000 and ₹50,000.
Select * from employees
where salary not between 30000 and 50000;

--9.Find employees whose department ID is NULL.
Select * from employees
where department_id is null;

---10.Find employees whose salary is greater than ₹50,000 and who joined after 1 January 2025.
SELECT *
FROM employees
WHERE salary > 50000
  AND joining_date > '2025-01-01';

--Display employees hired in 2025.
Select * from employees
where joining_date >='2025-01-01'
and joining_date<'2026-01-01'

--11.Display employees in descending order of salary
select * from employees
order by salary desc;

--12.Display the five highest-paid employees.
select * from employees
order by salary desc
limit 5;

--13.Display the second page of employees, with 10 records per page.
SELECT *
FROM employees
ORDER BY employee_id
LIMIT 10 OFFSET 10;

---Find employees whose names are duplicated
select first_name,last_name ,count(*) as Total
from employees 
group by first_name,last_name
having count(*)>1;

--14.Display unique department IDs.
select distinct department_id
from employees;

--15.Find employees whose salary is not NULL
select * from employees
where salary is not null;

--16.Display employees ordered by department and salary
select * from employees
order by department_id asc, salary asc;