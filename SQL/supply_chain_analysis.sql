CREATE TABLE supply_chain (
    Product_type TEXT,
    SKU TEXT,
    Price NUMERIC,
    Availability INT,
    Number_of_products_sold INT,
    Revenue_generated NUMERIC,
    Customer_demographics TEXT,
    Stock_levels INT,
    Lead_times INT,
    Order_quantities INT,
    Shipping_times INT,
    Shipping_carriers TEXT,
    Shipping_costs NUMERIC,
    Supplier_name TEXT,
    Location TEXT,
    Lead_time INT,
    Production_volumes INT,
    Manufacturing_lead_time INT,
    Manufacturing_costs NUMERIC,
    Inspection_results TEXT,
    Defect_rates NUMERIC,
    Transportation_modes TEXT,
    Routes TEXT,
    Costs NUMERIC,
    Profit_Margin NUMERIC,
    Revenue_Category TEXT,
    Shipping_Efficiency NUMERIC
);

SELECT * FROM supply_chain;

-- Total Records
SELECT COUNT(*) AS total_records
FROM supply_chain;

-- Total Revenue
SELECT SUM(revenue_generated) AS total_revenue
FROM supply_chain;

-- Average Shipping Cost
SELECT AVG(shipping_costs) AS avg_shipping_cost
FROM supply_chain;

-- Unique Products
SELECT DISTINCT product_type
FROM supply_chain;

-- Revenue by Product Type
SELECT product_type,
       SUM(revenue_generated) AS total_revenue
FROM supply_chain
GROUP BY product_type
ORDER BY total_revenue DESC;

-- Top 5 Suppliers by Revenue
SELECT supplier_name,
       SUM(revenue_generated) AS total_revenue
FROM supply_chain
GROUP BY supplier_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Average Defect Rate by Supplier
SELECT supplier_name,
       AVG(defect_rates) AS avg_defect_rate
FROM supply_chain
GROUP BY supplier_name
ORDER BY avg_defect_rate DESC;

-- Shipping Cost by Transport Mode
SELECT transportation_modes,
       AVG(shipping_costs) AS avg_shipping_cost
FROM supply_chain
GROUP BY transportation_modes;

-- Products with Low Stock
SELECT product_type, stock_levels
FROM supply_chain
WHERE stock_levels < 20
ORDER BY stock_levels ASC;

-- High Revenue Products
SELECT product_type, revenue_generated
FROM supply_chain
WHERE revenue_generated > 1000
ORDER BY revenue_generated DESC;

-- Revenue Ranking by Product Type
SELECT Product_type,
       SUM(Revenue_generated) AS total_revenue,
       RANK() OVER (
           ORDER BY SUM(Revenue_generated) DESC
       ) AS revenue_rank
FROM supply_chain
GROUP BY Product_type;

-- Dense Rank of Suppliers
SELECT Supplier_name,
       SUM(Revenue_generated) AS total_revenue,
       DENSE_RANK() OVER (
           ORDER BY SUM(Revenue_generated) DESC
       ) AS supplier_rank
FROM supply_chain
GROUP BY Supplier_name;

-- Running Total of Revenue
SELECT SKU,
       Revenue_generated,
       SUM(Revenue_generated)
       OVER (
           ORDER BY Revenue_generated
       ) AS running_total
FROM supply_chain;

--Revenue Category
SELECT Product_type,
       Revenue_generated,
       CASE
           WHEN Revenue_generated > 8000 THEN 'High Revenue'
           WHEN Revenue_generated > 4000 THEN 'Medium Revenue'
           ELSE 'Low Revenue'
       END AS revenue_category
FROM supply_chain;

-- Top Product in Each Category
SELECT *
FROM (
    SELECT Product_type,
           SKU,
           Revenue_generated,
           RANK() OVER (
               PARTITION BY Product_type
               ORDER BY Revenue_generated DESC
           ) AS rank_num
    FROM supply_chain
) ranked_data
WHERE rank_num = 1;

-- Average Shipping Cost Compared to Overall Average
SELECT SKU,
       Shipping_costs,
       AVG(Shipping_costs) OVER () AS overall_avg_shipping
FROM supply_chain;

-- Find High Defect Suppliers
SELECT Supplier_name,
       AVG(Defect_rates) AS avg_defect_rate
FROM supply_chain
GROUP BY Supplier_name
HAVING AVG(Defect_rates) > 2;

-- Most Expensive Products
SELECT SKU,
       Price
FROM supply_chain
ORDER BY Price DESC
LIMIT 10;

-- Lowest Inventory Products
SELECT SKU,
       Stock_levels
FROM supply_chain
ORDER BY Stock_levels ASC
LIMIT 10;

-- Profit Margin Analysis
SELECT Product_type,
       AVG(Profit_Margin) AS avg_profit_margin
FROM supply_chain
GROUP BY Product_type
ORDER BY avg_profit_margin DESC;



