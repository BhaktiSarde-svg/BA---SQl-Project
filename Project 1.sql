
/*TASK 1*/
/*1*/
SELECT * FROM employees
SELECT employee_id,first_name,last_name,hire_date from employees
SELECT salary,2*(salary) as NEW_SALARY from employees

/*2*/
SELECT employee_id,first_name,last_name,hire_date from employees order by first_name
SELECT employee_id,first_name,last_name,hire_date from employees order by first_name asc , last_name desc
SELECT employee_id,first_name,last_name,salary from employees order by salary desc
SELECT employee_id,first_name,last_name,hire_date from employees order by hire_date desc 

/*3*/
SELECT employee_id,salary from employees order by 2 desc
SELECT DISTINCT salary,first_name,last_name  from employees
SELECT DISTINCT job_id, salary from employees
select DISTINCT phone_number from employees

/*4*/
SELECT * FROM employees ORDER BY first_name 
SELECT TOP 5 * FROM employees 
SELECT  * FROM employees ORDER BY 1 OFFSET 4 ROWS FETCH NEXT 5 ROWS ONLY
SELECT TOP 5 * FROM employees ORDER BY salary DESC
SELECT  * FROM employees WHERE salary = (SELECT DISTINCT salary FROM employees ORDER BY salary DESC OFFSET 1 ROWS FETCH NEXT 1 ROWS ONLY);

/*5*/
SELECT * FROM employees WHERE salary > 14000 ORDER BY salary DESC
SELECT * FROM employees WHERE department_id = 5
SELECT * FROM employees WHERE last_name = 'CHEN'
SELECT * FROM employees WHERE hire_date > '1999-01-01'
SELECT * FROM employees WHERE YEAR(hire_date)= 1999;
SELECT * FROM employees WHERE last_name = 'Himuro'
SELECT * FROM employees WHERE phone_number IS NULL
SELECT * FROM employees WHERE department_id <> 8
SELECT * FROM employees WHERE department_id <> 8 AND department_id <> 10
SELECT * FROM employees WHERE salary > 10000
SELECT * FROM employees WHERE salary > 10000 AND department_id = 8
SELECT * FROM employees WHERE salary >= 9000
SELECT * FROM employees WHERE salary <= 9000

/*6*/
ALTER TABLE courses ADD credit_hours INT
ALTER TABLE courses ADD fees DECIMAL(10,2) , max_limit INT /*AFTER course_name AFTER is not supoorted in mysql*/ 
ALTER TABLE courses ALTER COLUMN fees DECIMAL(10,2) NOT NULL
ALTER TABLE courses DROP COLUMN fees
ALTER TABLE courses DROP COLUMN max_limit,credit_hours


/*7*/
CREATE  TABLE  project_milestones( 
milestone_id  INT  PRIMARY KEY, 
project_id   INT, 
milestone_name VARCHAR(100),
FOREIGN KEY (project_id) 
REFERENCES projects(project_id)
);

ALTER TABLE project_milestones ADD FOREIGN KEY (project_id) REFERENCES projects(project_id)



/*TASK 2*/

/*1.1*/
SELECT * FROM employees WHERE salary > 5000 AND salary < 7000
SELECT * FROM employees WHERE salary IN (7000,8000)
SELECT * FROM employees WHERE salary= 7000 OR salary = 8000 -- for question 2 i have used the above and below approach
SELECT * FROM employees WHERE phone_number IS NULL
SELECT * FROM employees WHERE salary BETWEEN 9000 AND 12000
SELECT * FROM employees WHERE department_id = 8 OR department_id = 9
SELECT * FROM employees WHERE first_name LIKE 'jo%'
SELECT * FROM employees WHERE first_name LIKE '_h%'
SELECT * FROM employees WHERE salary > ALL (SELECT salary FROM employees WHERE department_id = 8)
 /*1.2*/
 SELECT * FROM employees WHERE salary > ALL(SELECT AVG(salary) FROM employees)
 SELECT * FROM employees as emp, dependents as dep WHERE emp.employee_id = dep.employee_id  
 SELECT * FROM employees WHERE salary BETWEEN 2500 AND 2900
 SELECT * FROM employees WHERE salary NOT BETWEEN 2500 AND 2900
 SELECT * FROM employees WHERE hire_date BETWEEN '1999-01-01' AND '2000-12-31'
 SELECT * FROM employees WHERE hire_date NOT BETWEEN '1999-01-01' AND '2000-12-31'
 SELECT * FROM employees WHERE YEAR(hire_date) BETWEEN 1990 AND 1993
 /*1.3*/
 SELECT * FROM employees WHERE first_name LIKE 'Da%'
 SELECT * FROM employees WHERE first_name LIKE '%er'
 SELECT * FROM employees WHERE last_name LIKE '%an'
 SELECT * FROM employees WHERE first_name LIKE 'Jo__'
 SELECT * FROM employees WHERE first_name LIKE 'S%' AND first_name NOT LIKE 'Sh%'

 /*1.4*/
 SELECT * FROM employees WHERE department_id = 5
 SELECT * FROM employees WHERE department_id = 5 AND salary <= 5000
 SELECT * FROM employees WHERE department_id NOT IN (1,2,3)
 SELECT * FROM employees WHERE first_name NOT LIKE 'D%' 
 SELECT * FROM employees WHERE salary NOT BETWEEN 1000 AND 5000

 /*1.5*/
  SELECT * FROM employees e WHERE NOT EXISTS (SELECT 1 FROM Dependents d WHERE d.employee_id = e.employee_id);
  SELECT * FROM  employees WHERE phone_number IS NULL
  SELECT * FROM  employees WHERE phone_number IS NOT NULL

  /*TASK 3 */
  /*Inner Join*/
  SELECT * FROM departments WHERE department_id IN (1,2,3)
  SELECT * FROM employees AS emp INNER JOIN departments AS dept ON emp.department_id = dept.department_id WHERE emp.department_id IN (1,2,3) 
  SELECT emp.first_name,emp.last_name,job_title,department_name FROM employees AS emp 
    INNER JOIN departments AS dept ON emp.department_id = dept.department_id
    INNER JOIN jobs AS j ON emp.job_id = j.job_id
    WHERE emp.department_id IN (1,2,3)
    
   /*Left Join*/
   SELECT * FROM countries WHERE country_id in ('CN','UK','US') 
   SELECT * FROM locations AS lc LEFT JOIN countries AS ct on lc.country_id = ct.country_id WHERE lc.country_id in ('US','UK','CN')
   SELECT * FROM countries WHERE country_id NOT IN (SELECT country_id FROM locations)
   SELECT * FROM countries AS ct LEFT JOIN locations AS lc on ct.country_id = lc.country_id LEFT JOIN regions AS reg ON ct.region_id = reg.region_id

   /*Self Join*/
   SELECT * FROM employees AS e1 LEFT JOIN employees AS e2 on  e2.manager_id = e1.employee_id
  
  /*Full outer join */
  SELECT * FROM fruits AS fr FULL OUTER JOIN baskets As bas on fr.basket_id = bas.basket_id
  SELECT * FROM fruits AS fr FULL OUTER JOIN baskets As bas on fr.basket_id = bas.basket_id WHERE bas.basket_id IS NULL
  SELECT * FROM fruits AS fr FULL OUTER JOIN baskets As bas on fr.basket_id = bas.basket_id WHERE fr.fruit_id IS NULL

  /*Cross Join*/
  SELECT * FROM sales_organization CROSS JOIN sales_channel


  /*TASK 4*/
 SELECT  COUNT(*) AS total_emp,department_id FROM employees GROUP BY department_id
 SELECT  COUNT(*) AS total_emp,department_id FROM employees GROUP BY department_id
 SELECT  COUNT(*) AS total_emp,department_id FROM employees GROUP BY department_id
 SELECT  department_id,COUNT(*) AS headcount FROM employees GROUP BY department_id order by headcount 
 SELECT  department_id,COUNT(*) AS headcount FROM employees GROUP BY department_id HAVING COUNT(*) >5  order by headcount
 SELECT MIN(salary) as min_salary,MAX(salary) as max_salary,AVG(salary)  as avg_salary,department_id FROM employees GROUP BY department_id
  SELECT SUM(salary) AS total_salary,department_id FROM employees GROUP BY department_id
  SELECT COUNT(*) AS employee_count FROM employees GROUP BY department_id, job_id
  SELECT m.employee_id,COUNT(*) AS DirectReports FROM Employees e JOIN Employees m ON e.manager_id = m.employee_id GROUP BY m.employee_id;
  SELECT m.employee_id,COUNT(*) AS DirectReports FROM Employees e JOIN Employees m ON e.manager_id = m.employee_id GROUP BY m.employee_id HAVING COUNT(*) >=5;
  SELECT SUM(salary) AS total_salary,department_id FROM employees GROUP BY department_id HAVING SUM(salary) BETWEEN 20000 AND 30000
  SELECT department_id FROM employees GROUP BY department_id HAVING MIN(salary) > 10000;
    SELECT department_id FROM employees GROUP BY department_id HAVING AVG(salary) BETWEEN 5000 AND 7000;

/*TASK 5*/
SELECT first_name,last_name FROM employees UNION SELECT first_name,last_name FROM dependents
SELECT * FROM employees INTERSECT SELECT * FROM dependents ORDER BY employee_id DESC
SELECT * FROM employees as e WHERE EXISTS (SELECT 1 FROM dependents as dep WHERE dep.employee_id = e.employee_id)
SELECT * FROM employees as e WHERE NOT EXISTS (SELECT 1 FROM dependents as dep WHERE dep.employee_id = e.employee_id)
/*Case Expression*/
SELECT employee_id,hire_date ,
  CASE (2000 - YEAR(hire_date))
    WHEN 5 THEN '5th Years Anniversary'
    WHEN 10 THEN '10th Years Anniversary'
    WHEN 15 THEN '15th Years Anniversary'
    ELSE 'Other'
   END  Anniversary
FROM employees

SELECT employee_id,salary,
CASE 
    WHEN salary < 3000 THEN 'Low'
    WHEN salary  BETWEEN 3000 AND 5000 THEN 'Average'
    WHEN salary > 5000 THEN 'High'
END as Sal_cond
FROM employees d

/*Update Query*/
SELECT * FROM employees WHERE employee_id = 192
UPDATE employees
SET last_name = 'Lopez'
WHERE employee_id = 192

/*Final Task*/
SELECT * FROM employees AS e WHERE e.department_id IN (SELECT  department_id FROM departments WHERE location_id = 1700);
SELECT * FROM employees AS e WHERE e.department_id NOT IN (SELECT  department_id FROM departments WHERE location_id = 1700);
SELECT * FROM employees AS e WHERE e.salary = (SELECT MAX(salary) FROM employees);
SELECT * FROM employees AS e WHERE e.salary > (SELECT AVG(salary) FROM employees);
SELECT  * FROM departments as dep WHERE dep.department_id IN (SELECT department_id FROM employees WHERE salary> 10000);
SELECT  * FROM departments as dep WHERE dep.department_id  NOT IN (SELECT department_id FROM employees WHERE salary> 10000);
SELECT  * FROM employees e WHERE salary = ( SELECT MIN(salary)  FROM employees WHERE department_id = e.department_id);
SELECT  * FROM employees e WHERE salary > ( SELECT MIN(salary)  FROM employees WHERE department_id = e.department_id);
SELECT department_id, AVG(salary) AS average_salary FROM employees GROUP BY department_id;
SELECT AVG(avg_salary) FROM (SELECT AVG(salary) AS avg_salary FROM employees GROUP BY department_id) dept_avg;
SELECT employee_id,first_name,last_name, salary, (SELECT AVG(salary) FROM employees) AS average_salary, salary - (SELECT AVG(salary) FROM employees) AS difference FROM employees;




 

