INSERT INTO silver.erp_loc_a101(cid,cntry)
SELECT 
	REPLACE(cid,'-','') cid,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END cntry
FROM bronze.erp_loc_a101;

SELECT *
FROM silver.erp_loc_a101
;
-- Removing " - " in cid and checking 
-- Expected empty
SELECT 
	cid,
	cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid,'-','') NOT IN (SELECT cst_key FROM silver.crm_cust_info)
;

-- Data Standardization & Consistency
SELECT DISTINCT
	cntry,
	CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
		 ELSE TRIM(cntry)
	END cntry_modified
FROM bronze.erp_loc_a101
ORDER BY cntry
;
