-- --------------------------- QUERY 1

SELECT count(DISTINCT(emp_no))
FROM employees.t_dept_manager;

-- -----------------------------------------QUERY 2
select COUNT(*) AS total_emp
FROM (
SELECT emp_no
FROM employees.t_dept_emp
GROUP BY emp_no
HAVING COUNT(dept_no) = 1) AS res;

-- ------------------------------------checking for duplicate records
-- SELECT *
-- FROM employees.t_dept_manager
-- GROUP BY dept_no, FROM_date
-- HAVING COUNT(*) > 1;

-- ----------------------------------------- 3 query
-- assuming there is only single maximum count value

SELECT dept_name
FROM employees.t_departments 
RIGHT JOIN 
(SELECT dept_no, count(emp_no) AS manager_no
FROM employees.t_dept_manager
GROUP BY dept_no
ORDER BY manager_no DESC LIMIT 1) AS res
USING(dept_no);

-- ---------------------------------------------- Query 4

WITH emp_age AS (
    SELECT
        e.emp_no,
        CASE
            WHEN (YEAR(curdate()) - YEAR(e.birth_date)) BETWEEN 50 AND 55 THEN '50-55'
            WHEN (YEAR(curdate()) - YEAR(e.birth_date)) BETWEEN 56 AND 60 THEN '56-60'
            WHEN (YEAR(curdate()) - YEAR(e.birth_date)) BETWEEN 61 AND 65 THEN '61-65'
            WHEN (YEAR(curdate()) - YEAR(e.birth_date)) BETWEEN 66 AND 70 THEN '66-70'
            WHEN (YEAR(curdate()) - YEAR(e.birth_date)) BETWEEN 71 AND 75 THEN '71-75'
            
        END AS age_group
    FROM
        employees.t_employees e
)

SELECT emp_age.age_group, AVG(sal.salary) AS average_sal
FROM employees.t_salaries AS sal
JOIN(
	SELECT emp_no, MAX(from_date) AS latest_date
	FROM employees.t_salaries
	GROUP BY emp_no) AS emp
ON sal.emp_no = emp.emp_no AND sal.from_date = emp.latest_date
JOIN emp_age 
ON sal.emp_no = emp_age.emp_no
GROUP BY emp_age.age_group
order by average_sal DESC
LIMIT 1


-- -------------------------- Query 5

(SELECT *
FROM  employees.t_dept_manager) 
UNION
(SELECT *
FROM  employees.t_dept_manager);

