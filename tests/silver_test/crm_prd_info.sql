SELECT
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id,
	SUBSTRING(prd_key,7,LEN(prd_key)) AS sls_prd_key,
	prd_nm,
	ISNULL(prd_cost,0) AS prd_cost,
	CASE 
		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST(prd_start_dt AS DATE) AS prd_start_dt,
	CAST(LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info 
ORDER BY prd_key,prd_start_dt

 -- Check for Invalid Date Orders
 SELECT *
 FROM bronze.crm_prd_info
 WHERE prd_end_dt < prd_start_dt
 ORDER BY prd_key

--Data normalization and standardization
SELECT DISTINCT
	prd_line
FROM bronze.crm_prd_info 

--Check for NULLs or Negative Numbers of cost
--Expectation: No results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

--Check for unwanted spaces
--Expectation: No results
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)

-- To find the unmatched data after applying data transformation 
SELECT DISTINCT
	SUBSTRING(prd_key,7,LEN(prd_key)) AS sls_prd_key
FROM bronze.crm_prd_info 
WHERE SUBSTRING(prd_key,7,LEN(prd_key)) NOT IN (SELECT DISTINCT sls_prd_key FROM bronze.crm_sales_details)


-- Checking if prd_id has null or duplicate values
SELECT 
	prd_id,
	COUNT(*) AS count
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--CHECKING how prd_key is related
SELECT *
FROM bronze.crm_sales_details
;
SELECT
	*
FROM bronze.crm_prd_info
WHERE prd_key LIKE '%BK-R93R-62%' OR prd_key LIKE '%AC_BR%'
;

SELECT *
FROM bronze.erp_PX_CAT_G1V2
