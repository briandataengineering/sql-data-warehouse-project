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
