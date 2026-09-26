/*Task 3*/
CREATE FUNCTION dbo.get_year(@input_year DATE)
RETURNS INT
AS 
BEGIN 
 DECLARE @year INT;
 RETURN YEAR(DATEADD(MONTH,4,@input_year))
END



SELECT dbo.get_year('2023-07-15') AS fiscal_year;

SELECT
    s.date,
    s.product_code,
    p.product,
    p.variant,
    s.sold_quantity
    --g.gross_price,
   -- ROUND(s.sold_quantity * g.gross_price, 2) AS gross_price_total
FROM fact_sales_monthly s
JOIN dim_product p
    ON s.product_code = p.product_code
JOIN fact_gross_price g
    ON  g.product_code = s.product_code
   -- AND g.fiscal_year  = dbo.get_year(s.date) 
ORDER BY s.customer_code, s.date;


SELECT * FROM dim_product;
SELECT * FROM fact_gross_price;
SELECT * FROM dim_customer
SELECT * FROM fact_sales_monthly;


/*Task 4*/
SELECT s.product_code, p.product, s.date, SUM(s.sold_quantity) AS monthly_qty
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
GROUP BY s.product_code, p.product, s.date
ORDER BY s.product_code, s.date;

SELECT c.platform, c.channel,
       COUNT(DISTINCT s.customer_code) AS num_customers,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue
FROM fact_sales_monthly s
JOIN dim_customer c ON s.customer_code = c.customer_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY c.platform, c.channel
ORDER BY total_revenue DESC;

SELECT s.product_code, p.product, p.variant,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue
FROM fact_sales_monthly s
JOIN dim_product p ON s.product_code = p.product_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY s.product_code, p.product, p.variant
ORDER BY total_revenue DESC;


SELECT c.market, ff.fiscal_year, SUM(ff.forecast_quantity) AS total_forecast_qty
FROM fact_forecast_monthly ff
JOIN dim_customer c ON ff.customer_code = c.customer_code
GROUP BY c.market, ff.fiscal_year
ORDER BY c.market, ff.fiscal_year;


SELECT p.product_code, p.product, g.fiscal_year,
       g.gross_price, m.manufacturing_cost,
       g.gross_price - m.manufacturing_cost AS profit_per_unit,
       ROUND((g.gross_price - m.manufacturing_cost) / NULLIF(g.gross_price,0) * 100, 2) AS profit_margin_pct
FROM fact_gross_price g
JOIN fact_manufacturing_cost m ON g.product_code = m.product_code AND g.fiscal_year = m.cost_year
JOIN dim_product p ON p.product_code = g.product_code
ORDER BY profit_margin_pct DESC;

SELECT pre.fiscal_year, c.customer, pre.pre_invoice_discount_pct,
       SUM(s.sold_quantity * g.gross_price) AS gross_revenue,
       SUM(s.sold_quantity * g.gross_price * (1 - pre.pre_invoice_discount_pct)) AS revenue_after_discount
FROM fact_sales_monthly s
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
JOIN fact_pre_invoice_deductions pre ON pre.customer_code = s.customer_code AND pre.fiscal_year = dbo.get_year(s.date)
JOIN dim_customer c ON c.customer_code = s.customer_code
GROUP BY pre.fiscal_year, c.customer, pre.pre_invoice_discount_pct
ORDER BY pre.pre_invoice_discount_pct DESC;


SELECT market,
       ROUND(AVG(freight_pct), 4) AS avg_freight_pct,
       ROUND(AVG(other_cost_pct), 4) AS avg_other_cost_pct
FROM fact_freight_cost
GROUP BY market
ORDER BY avg_freight_pct DESC;

SELECT MONTH(s.date) AS month_num,
       DATENAME(MONTH, s.date) AS month_name,
       SUM(s.sold_quantity) AS total_qty
FROM fact_sales_monthly s
GROUP BY MONTH(s.date), DATENAME(MONTH, s.date)
ORDER BY month_num;


SELECT c.customer_code, c.customer,
       COUNT(DISTINCT s.date) AS active_months,
       COUNT(*) AS total_transactions,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue
FROM fact_sales_monthly s
JOIN dim_customer c ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY c.customer_code, c.customer
ORDER BY active_months DESC, total_revenue DESC;


SELECT ff.product_code, p.product, ff.date,
       ff.forecast_quantity,
       ISNULL(s.sold_quantity, 0) AS actual_quantity,
       ff.forecast_quantity - ISNULL(s.sold_quantity, 0) AS variance
FROM fact_forecast_monthly ff
LEFT JOIN fact_sales_monthly s
       ON s.product_code = ff.product_code AND s.customer_code = ff.customer_code AND s.date = ff.date
JOIN dim_product p ON p.product_code = ff.product_code
ORDER BY ff.product_code, ff.date;


SELECT c.platform,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue
FROM fact_sales_monthly s
JOIN dim_customer c ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY c.platform
ORDER BY total_revenue DESC;

SELECT c.region, c.market,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue
FROM fact_sales_monthly s
JOIN dim_customer c ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY c.region, c.market
ORDER BY total_revenue DESC;

SELECT p.product_code, p.product, p.category,
       SUM(s.sold_quantity) AS total_qty,
       SUM(s.sold_quantity * g.gross_price) AS total_revenue,
       ROUND(AVG(g.gross_price - m.manufacturing_cost), 2) AS avg_profit_per_unit
FROM fact_sales_monthly s
JOIN dim_product p ON p.product_code = s.product_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
JOIN fact_manufacturing_cost m ON m.product_code = s.product_code AND m.cost_year = dbo.get_year(s.date)
GROUP BY p.product_code, p.product, p.category
ORDER BY total_revenue DESC;

SELECT c.customer_code, c.customer, c.platform, c.region,
       COUNT(DISTINCT dbo.get_year(s.date)) AS active_years,
       SUM(s.sold_quantity * g.gross_price) AS lifetime_revenue
FROM fact_sales_monthly s
JOIN dim_customer c ON c.customer_code = s.customer_code
JOIN fact_gross_price g ON g.product_code = s.product_code AND g.fiscal_year = dbo.get_year(s.date)
GROUP BY c.customer_code, c.customer, c.platform, c.region
ORDER BY lifetime_revenue DESC;



