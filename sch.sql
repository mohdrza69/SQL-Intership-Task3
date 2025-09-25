-- ============================================================
-- Example schema: employees, departments, customers, orders
-- ============================================================

-- Drop (safe) if exists (useful when re-running)
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;

-- Departments table
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL
);

-- Employees table
CREATE TABLE employees (
    emp_id INTEGER PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    email TEXT,
    salary INTEGER,
    dept_id INTEGER,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Customers table
CREATE TABLE customers (
    cust_id INTEGER PRIMARY KEY,
    name TEXT,
    city TEXT,
    signup_date DATE
);

-- Orders table
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    cust_id INTEGER,
    order_date DATE,
    total_amount NUMERIC,
    status TEXT,
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
);

-- Sample data
INSERT INTO departments VALUES (1, 'Engineering'), (2, 'Sales'), (3, 'HR');

INSERT INTO employees VALUES
 (101,'Amit','Khan','amit.k@example.com',60000,1,'2022-03-15'),
 (102,'Sana','Ali','sana.a@example.com',45000,2,'2023-07-01'),
 (103,'Ramesh','Shah','ramesh.s@example.com',30000,3,'2021-11-20'),
 (104,'Priya','Verma','priya.v@example.com',52000,1,'2024-01-10'),
 (105,'John','Doe','john.d@example.com',75000,1,'2020-06-05');

INSERT INTO customers VALUES
 (201,'Naveen','Delhi','2023-02-10'),
 (202,'Lisa','Mumbai','2022-10-01'),
 (203,'Omar','Bengaluru','2023-12-12');

INSERT INTO orders VALUES
 (1001,201,'2024-01-05',1500.00,'shipped'),
 (1002,202,'2024-01-20',250.50,'pending'),
 (1003,201,'2024-02-01',75.00,'delivered'),
 (1004,203,'2024-03-12',980.25,'shipped');

-- ============================================================
-- Queries demonstrating required concepts
-- ============================================================

-- 1) SELECT * : returns all columns and rows
SELECT * FROM employees;

-- 2) Select specific columns (projection)
SELECT first_name, last_name, email FROM employees;

-- 3) WHERE: filter rows (simple)
SELECT * FROM employees WHERE salary > 50000;

-- 4) WHERE with AND / OR
SELECT first_name, last_name, salary FROM employees
 WHERE (dept_id = 1 AND salary > 50000) OR (dept_id = 2 AND salary > 40000);

-- 5) LIKE pattern matching
-- find employees whose first name contains 'a' (case-sensitive in SQLite by default)
SELECT first_name, last_name FROM employees WHERE first_name LIKE '%a%';

-- 6) BETWEEN used for ranges
SELECT * FROM employees WHERE hire_date BETWEEN '2022-01-01' AND '2024-12-31';

-- 7) IN vs =
-- = compares a single value; IN checks membership in a set
SELECT * FROM employees WHERE dept_id IN (1,3);  -- dept 1 or 3

-- 8) ORDER BY (ascending is default)
SELECT emp_id, first_name, salary FROM employees ORDER BY salary ASC;

-- 9) ORDER BY descending
SELECT emp_id, first_name, salary FROM employees ORDER BY salary DESC;

-- 10) LIMIT (top N rows)
-- SQLite / MySQL
SELECT * FROM employees ORDER BY hire_date DESC LIMIT 3;

-- 11) DISTINCT (unique values)
SELECT DISTINCT dept_id FROM employees;

-- 12) Aliasing columns / tables
SELECT first_name || ' ' || last_name AS full_name, salary AS monthly_salary FROM employees;

-- 13) JOIN example: extract data from more than one table
SELECT e.emp_id, e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
ORDER BY d.dept_name;

-- 14) WHERE with OR and LIKE (complex filter)
SELECT c.name, o.order_id, o.total_amount
FROM customers c JOIN orders o USING (cust_id)
WHERE o.status = 'pending' OR c.city LIKE '%mumbai%';

-- 15) Using BETWEEN for numeric values
SELECT * FROM orders WHERE total_amount BETWEEN 100 AND 1000 ORDER BY total_amount;

-- 16) Combining LIMIT with ORDER BY to get the highest paid employee
SELECT first_name, last_name, salary FROM employees ORDER BY salary DESC LIMIT 1;
