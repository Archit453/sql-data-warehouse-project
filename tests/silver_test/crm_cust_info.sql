--Checking that PK is unique and not null
--Expecting : No result

SELECT 
	prd_id,
	COUNT(*) AS 'count'
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

--Checking for unwanted space
--Expecting : No result
SELECT 
	cst_key
FROM silver.crm_cust_info
WHERE TRIM(cst_key) != cst_key

--Data normalization and standardization
SELECT DISTINCT
	cst_gndr
FROM silver.crm_cust_info

SELECT DISTINCT
	cst_marital_status
FROM silver.crm_cust_info


