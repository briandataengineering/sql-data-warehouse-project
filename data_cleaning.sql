<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CLEANING CUSTOMER INFO DATA_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT *
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` 

--Aggregating primary key to find duplicates
SELECT cst_id, count(*)
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` 
GROUP BY cst_id
HAVING COUNT(*)>1


--removing duplicate
SELECT *
FROM(
SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ranking
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` 
)
WHERE ranking=1


--checking unwanted spaces
SELECT cst_firstname
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` 
WHERE cst_firstname != TRIM(cst_firstname)

-- Clean data
SELECT cst_id,
       cst_key,
       TRIM(cst_firstname) AS cst_firstname ,
       TRIM(cst_lastname) AS cst_lastname,
       CASE WHEN cst_gndr = 'F' THEN 'Female'
            WHEN cst_gndr = 'M' THEN 'Male'
       ELSE ''
       END cst_gndr, 
       CASE WHEN cst_marital_status = 'M' THEN 'Married'
            WHEN cst_marital_status = 'S' THEN 'Single'
       ELSE ''
       END cst_marital_status
FROM(
SELECT *, ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ranking
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` 
)
WHERE ranking=1 AND cst_id IS NOT NULL


--Inserting data back into the tables

INSERT INTO `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` (
  cst_id,
  cst_key,
  cst_firstname,
  cst_lastname,
  cst_marital_status,
  cst_gndr,
  cst_create_date
)
SELECT 
  cst_id,
  cst_key,
  TRIM(cst_firstname) AS cst_firstname,
  TRIM(cst_lastname) AS cst_lastname,
  CASE 
    WHEN cst_marital_status = 'M' THEN 'Married'
    WHEN cst_marital_status = 'S' THEN 'Single'
    ELSE ''
  END AS cst_marital_status,
  CASE 
    WHEN cst_gndr = 'F' THEN 'Female'
    WHEN cst_gndr = 'M' THEN 'Male'
    ELSE ''
  END AS cst_gndr,
  cst_create_date
FROM (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS ranking
  FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info`
)
WHERE ranking = 1 AND cst_id IS NOT NULL

<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CLEANING PRODUCT INFO DATA_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
--Cleaning product info table
SELECT * 
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 

--Checking product ID duplicate
SELECT prd_id,
       ROW_NUMBER() OVER(PARTITION BY prd_id) as ranking
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 
GROUP BY prd_id
HAVING COUNT(*)>1


--Getting category id and cleaning by replacing dash with underscore
SELECT 
      prd_id,
      prd_key,
      REPLACE(SUBSTRING(prd_key,1, 5), '-', '_') AS cat_id,
      SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
      prd_nm,
      prd_cost,
      prd_line,
      prd_start_dt,
      prd_end_dt
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 


--CHECKING whether there null or negative cost
SELECT prd_cost
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 
WHERE prd_cost <0 OR prd_cost IS NULL


--Replacing null cost with zero
SELECT 
      prd_id,
      prd_key,
      REPLACE(SUBSTRING(prd_key,1, 5), '-', '_') AS cat_id,
      SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
      prd_nm,
      IFNULL(prd_cost,0) AS prd_cost,
      prd_line,
      prd_start_dt,
      prd_end_dt
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 

--Checking distinct product line
SELECT DISTINCT(prd_line)
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info`

--Data normalization and standadization for product line column
SELECT 
      prd_id,
      prd_key,
      REPLACE(SUBSTRING(prd_key,1, 5), '-', '_') AS cat_id,
      SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key, 
      prd_nm,
      IFNULL(prd_cost,0) AS prd_cost,
      CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
           WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
           WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
           WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
      ELSE 'n/a'
      END AS prd_line,
      prd_start_dt,
      prd_end_dt
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 

--start and end date cleaning
SELECT 
      prd_id,
      SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
      REPLACE(SUBSTRING(prd_key,1, 5), '-', '_') AS cat_id, 
      prd_nm,
      IFNULL(prd_cost,0) AS prd_cost,
      CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
           WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
           WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
           WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
      ELSE 'n/a'
      END AS prd_line,
      prd_start_dt,
      LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 

--Inserting data into table
INSERT INTO `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info`(
      prd_id,
      prd_key,
      cat_id,
      prd_key, 
      prd_nm,
      prd_cost,
      prd_line,
      prd_start_dt,
      prd_end_dt
)
SELECT 
      prd_id,
      SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
      REPLACE(SUBSTRING(prd_key,1, 5), '-', '_') AS cat_id, 
      prd_nm,
      IFNULL(prd_cost,0) AS prd_cost,
      CASE WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
           WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
           WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
           WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
      ELSE 'n/a'
      END AS prd_line,
      prd_start_dt,
      LEAD(prd_start_dt) OVER(PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` 


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CLEANING SALES DATA_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT * 
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details` 

--Cleaning start order sate column with 0

SELECT 
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_order_dt AS STRING)) AS sls_order_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_ship_dt AS STRING)) AS sls_ship_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_due_dt AS STRING)) AS sls_due_dt,
  sls_sales,
  sls_quantity,
  sls_price
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`

--Checking sales, quantity and price quality issues
SELECT 
  sls_sales,
  sls_quantity,
  sls_price
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`
WHERE  sls_sales != sls_quantity* sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
ORDER BY sls_sales ASC


--Cleaning sales, quantity and price columns
SELECT 
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_order_dt AS STRING)) AS sls_order_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_ship_dt AS STRING)) AS sls_ship_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_due_dt AS STRING)) AS sls_due_dt,
  CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity* ABS(sls_price)
            THEN sls_quantity* ABS(sls_price)
            ELSE sls_sales
            END AS sls_sales,
    sls_quantity,
  CASE WHEN sls_price IS NULL OR sls_price<= 0
            THEN sls_sales/NULLIF(sls_quantity, 0)
            ELSE sls_price
            END AS sls_price
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`


--Inserting data
INSERT INTO `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`(
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  sls_order_dt,
  sls_ship_dt,
  sls_due_dt,
  sls_sales,
  sls_quantity,
  sls_price
)
SELECT 
  sls_ord_num,
  sls_prd_key,
  sls_cust_id,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_order_dt AS STRING)) AS sls_order_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_ship_dt AS STRING)) AS sls_ship_dt,
  SAFE.PARSE_DATE('%Y%m%d', CAST(sls_due_dt AS STRING)) AS sls_due_dt,
  CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity* ABS(sls_price)
            THEN sls_quantity* ABS(sls_price)
            ELSE sls_sales
            END AS sls_sales,
    sls_quantity,
  CASE WHEN sls_price IS NULL OR sls_price<= 0
            THEN sls_sales/NULLIF(sls_quantity, 0)
            ELSE sls_price
            END AS sls_price
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
CLEANING SALES ERP CUSTOMER DATA_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
SELECT * 
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` 


--Checking white spaces in cid column
SELECT * 
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` 
WHERE CID != TRIM(CID)

--checking unique values is gender column
SELECT DISTINCT(GEN)
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` 

--cid and gender cleaning
SELECT 
      CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
           ELSE CID
           END cid,
      BDATE as bdate,
      CASE WHEN UPPER(TRIM(GEN)) = 'F' THEN 'Female'
           WHEN UPPER(TRIM(GEN)) = 'M' THEN 'Male'
           WHEN UPPER(TRIM(GEN)) = '' THEN 'n/a'
           WHEN UPPER(TRIM(GEN)) IS NULL THEN 'n/a'
           ELSE GEN
           END AS gen
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` 



--CTE to check changes in gender column
WITH erp_cust AS(
  SELECT 
      CID AS cid,
      BDATE as bdate,
      CASE WHEN UPPER(TRIM(GEN)) = 'F' THEN 'Female'
           WHEN UPPER(TRIM(GEN)) = 'M' THEN 'Male'
           WHEN UPPER(TRIM(GEN)) = '' THEN 'n/a'
           WHEN UPPER(TRIM(GEN)) IS NULL THEN 'n/a'
           ELSE GEN
           END AS gen
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12`

)
SELECT DISTINCT(gen)
FROM erp_cust


--Inserting data back to silver layer
INSERT INTO `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` (
  cid,
  bdate,
  gen
)
SELECT 
      CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LENGTH(CID))
           ELSE CID
           END cid,
      BDATE as bdate,
      CASE WHEN UPPER(TRIM(GEN)) = 'F' THEN 'Female'
           WHEN UPPER(TRIM(GEN)) = 'M' THEN 'Male'
           WHEN UPPER(TRIM(GEN)) = '' THEN 'n/a'
           WHEN UPPER(TRIM(GEN)) IS NULL THEN 'n/a'
           ELSE GEN
           END AS gen
FROM `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` 







