
DROP TABLE IF EXISTS user_logins CASCADE;
DROP TABLE IF EXISTS bookings CASCADE;
DROP TABLE IF EXISTS bank_transactions CASCADE;
DROP TABLE IF EXISTS bank_accounts CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE,
    location        VARCHAR(50)
);

CREATE TABLE employees (
    employee_id   INT PRIMARY KEY,
    first_name    VARCHAR(40) NOT NULL,
    last_name     VARCHAR(40),
    email         VARCHAR(120), -- intentionally not UNIQUE: duplicate-email practice
    department_id INT REFERENCES departments(department_id),
    manager_id    INT REFERENCES employees(employee_id),
    job_title     VARCHAR(60),
    salary        NUMERIC(10,2),
    commission    NUMERIC(10,2),
    joining_date  DATE,
    status        VARCHAR(20) DEFAULT 'Active',
    gender        VARCHAR(20),
    CHECK (salary IS NULL OR salary >= 0)
);

CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email         VARCHAR(120), -- intentionally allows duplicates and NULLs
    phone         VARCHAR(20),
    city          VARCHAR(50),
    signup_date   DATE,
    status        VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE categories (
    category_id   INT PRIMARY KEY,
    category_name VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(120) NOT NULL,
    category_id  INT REFERENCES categories(category_id),
    price        NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock        INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
    active       BOOLEAN DEFAULT TRUE
);

CREATE TABLE orders (
    order_id     INT PRIMARY KEY,
    customer_id  INT REFERENCES customers(customer_id),
    order_date   DATE NOT NULL,
    status       VARCHAR(20) NOT NULL,
    payment_mode VARCHAR(30),
    shipping_city VARCHAR(50)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT NOT NULL REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id    INT NOT NULL REFERENCES products(product_id),
    quantity      INT NOT NULL CHECK (quantity > 0),
    unit_price    NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    UNIQUE(order_id, product_id)
);

-- Additional tables for transaction, booking and login-streak questions.
CREATE TABLE bank_accounts (
    account_id   INT PRIMARY KEY,
    account_name VARCHAR(100) NOT NULL,
    balance      NUMERIC(12,2) NOT NULL CHECK (balance >= 0)
);

CREATE TABLE bank_transactions (
    transaction_id   INT PRIMARY KEY,
    account_id        INT NOT NULL REFERENCES bank_accounts(account_id),
    transaction_date  TIMESTAMP NOT NULL,
    transaction_type  VARCHAR(20) NOT NULL,
    amount            NUMERIC(12,2) NOT NULL CHECK (amount > 0),
    reference_code    VARCHAR(40)
);

CREATE TABLE bookings (
    booking_id   INT PRIMARY KEY,
    customer_id  INT REFERENCES customers(customer_id),
    resource_name VARCHAR(80) NOT NULL,
    start_date   DATE NOT NULL,
    end_date     DATE NOT NULL,
    status       VARCHAR(20) NOT NULL,
    CHECK (end_date >= start_date)
);

CREATE TABLE user_logins (
    login_id   INT PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    login_date DATE NOT NULL
);

-- -------------------------
-- DEPARTMENTS
-- Dept 70 and 80 intentionally have no employees.
-- -------------------------
INSERT INTO departments VALUES
(10, 'IT', 'Pune'),
(20, 'HR', 'Mumbai'),
(30, 'Sales', 'Pune'),
(40, 'Finance', 'Nashik'),
(50, 'Marketing', 'Mumbai'),
(60, 'Operations', 'Kolhapur'),
(70, 'Legal', 'Pune'),
(80, 'Research', 'Nashik'),
(90, 'Support', 'Nagpur'),
(100, 'Analytics', 'Pune');

-- -------------------------
-- EMPLOYEES
-- IDs 1-5 are managers; manager_id references them.
-- Includes salary ties, NULLs, duplicate emails and varying dates.
-- -------------------------
INSERT INTO employees
(employee_id, first_name, last_name, email, department_id, manager_id, job_title, salary, commission, joining_date, status, gender)
VALUES
(1, 'Aarav', 'Shah', 'aarav.shah@example.com', 10, NULL, 'IT Manager', 120000, NULL, '2018-01-15', 'Active', 'Male'),
(2, 'Priya', 'Patil', 'priya.patil@example.com', 20, NULL, 'HR Manager', 90000, NULL, '2019-03-11', 'Active', 'Female'),
(3, 'Rohan', 'Deshmukh', 'rohan.d@example.com', 30, NULL, 'Sales Manager', 100000, 15000, '2017-07-01', 'Active', 'Male'),
(4, 'Neha', 'Kulkarni', 'neha.k@example.com', 40, NULL, 'Finance Manager', 110000, NULL, '2018-09-20', 'Active', 'Female'),
(5, 'Sameer', 'Khan', 'sameer.k@example.com', 50, NULL, 'Marketing Manager', 95000, 10000, '2020-02-17', 'Active', 'Male'),
(6, 'Ananya', 'Joshi', 'ananya.j@example.com', 10, 1, 'Software Engineer', 85000, NULL, '2021-06-14', 'Active', 'Female'),
(7, 'Vikram', 'More', 'vikram.m@example.com', 10, 1, 'Software Engineer', 85000, 5000, '2022-04-18', 'Active', 'Male'),
(8, 'Aditi', 'Pawar', 'aditi.p@example.com', 10, 1, 'Data Analyst', 72000, NULL, '2023-01-09', 'Active', 'Female'),
(9, 'Karan', 'Jadhav', 'karan.j@example.com', 10, 1, 'Database Developer', 68000, NULL, '2024-05-22', 'Active', 'Male'),
(10, 'Meera', 'Shinde', 'meera.s@example.com', 10, 1, 'Junior Developer', 48000, NULL, '2025-01-06', 'Active', 'Female'),
(11, 'Arjun', 'Bhosale', 'arjun.b@example.com', 10, 1, 'QA Engineer', 60000, NULL, '2025-06-16', 'Active', 'Male'),
(12, 'Sana', 'Shaikh', 'sana.s@example.com', 20, 2, 'HR Executive', 52000, NULL, '2021-08-02', 'Active', 'Female'),
(13, 'Ishita', 'Rane', 'ishita.r@example.com', 20, 2, 'Recruiter', 50000, NULL, '2022-11-10', 'Active', 'Female'),
(14, 'Nikhil', ' Pawar', 'nikhil.p@example.com', 20, 2, 'HR Executive', 45000, NULL, '2024-02-12', 'Active', 'Male'),
(15, 'Tanvi', 'Gore', 'tanvi.g@example.com', 20, 2, 'Recruiter', 50000, NULL, '2025-03-03', 'Active', 'Female'),
(16, 'Omkar', 'Salunkhe', 'omkar.s@example.com', 30, 3, 'Sales Executive', 55000, 12000, '2020-10-05', 'Active', 'Male'),
(17, 'Pooja', 'Mane', 'pooja.m@example.com', 30, 3, 'Sales Executive', 52000, 9000, '2021-12-01', 'Active', 'Female'),
(18, 'Yash', 'Chavan', 'yash.c@example.com', 30, 3, 'Sales Executive', 48000, 7000, '2023-07-17', 'Active', 'Male'),
(19, 'Riya', 'Kadam', 'riya.k@example.com', 30, 3, 'Sales Associate', 42000, NULL, '2025-02-20', 'Active', 'Female'),
(20, 'Dev', 'Suryawanshi', 'dev.s@example.com', 40, 4, 'Accountant', 65000, NULL, '2020-04-13', 'Active', 'Male'),
(21, 'Kavya', 'Desai', 'kavya.d@example.com', 40, 4, 'Financial Analyst', 75000, NULL, '2021-09-27', 'Active', 'Female'),
(22, 'Rahul', 'Mali', 'rahul.m@example.com', 40, 4, 'Accountant', 55000, NULL, '2023-05-15', 'Active', 'Male'),
(23, 'Sneha', 'Pawar', 'sneha.p@example.com', 50, 5, 'Marketing Executive', 58000, 5000, '2021-02-08', 'Active', 'Female'),
(24, 'Aditya', 'Kale', 'aditya.k@example.com', 50, 5, 'SEO Specialist', 62000, NULL, '2022-06-06', 'Active', 'Male'),
(25, 'Mitali', 'Jain', 'mitali.j@example.com', 50, 5, 'Content Writer', 46000, NULL, '2024-08-19', 'Active', 'Female'),
(26, 'Aman', 'Shaikh', 'aman.s@example.com', 60, NULL, 'Operations Executive', 43000, NULL, '2023-03-21', 'Active', 'Male'),
(27, 'Zoya', 'Ansari', 'zoya.a@example.com', 60, 26, 'Operations Analyst', 51000, NULL, '2024-10-14', 'Active', 'Female'),
(28, 'Irfan', 'Pathan', 'irfan.p@example.com', 90, NULL, 'Support Lead', 70000, NULL, '2020-07-07', 'Active', 'Male'),
(29, 'Alisha', 'Khan', 'alisha.k@example.com', 90, 28, 'Support Executive', 38000, NULL, '2022-12-12', 'Active', 'Female'),
(30, 'Manav', 'Patil', 'manav.p@example.com', 90, 28, 'Support Executive', 38000, NULL, '2024-01-15', 'Active', 'Male'),
(31, 'Aarohi', 'Shah', 'aarav.shah@example.com', 100, NULL, 'Data Analyst', 85000, NULL, '2025-07-01', 'Active', 'Female'),
(32, 'Kabir', 'Naik', NULL, 100, 31, 'BI Developer', 78000, NULL, '2025-08-11', 'Active', 'Male'),
(33, 'Diya', 'More', 'diya.m@example.com', 100, 31, 'Junior Analyst', 48000, NULL, '2026-01-12', 'Active', 'Female'),
(34, 'Neil', 'Joshi', 'neil.j@example.com', 10, 1, 'Intern', 25000, NULL, '2026-06-01', 'Active', 'Male'),
(35, 'Anil', 'Kadam', 'anil.k@example.com', 30, 3, 'Sales Associate', 42000, 3000, '2026-02-02', 'Inactive', 'Male'),
(36, 'Sara', 'Shaikh', 'sara.s@example.com', NULL, NULL, 'Consultant', 90000, NULL, '2022-05-09', 'Active', 'Female'),
(37, 'Ritesh', 'Babar', 'ritesh.b@example.com', 60, 26, 'Operations Executive', 43000, NULL, '2025-11-03', 'Active', 'Male'),
(38, 'Naina', 'Rao', 'naina.r@example.com', 10, 1, 'QA Engineer', 60000, NULL, '2023-10-10', 'Inactive', 'Female'),
(39, 'Aman', 'Shaikh', 'aman.s@example.com', 50, 5, 'Marketing Intern', 25000, NULL, '2026-07-06', 'Active', 'Male'),
(40, 'Om', 'Kulkarni', 'om.k@example.com', 100, 31, 'Data Engineer', 92000, NULL, '2024-09-09', 'Active', 'Male');

-- -------------------------
-- CUSTOMERS
-- Customer 24 has no orders; some emails are duplicated/NULL.
-- -------------------------
INSERT INTO customers VALUES
(1, 'Aarav Mehta', 'aarav.m@example.com', '9000000001', 'Pune', '2024-01-10', 'Active'),
(2, 'Priya Nair', 'priya.n@example.com', '9000000002', 'Mumbai', '2024-02-14', 'Active'),
(3, 'Rohan Verma', 'rohan.v@example.com', '9000000003', 'Nashik', '2024-03-05', 'Active'),
(4, 'Neha Shah', 'neha.shah@example.com', '9000000004', 'Pune', '2024-04-22', 'Active'),
(5, 'Sameer Khan', 'sameer.k@example.com', '9000000005', 'Nagpur', '2024-05-11', 'Active'),
(6, 'Aditi Joshi', 'aditi.j@example.com', '9000000006', 'Kolhapur', '2024-06-30', 'Active'),
(7, 'Karan Patil', 'karan.p@example.com', '9000000007', 'Mumbai', '2024-07-12', 'Active'),
(8, 'Meera Desai', 'meera.d@example.com', '9000000008', 'Pune', '2024-08-19', 'Active'),
(9, 'Arjun Pawar', 'arjun.p@example.com', '9000000009', 'Nashik', '2024-09-03', 'Active'),
(10, 'Sana Shaikh', 'sana.shaikh@example.com', '9000000010', 'Pune', '2024-10-17', 'Active'),
(11, 'Ishita More', 'ishita.m@example.com', '9000000011', 'Mumbai', '2024-11-21', 'Active'),
(12, 'Nikhil Jadhav', 'nikhil.j@example.com', '9000000012', 'Nagpur', '2024-12-08', 'Active'),
(13, 'Tanvi Kulkarni', 'tanvi.k@example.com', '9000000013', 'Kolhapur', '2025-01-15', 'Active'),
(14, 'Omkar Bhosale', 'omkar.b@example.com', '9000000014', 'Pune', '2025-02-20', 'Active'),
(15, 'Pooja Mane', 'pooja.m@example.com', '9000000015', 'Mumbai', '2025-03-13', 'Active'),
(16, 'Yash Chavan', 'yash.c@example.com', '9000000016', 'Nashik', '2025-04-02', 'Active'),
(17, 'Riya Kadam', 'riya.k@example.com', '9000000017', 'Pune', '2025-05-29', 'Active'),
(18, 'Dev Suryawanshi', 'dev.s@example.com', '9000000018', 'Nagpur', '2025-06-18', 'Active'),
(19, 'Kavya Desai', 'kavya.d@example.com', '9000000019', 'Kolhapur', '2025-07-07', 'Active'),
(20, 'Rahul Mali', 'rahul.m@example.com', '9000000020', 'Mumbai', '2025-08-25', 'Active'),
(21, 'Sneha Pawar', 'sneha.p@example.com', '9000000021', 'Pune', '2025-09-09', 'Active'),
(22, 'Aditya Kale', 'aditya.k@example.com', '9000000022', 'Nashik', '2025-10-30', 'Inactive'),
(23, 'Mitali Jain', 'sameer.k@example.com', NULL, 'Pune', '2026-01-04', 'Active'),
(24, 'Kabir Naik', NULL, NULL, 'Nagpur', '2026-02-16', 'Active'),
(25, 'Diya Rao', 'diya.r@example.com', '9000000025', 'Mumbai', '2026-03-23', 'Active');

-- -------------------------
-- PRODUCT CATEGORIES AND PRODUCTS
-- Product 20 has never been ordered, for anti-join practice.
-- -------------------------
INSERT INTO categories VALUES
(1, 'Electronics'), (2, 'Office Supplies'), (3, 'Home'),
(4, 'Books'), (5, 'Accessories'), (6, 'Fitness');

INSERT INTO products VALUES
(1, 'Laptop', 1, 65000, 20, TRUE),
(2, 'Wireless Mouse', 1, 1200, 100, TRUE),
(3, 'Keyboard', 1, 1800, 75, TRUE),
(4, 'Monitor', 1, 14500, 25, TRUE),
(5, 'USB Drive', 1, 650, 150, TRUE),
(6, 'Office Chair', 3, 8500, 18, TRUE),
(7, 'Desk Lamp', 3, 1600, 45, TRUE),
(8, 'Notebook Pack', 2, 250, 300, TRUE),
(9, 'Printer Paper', 2, 450, 200, TRUE),
(10, 'Pen Set', 2, 180, 500, TRUE),
(11, 'SQL Basics Book', 4, 550, 80, TRUE),
(12, 'Python Guide', 4, 750, 65, TRUE),
(13, 'Data Analytics Book', 4, 900, 55, TRUE),
(14, 'Headphones', 1, 3200, 40, TRUE),
(15, 'Webcam', 1, 2800, 30, TRUE),
(16, 'Water Bottle', 3, 500, 120, TRUE),
(17, 'Fitness Band', 6, 2500, 35, TRUE),
(18, 'Yoga Mat', 6, 1100, 50, TRUE),
(19, 'Laptop Sleeve', 5, 850, 60, TRUE),
(20, 'Premium Projector', 1, 42000, 5, TRUE),
(21, 'Phone Stand', 5, 350, 90, TRUE),
(22, 'HDMI Cable', 5, 400, 110, TRUE),
(23, 'External SSD', 1, 7200, 22, TRUE),
(24, 'Planner', 2, 300, 100, TRUE),
(25, 'Standing Desk', 3, 18000, 8, TRUE),
(26, 'Resistance Bands', 6, 700, 70, TRUE),
(27, 'Old Webcam Model', 1, 1500, 0, FALSE);

-- -------------------------
-- ORDERS: records span 2024-2026.
-- Includes cancelled orders and customers with multiple orders.
-- -------------------------
INSERT INTO orders VALUES
(1001, 1, '2024-01-05', 'Completed', 'UPI', 'Pune'),
(1002, 2, '2024-01-12', 'Completed', 'Card', 'Mumbai'),
(1003, 1, '2024-02-03', 'Completed', 'UPI', 'Pune'),
(1004, 3, '2024-02-14', 'Completed', 'Cash', 'Nashik'),
(1005, 4, '2024-03-01', 'Completed', 'Card', 'Pune'),
(1006, 5, '2024-03-18', 'Cancelled', 'UPI', 'Nagpur'),
(1007, 6, '2024-04-09', 'Completed', 'UPI', 'Kolhapur'),
(1008, 7, '2024-04-22', 'Completed', 'Card', 'Mumbai'),
(1009, 8, '2024-05-06', 'Completed', 'UPI', 'Pune'),
(1010, 9, '2024-05-21', 'Completed', 'Cash', 'Nashik'),
(1011, 10, '2024-06-11', 'Completed', 'Card', 'Pune'),
(1012, 1, '2024-06-15', 'Completed', 'UPI', 'Pune'),
(1013, 2, '2024-07-04', 'Completed', 'UPI', 'Mumbai'),
(1014, 3, '2024-07-19', 'Pending', 'Card', 'Nashik'),
(1015, 4, '2024-08-08', 'Completed', 'UPI', 'Pune'),
(1016, 11, '2024-08-28', 'Completed', 'Cash', 'Mumbai'),
(1017, 12, '2024-09-10', 'Completed', 'Card', 'Nagpur'),
(1018, 13, '2024-09-25', 'Completed', 'UPI', 'Kolhapur'),
(1019, 14, '2024-10-02', 'Completed', 'Card', 'Pune'),
(1020, 15, '2024-10-18', 'Completed', 'UPI', 'Mumbai'),
(1021, 16, '2024-11-03', 'Completed', 'Cash', 'Nashik'),
(1022, 17, '2024-11-20', 'Completed', 'UPI', 'Pune'),
(1023, 18, '2024-12-05', 'Completed', 'Card', 'Nagpur'),
(1024, 19, '2024-12-19', 'Completed', 'UPI', 'Kolhapur'),
(1025, 1, '2025-01-07', 'Completed', 'Card', 'Pune'),
(1026, 2, '2025-01-19', 'Completed', 'UPI', 'Mumbai'),
(1027, 3, '2025-02-02', 'Completed', 'Card', 'Nashik'),
(1028, 4, '2025-02-16', 'Completed', 'UPI', 'Pune'),
(1029, 5, '2025-03-05', 'Completed', 'UPI', 'Nagpur'),
(1030, 6, '2025-03-21', 'Completed', 'Card', 'Kolhapur'),
(1031, 7, '2025-04-04', 'Completed', 'UPI', 'Mumbai'),
(1032, 8, '2025-04-17', 'Cancelled', 'Card', 'Pune'),
(1033, 9, '2025-05-08', 'Completed', 'UPI', 'Nashik'),
(1034, 10, '2025-05-24', 'Completed', 'Card', 'Pune'),
(1035, 11, '2025-06-09', 'Completed', 'UPI', 'Mumbai'),
(1036, 12, '2025-06-23', 'Completed', 'Cash', 'Nagpur'),
(1037, 13, '2025-07-06', 'Completed', 'UPI', 'Kolhapur'),
(1038, 14, '2025-07-22', 'Completed', 'Card', 'Pune'),
(1039, 15, '2025-08-02', 'Completed', 'UPI', 'Mumbai'),
(1040, 16, '2025-08-19', 'Completed', 'UPI', 'Nashik'),
(1041, 17, '2025-09-04', 'Completed', 'Card', 'Pune'),
(1042, 18, '2025-09-18', 'Completed', 'UPI', 'Nagpur'),
(1043, 19, '2025-10-09', 'Completed', 'Card', 'Kolhapur'),
(1044, 20, '2025-10-25', 'Completed', 'UPI', 'Mumbai'),
(1045, 1, '2025-11-11', 'Completed', 'UPI', 'Pune'),
(1046, 2, '2025-11-29', 'Completed', 'Card', 'Mumbai'),
(1047, 3, '2025-12-08', 'Completed', 'UPI', 'Nashik'),
(1048, 4, '2025-12-20', 'Completed', 'Card', 'Pune'),
(1049, 5, '2026-01-06', 'Completed', 'UPI', 'Nagpur'),
(1050, 6, '2026-01-18', 'Completed', 'Card', 'Kolhapur'),
(1051, 7, '2026-02-03', 'Completed', 'UPI', 'Mumbai'),
(1052, 8, '2026-02-17', 'Completed', 'Card', 'Pune'),
(1053, 9, '2026-03-02', 'Completed', 'UPI', 'Nashik'),
(1054, 10, '2026-03-14', 'Completed', 'Card', 'Pune'),
(1055, 11, '2026-04-05', 'Completed', 'UPI', 'Mumbai'),
(1056, 12, '2026-04-20', 'Pending', 'Card', 'Nagpur'),
(1057, 13, '2026-05-09', 'Completed', 'UPI', 'Kolhapur'),
(1058, 14, '2026-05-24', 'Completed', 'Card', 'Pune'),
(1059, 15, '2026-06-07', 'Completed', 'UPI', 'Mumbai'),
(1060, 16, '2026-06-22', 'Completed', 'Card', 'Nashik'),
(1061, 17, '2026-07-03', 'Completed', 'UPI', 'Pune'),
(1062, 18, '2026-07-19', 'Completed', 'Card', 'Nagpur'),
(1063, 19, '2026-08-04', 'Completed', 'UPI', 'Kolhapur'),
(1064, 20, '2026-08-20', 'Completed', 'Card', 'Mumbai'),
(1065, 21, '2026-09-05', 'Completed', 'UPI', 'Pune'),
(1066, 22, '2026-09-19', 'Cancelled', 'Card', 'Nashik'),
(1067, 23, '2026-10-01', 'Completed', 'UPI', 'Pune'),
(1068, 25, '2026-10-05', 'Completed', 'Card', 'Mumbai'),
(1069, 1, '2026-10-07', 'Completed', 'UPI', 'Pune'),
(1070, 2, '2026-10-09', 'Pending', 'Card', 'Mumbai');

-- Order items; values intentionally vary so revenue ranking is meaningful.
INSERT INTO order_items VALUES
(1,1001,1,1,65000),(2,1001,2,2,1200),
(3,1002,4,1,14500),(4,1002,8,4,250),
(5,1003,3,1,1800),(6,1003,11,2,550),
(7,1004,6,1,8500),(8,1004,10,5,180),
(9,1005,14,2,3200),(10,1005,5,3,650),
(11,1006,2,1,1200),
(12,1007,17,1,2500),(13,1007,18,2,1100),
(14,1008,4,2,14500),(15,1008,22,3,400),
(16,1009,12,2,750),(17,1009,13,1,900),
(18,1010,9,10,450),(19,1010,10,10,180),
(20,1011,15,1,2800),(21,1011,21,2,350),
(22,1012,1,1,65000),
(23,1013,23,1,7200),(24,1013,2,1,1200),
(25,1014,7,2,1600),
(26,1015,25,1,18000),(27,1015,16,2,500),
(28,1016,8,10,250),(29,1016,24,5,300),
(30,1017,14,1,3200),(31,1017,15,1,2800),
(32,1018,11,3,550),(33,1018,12,2,750),
(34,1019,3,2,1800),(35,1019,5,4,650),
(36,1020,6,1,8500),
(37,1021,19,2,850),(38,1021,21,3,350),
(39,1022,17,2,2500),(40,1022,18,1,1100),
(41,1023,1,1,65000),(42,1023,4,1,14500),
(43,1024,9,5,450),(44,1024,10,10,180),
(45,1025,1,1,65000),(46,1025,14,1,3200),
(47,1026,2,3,1200),(48,1026,3,2,1800),
(49,1027,4,1,14500),(50,1027,23,1,7200),
(51,1028,25,1,18000),
(52,1029,12,3,750),(53,1029,13,2,900),
(54,1030,17,1,2500),(55,1030,26,3,700),
(56,1031,6,2,8500),(57,1031,7,3,1600),
(58,1032,15,1,2800),
(59,1033,1,1,65000),(60,1033,2,1,1200),
(61,1034,8,20,250),(62,1034,9,10,450),
(63,1035,14,2,3200),(64,1035,15,2,2800),
(65,1036,11,5,550),(66,1036,13,2,900),
(67,1037,4,1,14500),(68,1037,22,5,400),
(69,1038,23,2,7200),
(70,1039,25,1,18000),(71,1039,6,1,8500),
(72,1040,18,3,1100),(73,1040,26,2,700),
(74,1041,1,1,65000),
(75,1042,3,2,1800),(76,1042,5,5,650),
(77,1043,12,2,750),(78,1043,11,4,550),
(79,1044,4,1,14500),(80,1044,14,1,3200),
(81,1045,1,1,65000),(82,1045,23,1,7200),
(83,1046,6,2,8500),(84,1046,16,4,500),
(85,1047,2,4,1200),(86,1047,3,2,1800),
(87,1048,25,1,18000),
(88,1049,14,1,3200),(89,1049,15,1,2800),
(90,1050,17,2,2500),(91,1050,18,2,1100),
(92,1051,1,1,65000),(93,1051,2,2,1200),
(94,1052,8,15,250),(95,1052,10,20,180),
(96,1053,23,1,7200),(97,1053,22,4,400),
(98,1054,4,2,14500),
(99,1055,12,4,750),(100,1055,13,3,900),
(101,1056,6,1,8500),
(102,1057,14,2,3200),(103,1057,5,10,650),
(104,1058,1,1,65000),
(105,1059,25,1,18000),(106,1059,7,2,1600),
(107,1060,17,2,2500),(108,1060,26,4,700),
(109,1061,4,1,14500),(110,1061,3,2,1800),
(111,1062,11,3,550),(112,1062,12,3,750),
(113,1063,23,1,7200),
(114,1064,6,2,8500),(115,1064,16,5,500),
(116,1065,1,1,65000),(117,1065,2,1,1200),
(118,1066,15,1,2800),
(119,1067,8,10,250),(120,1067,24,3,300),
(121,1068,14,1,3200),(122,1068,21,4,350),
(123,1069,1,1,65000),(124,1069,4,1,14500),
(125,1070,3,1,1800);

-- -------------------------
-- BANK ACCOUNTS AND TRANSACTIONS
-- -------------------------
INSERT INTO bank_accounts VALUES
(1, 'Aarav Account', 50000),
(2, 'Priya Account', 35000),
(3, 'Rohan Account', 72500),
(4, 'Neha Account', 18000),
(5, 'Sameer Account', 92000);

INSERT INTO bank_transactions VALUES
(5001,1,'2025-01-01 09:00:00','Credit',10000,'TX-A01'),
(5002,1,'2025-01-02 10:15:00','Debit',2500,'TX-A02'),
(5003,1,'2025-01-03 11:20:00','Debit',1000,'TX-A03'),
(5004,2,'2025-01-01 12:00:00','Credit',5000,'TX-B01'),
(5005,2,'2025-01-02 12:30:00','Debit',750,'TX-B02'),
(5006,2,'2025-01-05 15:00:00','Credit',2500,'TX-B03'),
(5007,3,'2025-02-01 08:30:00','Credit',15000,'TX-C01'),
(5008,3,'2025-02-02 09:30:00','Debit',3000,'TX-C02'),
(5009,3,'2025-02-03 10:30:00','Debit',500,'TX-C03'),
(5010,4,'2025-02-04 11:30:00','Credit',7000,'TX-D01'),
(5011,4,'2025-02-05 12:30:00','Debit',1200,'TX-D02'),
(5012,5,'2025-03-01 14:00:00','Credit',20000,'TX-E01'),
(5013,5,'2025-03-02 14:15:00','Debit',4500,'TX-E02'),
(5014,5,'2025-03-03 14:30:00','Debit',1000,'TX-E03'),
(5015,1,'2025-03-04 16:00:00','Credit',8000,'TX-A04');

-- -------------------------
-- BOOKINGS: overlapping intervals for date-overlap queries.
-- -------------------------
INSERT INTO bookings VALUES
(1,1,'Conference Room A','2026-01-01','2026-01-03','Confirmed'),
(2,2,'Conference Room A','2026-01-03','2026-01-05','Confirmed'),
(3,3,'Conference Room A','2026-01-08','2026-01-10','Confirmed'),
(4,4,'Training Room','2026-02-01','2026-02-04','Confirmed'),
(5,5,'Training Room','2026-02-03','2026-02-06','Confirmed'),
(6,6,'Conference Room A','2026-03-10','2026-03-12','Cancelled'),
(7,7,'Conference Room B','2026-03-11','2026-03-13','Confirmed'),
(8,8,'Conference Room B','2026-03-13','2026-03-15','Confirmed'),
(9,9,'Training Room','2026-04-01','2026-04-02','Confirmed'),
(10,10,'Training Room','2026-04-10','2026-04-12','Confirmed');

-- -------------------------
-- USER LOGINS: includes consecutive-day login streaks.
-- -------------------------
INSERT INTO user_logins VALUES
(1,1,'2026-01-01'),(2,1,'2026-01-02'),(3,1,'2026-01-03'),
(4,1,'2026-01-05'),(5,1,'2026-01-06'),
(6,2,'2026-01-01'),(7,2,'2026-01-03'),(8,2,'2026-01-04'),
(9,2,'2026-01-05'),(10,2,'2026-01-09'),
(11,3,'2026-02-10'),(12,3,'2026-02-11'),(13,3,'2026-02-12'),
(14,3,'2026-02-13'),(15,3,'2026-02-14'),
(16,4,'2026-02-01'),(17,4,'2026-02-04'),
(18,5,'2026-03-01'),(19,5,'2026-03-02'),(20,5,'2026-03-04'),
(21,6,'2026-03-10'),(22,6,'2026-03-11'),(23,6,'2026-03-12'),
(24,6,'2026-03-13'),(25,6,'2026-03-14'),
(26,7,'2026-04-01'),(27,7,'2026-04-02'),
(28,8,'2026-04-10'),(29,8,'2026-04-12'),
(30,9,'2026-05-01'),(31,9,'2026-05-02'),(32,9,'2026-05-03'),
(33,10,'2026-05-10');

-- -------------------------
-- Helpful indexes for optional performance practice.
-- You can drop these to compare query plans before/after.
-- -------------------------
CREATE INDEX idx_employees_department ON employees(department_id);
CREATE INDEX idx_employees_salary ON employees(salary);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_orders_date ON orders(order_date);
CREATE INDEX idx_order_items_product ON order_items(product_id);
CREATE INDEX idx_user_logins_customer_date ON user_logins(customer_id, login_date);

