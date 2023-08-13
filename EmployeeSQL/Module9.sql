CREATE TABLE "departments" (
    "dept_no" varchar(10)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "employees" (
    "emp_no" int   NOT NULL,
    "emp_title_id" varchar(10)   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar(30)   NOT NULL,
    "last_name" varchar(30)   NOT NULL,
    "sex" varchar(1)   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" varchar(10)   NOT NULL,
    "title" varchar(50)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" int   NOT NULL,
    "dept_no" varchar(10)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" varchar(10)   NOT NULL,
    "emp_no" int   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


/*List the employee number, last name, first name, sex, and salary of each employee.*/

SELECT e.emp_no,
last_name,
first_name,
sex,
salary
from 
employees e 
JOIN salaries s
	ON e.emp_no = s.emp_no;

/*List the first name, last name, and hire date for the employees who were hired in 1986.*/

SELECT emp_no,
first_name,
last_name,
hire_date
from employees
where EXTRACT(YEAR FROM hire_date) = 1986;

/*List the manager of each department along with 
their department number, department name, employee number, last name, and first name.*/

SELECT
e.last_name||', '||e.first_name as manager,
d.dept_no,
d.dept_name,
e.emp_no,
e.last_name,
e.first_name
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
JOIN departments d
	ON dm.dept_no = d.dept_no;


/*List the department number for each employee along with 
that employee’s employee number, last name, first name, and department name.*/

SELECT 
de.dept_no,
e.emp_no,
e.last_name,
e.first_name,
d.dept_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no;


/*List first name, last name, and sex of each employee 
whose first name is Hercules and whose last name begins with the letter B.*/

SELECT
first_name,
last_name,
sex
from employees 
where first_name = 'Hercules' AND last_name LIKE 'B%';

/*List each employee in the Sales department, including their employee number, last name, and first name.*/

SELECT
e.emp_no,
e.last_name,
e.first_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Sales';

/*List each employee in the Sales and Development departments, 
including their employee number, last name, first name, and department name.*/

SELECT e.emp_no,
e.last_name,
e.first_name,
d.dept_name
FROM employees e
JOIN dept_emp de
	ON e.emp_no = de.emp_no
JOIN departments d
	ON de.dept_no = d.dept_no
WHERE dept_name IN ('Sales', 'Development');

/*List the frequency counts, in descending order, of all the employee last names 
(that is, how many employees share each last name).*/

SELECT last_name, 
COUNT(*) AS frequency
FROM employees 
GROUP BY last_name
ORDER BY frequency DESC, last_name ASC;