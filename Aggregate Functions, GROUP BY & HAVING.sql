--1.Find the total number of employees.
Select count(*) as total_employees
from employees;

--2.Find the average salary of all employees.
Select round(avg(salary),2) as avg_salary
from employees;

--3.Find the maximum salary.
Select max(salary) as max_salary
from employees;

--4.Find the minimum salary
Select max(salary) as max_salary
from employees;

--5.Calculate the total salary expenditure.
Select round(sum(salary),2) as expenditure
from employees;


--6.Count employees in each department
Select department_id,count(*)as emp_count
from employees
group by department_id;

Select d.department_name,round(count(*),2) as emp_count
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name;



--7.Find the average salary in each department.
Select department_id,round(avg(salary),2) as avg_salary
from employees
group by department_id;

Select d.department_name,round(avg(salary),2) as avg_salary
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name;

--8.Find the lowest salary in each department.
Select department_id,round(min(salary),2) as min_salary
from employees
group by department_id;

Select d.department_id,d.department_name,round(min(salary),2) as min_salary
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name
order by d.department_id asc;

--9.Find the highest salary in each department
Select department_id,round(max(salary),2) as max_salary
from employees
group by department_id;

Select d.department_id,d.department_name,round(max(salary),2) as max_salary
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name
order by d.department_id asc;

--10.Find departments having more than five employees.
Select department_id,count(*) as emp_count
from employees
group by department_id
having count(*)>5;

Select d.department_id,d.department_name,count(*)as emp_count
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d.department_name
having count(*)>5;

-- 11.Find departments whose average salary exceeds ₹50,000.
Select department_id,round(avg(salary),2) as avg_salary
from employees
group by department_id
having avg(salary)>50000;

Select d.department_id,d.department_name,round(avg(salary),2) as avg_salary
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d.department_name
having avg(salary)>50000;

--12.Find departments whose total salary expenditure exceeds ₹2,00,000.
Select department_id,round(sum(salary),2) as expenditure
from employees
group by department_id
having sum(salary)>200000;

Select d.department_id,d.department_name,round(sum(salary),2) as expenditure
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d.department_name
having sum(salary)>200000;

--13.Find the department with the highest number of employees
Select department_id,count(*)as emp_count
from employees
group by department_id
order by emp_count desc
limit 1;

Select d.department_name,count(*) as emp_count
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name
order by emp_count desc
limit 1;

--14.Find the department with the highest average salary
SELECT
    department_id,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY avg_salary DESC
LIMIT 1;

SELECT
    d.department_name,
    ROUND(AVG(e.salary), 2) AS avg_salary
FROM employees AS e
JOIN departments AS d
    ON e.department_id = d.department_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_salary DESC
LIMIT 1;

--15.Count employees earning more than ₹50,000 in each department
select department_id,count(*) as emp_count
from employees 
where salary>50000
group by department_id;

Select d.department_id,d.department_name, count(*) as emp_count
from employees as e
join departments as d
on e.department_id=d.department_id
where salary>50000
group by d.department_id,d,department_name;

--16.Find departments with fewer than three employees
select department_id,count(*) as emp_count
from employees 
group by department_id
having count(*)<3;

Select d.department_id,d.department_name, count(*) as emp_count
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d,department_name
having count(*)<3;


---17.Find duplicate email addresses and their counts
SELECT email, COUNT(*) AS total
FROM employees
WHERE email IS NOT NULL
GROUP BY email
HAVING COUNT(*) > 1;

--18.Find the number of employees hired in each year
SELECT EXTRACT(YEAR FROM joining_date) AS joining_year,
       COUNT(*) AS total_employees
FROM employees
GROUP BY EXTRACT(YEAR FROM joining_date)
ORDER BY joining_year;

--19.Calculate the average salary for each job role
SELECT job_title, AVG(salary) AS average_salary
FROM employees
GROUP BY job_title
ORDER BY average_salary DESC;

--20.Find departments where the minimum salary exceeds ₹20,000
Select department_id,min(salary) as min_salary
from employees
group by department_id
having  min(salary)>20000;

Select d.department_id,d.department_name,min(salary) as minimum_salary
from employees as e
join departments as d
on e.department_id=d.department_id
group by d.department_id,d.department_name
having min(salary)>20000;