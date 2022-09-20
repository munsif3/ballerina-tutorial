CREATE SCHEMA IF NOT EXISTS Company;

CREATE TABLE Company.Employees (
	employee_id SERIAL PRIMARY KEY,
	first_name  VARCHAR(255) NOT NULL,
	last_name   VARCHAR(255) NOT NULL,
	email       VARCHAR(255) NOT NULL,
	phone       VARCHAR(50) NOT NULL ,
	hire_date   DATE NOT NULL,
	manager_id  INTEGER REFERENCES Company.Employees(employee_id),
	job_title   VARCHAR(255) NOT NULL
);

SELECT * FROM company.employees
ORDER BY employee_id ASC;