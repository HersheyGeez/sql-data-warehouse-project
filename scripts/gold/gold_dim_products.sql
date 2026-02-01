/*
===============================================================================
View Name   : gold.dim_products
File Name   : gold_dim_products.sql
Layer       : Gold
Object Type : Dimension View
Grain       : One row per active product

Description :
    This view represents the Product dimension in the Gold layer of the
    Data Warehouse. It provides a consolidated, business-friendly view
    of active products by enriching CRM product data with category and
    classification attributes from ERP sources.

    The view filters out inactive products and applies transformations
    to ensure the data is analytics-ready for reporting and downstream
    fact table joins.

Source Tables :
    - silver.crm_prd_info
    - silver.erp_px_cat_g1v2

Key Transformations :
    - Surrogate key generation using ROW_NUMBER()
    - Filtering to retain only active products (prd_end_date IS NULL)
    - Denormalization of product and category attributes
    - Null handling and standardization of descriptive fields

Usage :
    This dimension is intended to be joined with Gold-layer fact tables
    using the product_key surrogate key.

Author      : Harsh Gupta
Created On  : 2026-01-30
===============================================================================
*/

USE DataWarehouse;
GO

CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER(ORDER BY pn.prd_start_date, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	COALESCE(pn.prd_nm, 'n/a') AS product_name,
	pn.cat_id AS category_id,
	COALESCE(pc.cat, 'n/a') AS category,
	COALESCE(pc.subcat, 'n/a') AS subcategory,
	COALESCE(pc.maintenance, 'n/a') AS maintenance,
	CASE WHEN pn.prd_cost >= 0 THEN pn.prd_cost
		 ELSE NULL
	END AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_date AS start_date
FROM silver.crm_prd_info AS pn
LEFT JOIN silver.erp_px_cat_g1v2 AS pc
	ON pc.id = pn.cat_id
WHERE pn.prd_end_date IS NULL;


