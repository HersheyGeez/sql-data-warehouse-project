/*
===============================================================================
View Name   : gold.dim_customers
File Name   : gold_dim_customers.sql
Layer       : Gold
Object Type : Dimension View
Grain       : One row per customer

Description :
    This view represents the Customer dimension in the Gold layer of the
    Data Warehouse. It consolidates and enriches customer-related data from
    multiple Silver-layer source tables into a single, analytics-ready
    dimension.

    The view applies business rules to:
    - Resolve and standardize customer gender values
    - Enrich customer records with demographic and location attributes
    - Provide a surrogate customer key for downstream fact table joins

Source Tables :
    - silver.crm_cust_info
    - silver.erp_cust_az12
    - silver.erp_loc_a101

Key Transformations :
    - Surrogate key generation using ROW_NUMBER()
    - Gender resolution logic with source prioritization
    - Null handling for business-facing attributes
    - Denormalization across CRM and ERP sources

Usage :
    This dimension is intended to be joined with Gold-layer fact tables
    using the customer_key surrogate key.

Author      : Harsh Gupta
Created On  : 2026-01-30
===============================================================================
*/



USE DataWarehouse;
GO

CREATE VIEW gold.dim_customers AS
	SELECT 
		ROW_NUMBER() OVER(ORDER BY ci.cst_key) AS customer_key,
 		ci.cst_id AS customer_id,
		ci.cst_key AS customer_number,
		COALESCE(ci.cst_firstname, 'n/a') AS first_name,
		COALESCE(ci.cst_lastname, 'n/a') AS last_name,
		COALESCE(la.cntry, 'n/a') AS country,
		ci.cst_marital_status AS marital_status,
		CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
			 ELSE COALESCE(ca.gen, 'n/a')
		END gender,
		ca.bdate AS birthdate,
		ci.cst_create_date AS create_date
	FROM silver.crm_cust_info AS ci
	LEFT JOIN silver.erp_cust_az12  AS ca
		ON ci.cst_key = ca.cid
	LEFT JOIN silver.erp_loc_a101 AS la
		ON ci.cst_key = la.cid
GO

