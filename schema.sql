
CREATE TABLE roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 


CREATE TABLE employees (
   id INT AUTO_INCREMENT PRIMARY KEY,
   first_name VARCHAR(50) NOT NULL,
   last_name VARCHAR(50) NOT NULL,
   started_at DATE NOT NULL,
   role_id INT NOT NULL,
   hourly_rate DECIMAL(10,2) CHECK (hourly_rate > 0),
   FOREIGN KEY (role_id) REFERENCES roles(id)   
);

CREATE TABLE employee_shifts (
   id INT AUTO_INCREMENT PRIMARY KEY,
   employee_id INT NOT NULL,
   shift_date DATE NOT NULL,
   hours_worked DECIMAL(5,2) NOT NULL CHECK (hours_worked > 0),
   FOREIGN KEY (employee_id) REFERENCES employees(id),
   INDEX (employee_id)
);


CREATE TABLE sales_transactions (
   id INT AUTO_INCREMENT PRIMARY KEY,
   date_occured DATETIME NOT NULL,
   employee_id INT NOT NULL,
   FOREIGN KEY (employee_id) REFERENCES employees(id)
);

CREATE TABLE transaction_items (
   id INT AUTO_INCREMENT PRIMARY KEY,
   transaction_id INT NOT NULL,
   product_id INT NOT NULL,
   quantity INT NOT NULL CHECK(quantity > 0),
   unit_price DECIMAL (10,2),
   FOREIGN KEY (transaction_id) REFERENCES sales_transactions(id),
   FOREIGN KEY (product_id) REFERENCES products(id),
   INDEX (transaction_id, product_id) 
);

CREATE TABLE products (
   id INT AUTO_INCREMENT PRIMARY KEY,
   product_name VARCHAR(50) NOT NULL UNIQUE,
   price DECIMAL(10,2) NOT NULL CHECK (price > 0),
   cost DECIMAL(10,2) NOT NULL CHECK (cost > 0),
   stock_quantity INT NOT NULL CHECK(stock_quantity > 0),
   gender ENUM('Womanswear', 'Menswear') 
); 

CREATE TABLE transaction_payments(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    transaction_id INT NULL,
    payment_method_id INT NULL,
    amount DECIMAL(8, 2) NULL,
    FOREIGN KEY(transaction_id) REFERENCES sales_transactions(id),
    FOREIGN KEY(payment_method_id) REFERENCES payment_methods(id)
);

CREATE TABLE payment_methods(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NULL
);

CREATE TABLE refunds(
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    transaction_item_id INT NOT NULL,
    refund_date DATETIME NOT NULL,
    quantity INT NOT NULL CHECK(quantity > 0),
    refund_reason ENUM( 'Change of mind', 'wrong size','faulty','other'
    ) NOT NULL,
    FOREIGN KEY(transaction_item_id) REFERENCES transaction_items(id)
);


CREATE  TABLE  commission_rules (
    id INT NOT NULL  AUTO_INCREMENT PRIMARY KEY,
    min_sales_amount DECIMAL(8, 2) NULL CHECK(min_sales_amount > 0),
    max_sales_amount DECIMAL(8, 2) NULL CHECK (max_sales_amount > min_sales_amount),
    commission_rate DECIMAL(8, 2) NULL
);

ALTER TABLE transaction_items 
MODIFY unit_price DECIMAL(10,2) NOT NULL;

