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

