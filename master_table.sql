WITH new_orders AS (
  SELECT 
    CustomerID,
    ProdNumber,
    Date AS order_date,
    Quantity AS order_qty
  FROM `RM.Orders`
),
new_customer AS (
  SELECT
    CustomerID,
    REGEXP_EXTRACT(CustomerEmail, r'^[^#]+') AS cust_email,
    CustomerCity AS cust_city
  FROM `RM.Customers`
),
new_products as(
SELECT
  ProdNumber,
  Category,
  ProdName AS product_name,
  Price AS product_price
FROM `RM.Products`
),
new_prod_cat AS(
  SELECT
    CategoryID,
    CategoryName AS category_name
  FROM `RM.Prod_Cat`
), 
master_table AS (
  SELECT
    order_date,
    pc.category_name,
    p.product_name,
    p.product_price,
    o.order_qty,
    ROUND(o.order_qty*p.product_price,1) AS total_sales,
    c.cust_email,
    c.cust_city,  
  FROM new_orders o
  JOIN new_customer c ON o.CustomerID = c.CustomerID
  JOIN new_products p ON o.ProdNumber = p.ProdNumber
  JOIN new_prod_cat pc ON p.Category = pc.CategoryID
)

SELECT * FROM master_table
ORDER BY master_table.order_date, order_qty