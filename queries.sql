-- The top 5 products that had more revenue in womanswear in 2026

SELECT p.product_name, SUM(ti.quantity) AS total_units_sold,
SUM(ti.quantity * ti.unit_price) AS total_revenue
FROM products p
JOIN transaction_items ti ON ti.product_id = p.id
JOIN sales_transactions st ON st.id = ti.transaction_id
WHERE p.gender = 'Womenswear' AND YEAR(st.date_occured) = 2026
GROUP BY p.id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- The top 5 products that had more revenue in womanswear in 2025

SELECT p.product_name, SUM(ti.quantity) AS total_units_sold,
SUM(ti.quantity * ti.unit_price) AS total_revenue
FROM products p
JOIN transaction_items ti ON ti.product_id = p.id
JOIN sales_transactions st ON st.id = ti.transaction_id
WHERE p.gender = 'Womenswear' AND YEAR(st.date_occured) = 2025
GROUP BY p.id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- The top 5 products that had more revenue in menswear in 2026

SELECT p.product_name, SUM(ti.quantity) AS total_units_sold,
SUM(ti.quantity * ti.unit_price) AS total_revenue
FROM products p
JOIN transaction_items ti ON ti.product_id = p.id
JOIN sales_transactions st ON st.id = ti.transaction_id
WHERE p.gender = 'Menswear' AND YEAR(st.date_occured) = 2026
GROUP BY p.id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;

-- The top 5 products that had more revenue in menswear in 2025

SELECT p.product_name, SUM(ti.quantity) AS total_units_sold,
SUM(ti.quantity * ti.unit_price) AS total_revenue
FROM products p
JOIN transaction_items ti ON ti.product_id = p.id
JOIN sales_transactions st ON st.id = ti.transaction_id
WHERE p.gender = 'Menswear' AND YEAR(st.date_occured) = 2026
GROUP BY p.id, p.product_name
ORDER BY total_revenue DESC
LIMIT 5;


-- How commission were distributed in 2026? 
SELECT employee_sales.first_name,
       employee_sales.last_name,
       employee_sales.total_sales,
       cr.commission_rate,
       ROUND((cr.commission_rate / 100) * employee_sales.total_sales, 2) AS commission_earned
FROM (
        SELECT e.id,
               e.first_name,
               e.last_name,
               SUM(ti.quantity * ti.unit_price) AS total_sales
        FROM employees e
        JOIN sales_transactions st
            ON e.id = st.employee_id
        JOIN transaction_items ti
            ON st.id = ti.transaction_id
        WHERE YEAR(st.date_occured) = 2026
        GROUP BY e.id, e.first_name, e.last_name
) AS employee_sales
JOIN commission_rules cr
ON employee_sales.total_sales >= cr.min_sales_amount
AND employee_sales.total_sales <= cr.max_sales_amount
ORDER BY commission_earned DESC
LIMIT 5;

-- How commission were distributed in 2025?

SELECT employee_sales.first_name,
       employee_sales.last_name,
       employee_sales.total_sales,
       cr.commission_rate,
       ROUND((cr.commission_rate / 100) * employee_sales.total_sales, 2) AS commission_earned
FROM (
        SELECT e.id,
               e.first_name,
               e.last_name,
               SUM(ti.quantity * ti.unit_price) AS total_sales
        FROM employees e
        JOIN sales_transactions st
            ON e.id = st.employee_id
        JOIN transaction_items ti
            ON st.id = ti.transaction_id
        WHERE YEAR(st.date_occured) = 2025
        GROUP BY e.id, e.first_name, e.last_name
) AS employee_sales
JOIN commission_rules cr
ON employee_sales.total_sales >= cr.min_sales_amount
AND employee_sales.total_sales <= cr.max_sales_amount
ORDER BY commission_earned DESC
LIMIT 5;

-- What is the percentage of payment methods in 2026 

SELECT  pm.name AS payment_method,
        SUM(tp.amount) AS total_amount, 
        ROUND(
            (SUM(tp.amount)/ (
                SELECT SUM(tp2.amount)  
                FROM transaction_payments tp2 
                JOIN sales_transactions st2
                ON st2.id = tp2.transaction_id
                WHERE YEAR(st2.date_occured) = 2026
            )) * 100, 
            2
        ) AS percentage_payment
        FROM transaction_payments tp
        JOIN payment_methods pm
        ON pm.id = tp.payment_method_id
        JOIN sales_transactions st
        ON st.id = tp.transaction_id
        WHERE YEAR(st.date_occured) = 2026
        GROUP BY pm.id, pm.name
        ORDER BY percentage_payment DESC; 

-- What is the percentage of payment methods in 2025 

SELECT  pm.name AS payment_method,
        SUM(tp.amount) AS total_amount, 
        ROUND(
            (SUM(tp.amount)/ (
                SELECT SUM(tp2.amount)  
                FROM transaction_payments tp2 
                JOIN sales_transactions st2
                ON st2.id = tp2.transaction_id
                WHERE YEAR(st2.date_occured) = 2025
            )) * 100, 
            2
        ) AS percentage_payment
        FROM transaction_payments tp
        JOIN payment_methods pm
        ON pm.id = tp.payment_method_id
        JOIN sales_transactions st
        ON st.id = tp.transaction_id
        WHERE YEAR(st.date_occured) = 2025
        GROUP BY pm.id, pm.name
        ORDER BY percentage_payment DESC;        

-- Total value in refunds in 2026 categorised per month 

SELECT  MONTHNAME(r.refund_date) AS month_refund,
        ROUND(SUM(r.quantity * ti.unit_price),2)
FROM refunds r
JOIN transaction_items ti
ON r.transaction_item_id = ti.id
WHERE YEAR(refund_date) = 2026
GROUP BY MONTH(r.refund_date)
ORDER BY month_refund;

-- How are the reasons of refunds are distributed and how much is costing in 2026

SELECT  r.refund_reason,
        ROUND(SUM(r.quantity * ti.unit_price),2) AS total_refunded, 
        ROUND((
            SUM(r.quantity * ti.unit_price) / (
                SELECT SUM(r2.quantity * ti2.unit_price)
                FROM refunds r2 
                JOIN transaction_items ti2
                ON r2.transaction_item_id = ti2.id 
            )) * 100 , 2
        ) AS percentage_reason
FROM refunds r 
JOIN transaction_items ti
ON r.transaction_item_id = ti.id
GROUP BY r.refund_reason
ORDER BY total_refunded DESC;