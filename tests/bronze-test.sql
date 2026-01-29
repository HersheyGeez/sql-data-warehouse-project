-- silver quality check

USE DataWarehouse;

/*
===========================================================
quality check for silver.crm_cust_info
===========================================================
*/

-- checking for nulls or duplicates in primary key
-- expectations: no results

SELECT 
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- query to check for unwanted spaces between texts
-- expectations: no results

--SELECT * FROM bronze.crm_cust_info;

SELECT 
cst_firstname 
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
cst_lastname 
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT 
cst_gndr 
FROM silver.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- checking for data standardization and consistency

SELECT DISTINCT
cst_gndr
FROM silver.crm_cust_info;

SELECT DISTINCT
cst_marital_status
FROM silver.crm_cust_info;

SELECT TOP (1000) * FROM silver.crm_cust_info;

/*
===========================================================

===========================================================
*/

/*
===========================================================
quality check for silver.crm_prd_info
===========================================================
*/

SELECT TOP (1000) * FROM silver.crm_prd_info;

-- null and duplicate check for table
-- expectation: no results
-- outcome: no results

SELECT
	prd_key,
	COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1 OR prd_key IS NULL;

-- check for unwanted spaces
-- expectation: no results

SELECT 
* 
FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- check for nulls or negative costs

SELECT
*
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- low cardinality column check

SELECT DISTINCT
prd_line
FROM silver.crm_prd_info;

-- date quality check

SELECT 
	*
FROM silver.crm_prd_info
WHERE prd_end_date < prd_start_date;

/*
===========================================================

===========================================================
*/

/*
===========================================================
quality check for silver.crm_sales_details
===========================================================
*/

SELECT TOP(1000) * FROM silver.crm_sales_details;

-- check for invalid dates

--SELECT 
--	NULLIF(sls_ord_dt, 0) AS sls_ord_dt
--FROM silver.crm_sales_details
--WHERE sls_ord_dt <= 0 OR LEN(sls_ord_dt) != 8;

--SELECT
--	sls_ord_dt
--FROM silver.crm_sales_details
--WHERE LEN(sls_ord_dt) < 8 OR LEN(sls_ord_dt) > 8;

--SELECT
--	sls_ship_dt
--FROM silver.crm_sales_details
--WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8;

--SELECT
--	sls_due_dt
--FROM silver.crm_sales_details
--WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8;

-- check for invalid date orders

SELECT
	*
FROM silver.crm_sales_details
WHERE sls_ord_dt > sls_due_dt OR sls_ord_dt > sls_ship_dt;

-- checking data consistency between sales, quantity and price
-- >> Sales = Quantity * Price
-- >> Values must not be Null, zero or negatives

SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,

CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != ABS(sls_price) * sls_quantity
		THEN ABS(sls_price) * sls_quantity
	 ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity,0)
	 ELSE sls_price
END AS sls_price

FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;



/*
===========================================================

===========================================================
*/

/*
===========================================================
quality check for silver.erp_cust_az12
===========================================================
*/

SELECT
*
FROM silver.erp_cust_az12
WHERE bdate > GETDATE();

SELECT DISTINCT
gen
FROM silver.erp_cust_az12;

SELECT TOP(1000) * FROM silver.erp_cust_az12;

/*
===========================================================
quality check for silver.erp_loc_a101
===========================================================
*/

SELECT TOP (1000) * FROM silver.erp_loc_a101;

SELECT DISTINCT (cntry) FROM silver.erp_loc_a101;

SELECT cid FROM silver.erp_loc_a101
WHERE cid
NOT IN (SELECT cst_key FROM silver.crm_cust_info);

/*
===========================================================

===========================================================
*/

/*
===========================================================
quality check for silver.erp_px_cat_g1v2
===========================================================
*/

SELECT TOP (1000) * FROM silver.erp_px_cat_g1v2;


/*
===========================================================

===========================================================
*/
