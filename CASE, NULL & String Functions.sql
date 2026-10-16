-----CASE, NULL & String Functions------
---1. Categorize employees as High, Medium, or Low salary using CASE
Select First_name,salary,
CASE
    When salary>=70000 then 'High'
    When salary>=40000 then 'Medium'
  else 'low'
end as salary_category
 from employees

 ---2.Replace NULL commission values with zero
 SELECT first_name,
       COALESCE(commission, 0) AS commission
FROM employees;

--3. Display employee names in uppercase
SELECT UPPER(first_name) AS employee_name
FROM employees;

--4. Display employee names in lowercase
SELECT LOWER(first_name) AS employee_name
FROM employees;

--5. Find the length of each employee's name
SELECT first_name,
       LENGTH(first_name) AS name_length
FROM employees;

--6. Remove leading and trailing spaces from employee names
SELECT TRIM(first_name) AS employee_name
FROM employees;

--7. Combine first name and last name into a full name
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees;

--8. Find employees whose names contain exactly five characters
SELECT first_name
FROM employees
WHERE LENGTH(first_name) = 5;

--9. Extract the first three characters of each employee's name
SELECT first_name,
       SUBSTRING(first_name FROM 1 FOR 3) AS first_three_chars
FROM employees;


---10.Replace spaces in employee names with underscores
Select replace(concat(first_name,' ',last_name),' ','-') 
as employee_name 
from employees;

--11. Find employees whose email addresses end with gmail.com
SELECT *
FROM employees
WHERE email ILIKE '%gmail.com';

--Count employees with and without commission
SELECT
    COUNT(commission) AS with_commission,
    COUNT(*) - COUNT(commission) AS without_commission
FROM employees;

--Find duplicate names ignoring uppercase and lowercase
SELECT LOWER(first_name) AS employee_name,
       COUNT(*) AS total
FROM employees
GROUP BY LOWER(first_name)
HAVING COUNT(*) > 1;

---Display a fallback value when an employee's department name is NULL
SELECT e.first_name,
       COALESCE(d.department_name, 'No Department') AS department_name
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id;
