USE DataWarehouse;


/*
=====================================================
	QUALITY TEST FOR bronze.crm_cust_info
=====================================================
*/
-- checking for nulls or duplicates in primary key
-- expectations: no results

SELECT 
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- query to check for unwanted spaces between texts
-- expectations: no results

SELECT * FROM bronze.crm_cust_info;

SELECT 
cst_firstname 
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT 
cst_lastname 
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT 
cst_gndr 
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);

-- checking for data standardization and consistency

SELECT DISTINCT
cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT
cst_marital_status
FROM bronze.crm_cust_info;

/*
=====================================================
	
=====================================================
*/


/*
=====================================================
	QUALITY TEST FOR bronze.crm_prod_info
=====================================================
*/

SELECT TOP(1000) * FROM bronze.crm_prd_info;

-- null and duplicate check for table
-- expectation: no results
-- outcome: no results

SELECT
	prd_id,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

SELECT
	prd_key,
	COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*) > 1 OR prd_key IS NULL;

-- check for unwanted spaces
-- expectation: no results

SELECT 
* 
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- check for nulls or negative costs

SELECT
*
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- low cardinality column check

SELECT DISTINCT
prd_line
FROM bronze.crm_prd_info;

-- date quality check

SELECT 
	*
FROM bronze.crm_prd_info
WHERE prd_end_date < prd_start_date;

/*
=====================================================

=====================================================
*/

/*
=====================================================
	QUALITY TEST FOR bronze.crm_sales_details
=====================================================
*/

SELECT TOP (1000) * FROM bronze.crm_sales_details;

-- check for invalid dates

SELECT 
	NULLIF(sls_ord_dt, 0) AS sls_ord_dt
FROM bronze.crm_sales_details
WHERE sls_ord_dt <= 0 OR LEN(sls_ord_dt) != 8;

SELECT
	sls_ord_dt
FROM bronze.crm_sales_details
WHERE LEN(sls_ord_dt) < 8 OR LEN(sls_ord_dt) > 8;

SELECT
	sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <= 0 OR LEN(sls_ship_dt) != 8;

SELECT
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8;

-- check for invalid date orders

SELECT
	*
FROM bronze.crm_sales_details
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

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL
OR sls_quantity IS NULL
OR sls_price IS NULL
OR sls_sales <= 0
OR sls_quantity <= 0
OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

/*
=====================================================

=====================================================
*/

/*
=====================================================
	QUALITY TEST FOR bronze.erp_cust_az12
=====================================================
*/

SELECT 
cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE gen != TRIM(gen);

SELECT DISTINCT
cid
FROM bronze.erp_cust_az12;

SELECT * FROM silver.crm_cust_info;

SELECT
*
FROM bronze.erp_cust_az12
WHERE bdate > GETDATE();

SELECT DISTINCT
gen
FROM bronze.erp_cust_az12;

/*
=====================================================

=====================================================
*/

/*
=====================================================
	QUALITY TEST FOR bronze.erp_cust_az12
=====================================================
*/

SELECT TOP (1000) * FROM bronze.erp_loc_a101;

SELECT DISTINCT
cntry,
CASE WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
	 WHEN UPPER(TRIM(cntry)) IN ('US','USA','UNITED STATES') THEN 'United States of America'
	 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;

/*
=====================================================

=====================================================
*/

/*
=====================================================
	QUALITY TEST FOR bronze.erp_cust_az12
=====================================================
*/

SELECT TOP (1000) * FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
subcat
FROM bronze.erp_px_cat_g1v2;

SELECT DISTINCT
maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT * FROM silver.crm_prd_info;

SELECT id
FROM bronze.erp_px_cat_g1v2
WHERE id NOT IN (SELECT cat_id FROM silver.crm_prd_info);

SELECT 
cat
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);

SELECT DISTINCT cat FROM bronze.erp_px_cat_g1v2;

/*
=====================================================

=====================================================
*/



