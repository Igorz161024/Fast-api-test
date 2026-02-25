SELECT column_name, data_type
FROM information_schema.columns
WHERE table_name = 'suppliers';
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    country VARCHAR(50)
);
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price NUMERIC(10,2) NOT NULL,
    stock_quantity INT NOT NULL,
    supplier_id INT REFERENCES suppliers(supplier_id)
); 
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    order_date DATE NOT NULL,
    total_amount NUMERIC(10,2) NOT NULL
);
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    product_id INT REFERENCES products(product_id),
    quantity INT NOT NULL,
    price NUMERIC(10,2) NOT NULL
);
CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,
    product_id INT REFERENCES products(product_id),
    warehouse VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    payment_date DATE NOT NULL,
    amount NUMERIC(10,2) NOT NULL,
    method VARCHAR(50) NOT NULL
);
CREATE TABLE shipments (
    shipment_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    shipment_date DATE NOT NULL,
    carrier VARCHAR(100) NOT NULL,
    tracking_number VARCHAR(50),
    status VARCHAR(50) DEFAULT 'Pending'
);
CREATE TABLE taxes (
    tax_id SERIAL PRIMARY KEY,
    country VARCHAR(50) NOT NULL,
    tax_name VARCHAR(100) NOT NULL,
    rate NUMERIC(5,2) NOT NULL,
    description TEXT
);
CREATE TABLE currencies (
    currency_id SERIAL PRIMARY KEY,
    code VARCHAR(3) NOT NULL UNIQUE,   -- Наприклад: USD, EUR, UAH
    name VARCHAR(50) NOT NULL,
    symbol VARCHAR(5),
    exchange_rate NUMERIC(12,6) NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE invoices (
    invoice_id SERIAL PRIMARY KEY,
    order_id INT REFERENCES orders(order_id),
    invoice_date DATE NOT NULL,
    due_date DATE,
    total_amount NUMERIC(10,2) NOT NULL,
    currency_id INT REFERENCES currencies(currency_id),
    status VARCHAR(50) DEFAULT 'Unpaid'
);
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    position VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    salary NUMERIC(10,2)
);
CREATE TABLE roles (
    role_id SERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    employee_id INT REFERENCES employees(employee_id),
    role_id INT REFERENCES roles(role_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Active'
);
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    action VARCHAR(100) NOT NULL,
    table_name VARCHAR(100),
    record_id INT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);
CREATE TABLE notifications (
    notification_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id),
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL,   -- Наприклад: "Order", "Payment", "System"
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Unread'
);
CREATE TABLE discounts (
    discount_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    discount_type VARCHAR(50) NOT NULL,   -- Наприклад: "Percentage", "Fixed"
    value NUMERIC(10,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(20) DEFAULT 'Active'
);
CREATE TABLE loyalty_programs (
    loyalty_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    points INT DEFAULT 0,
    level VARCHAR(50) DEFAULT 'Basic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE loyalty_programs (
    loyalty_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    points INT DEFAULT 0,
    level VARCHAR(50) DEFAULT 'Basic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE loyalty_programs (
    loyalty_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    points INT DEFAULT 0,
    level VARCHAR(50) DEFAULT 'Basic',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    assigned_to INT REFERENCES employees(employee_id),
    title VARCHAR(100) NOT NULL,
    description TEXT,
    start_date DATE NOT NULL,
    due_date DATE,
    status VARCHAR(50) DEFAULT 'Pending',
    priority VARCHAR(20) DEFAULT 'Normal'
);
CREATE TABLE reports (
    report_id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    created_by INT REFERENCES employees(employee_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    report_type VARCHAR(50) NOT NULL,   -- Наприклад: "Financial", "Sales", "Inventory"
    file_path VARCHAR(255)
);
CREATE TABLE contracts (
    contract_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES suppliers(supplier_id),
    customer_id INT REFERENCES customers(customer_id),
    contract_date DATE NOT NULL,
    expiration_date DATE,
    terms TEXT NOT NULL,
    status VARCHAR(50) DEFAULT 'Active'
);
CREATE TABLE resources (
    resource_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    type VARCHAR(50) NOT NULL,   -- Наприклад: "Equipment", "Material", "Software"
    quantity INT DEFAULT 1,
    department_id INT REFERENCES departments(department_id),
    status VARCHAR(50) DEFAULT 'Available'
);
CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    department_id INT REFERENCES departments(department_id),
    project_id INT REFERENCES projects(project_id),
    amount NUMERIC(12,2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    status VARCHAR(50) DEFAULT 'Planned'
);
CREATE TABLE attendance_leaves (
    record_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,   -- Наприклад: "Present", "Absent", "Leave", "Sick"
    leave_type VARCHAR(50),        -- Якщо статус = Leave: "Vacation", "Sick", "Unpaid"
    notes TEXT
);
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
\o tables_list.txt
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
\o tables_list.txt
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
\o tables_list.txt
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
ORDER BY table_name;
\o tables_list.txt
-- Відділи
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Проєкти
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department_id INT REFERENCES departments(department_id),
    start_date DATE
    -- Відділи
CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- Проєкти
CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    department_id INT REFERENCES departments(department_id),
    start_date DATE,
    end_date DATE
);

-- Завдання
CREATE TABLE tasks (
    task_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    name VARCHAR(150) NOT NULL,
    description TEXT,
    assigned_to INT REFERENCES employees(employee_id),
    due_date DATE,
    status VARCHAR(50)
);

-- Ресурси
CREATE TABLE resources (
    resource_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50),
    cost NUMERIC(12,2)
);

-- Бюджети
CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(project_id),
    amount NUMERIC(14,2) NOT NULL,
    currency_id INT REFERENCES currencies(currency_id),
    approved_by INT REFERENCES employees(employee_id),
    approval_date DATE
);

-- Зарплати
CREATE TABLE salaries (
    salary_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    amount NUMERIC(12,2) NOT NULL,
    currency_id INT REFERENCES currencies(currency_id),
    effective_date DATE NOT NULL
);