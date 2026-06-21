INSERT INTO silver.erp_cust_az12(cid, bdate, gen)
SELECT 
	CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	     ELSE cid
	END cid,
	CASE WHEN bdate > GETDATE() THEN NULL
		 ELSE bdate
	END bdate,
	CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
		 ELSE 'n/a'
	END gen
FROM bronze.erp_cust_az12
;


--Check if any modified cid is left out from the cst_key of silver.crm_cust_info
--Expected : Empty
SELECT 
	cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
	     ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

--Check for bdate if bdate is very old customers or bdate is future
SELECT DISTINCT 
	bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- DATA Standardization & Consistence
SELECT DISTINCT 
	gen,
	CASE WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
		 WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
		 ELSE 'n/a'
	END gen_modified
FROM bronze.erp_cust_az12
