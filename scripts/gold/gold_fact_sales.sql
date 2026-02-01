/*
===============================================================================
View Name   : gold.fact_sales
File Name   : gold_fact_sales.sql
Layer       : Gold
Object Type : Fact View
Grain       : One row per order–product–customer line item

Description :
    This view represents the Sales fact in the Gold layer of the
    Data Warehouse. It captures transactional sales measures and
    links them to the relevant Product and Customer dimensions
    using surrogate keys.

    The view applies defensive logic to handle missing dimension
    references and ensures the fact data is analytics-ready for
    reporting and BI consumption.

Source Tables :
    - silver.crm_sales_details
    - gold.dim_products
    - gold.dim_customers

Key Transformations :
    - Mapping of natural keys to surrogate dimension keys
    - Handling of unknown dimension references using default keys
    - Selection and standardization of sales measures
    - Exposure of order, shipping, and due dates for time analysis

Usage :
    This fact view is intended to be joined with Gold-layer
    dimension views using surrogate keys (product_key,
    customer_key) for analytical queries and dashboards.

Author      : Harsh Gupta
Created On  : 2026-01-30
===============================================================================
*/

USE DataWarehouse;
GO

CREATE VIEW gold.fact_sales AS
SELECT
	sd.sls_ord_num AS order_number,
	COALESCE(pr.product_key, -1) AS product_key,
	COALESCE(cu.customer_key, -1) AS customer_key,
	sd.sls_ord_dt AS order_date,
	sd.sls_ship_dt AS shipping_date,
	sd.sls_due_dt AS due_date,
	CASE WHEN sd.sls_sales >= 0 THEN sd.sls_sales
		 ELSE 0
	END AS sales_amount,
	CASE WHEN sd.sls_quantity > 0 THEN sd.sls_quantity
		 ELSE 0
	END as quantity,
	sd.sls_price AS price
FROM silver.crm_sales_details AS sd
LEFT JOIN gold.dim_products AS pr
	ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers AS cu
	ON sd.sls_cust_id = cu.customer_id;
