<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  CUSTOMER FINAL_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

--Joining customer tables and final cleaning
SELECT 
      ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
      ci.cst_id AS customer_id,
      ci.cst_key AS customer_number,
      ci.cst_firstname AS firstname,
      ci.cst_lastname AS lastname,
      ci.cst_marital_status AS marital_status,
      CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
           ELSE COALESCE(ce.GEN, 'n/a')
           END AS gender,
      ce.BDATE AS birth_date,
      cl.string_field_1 AS country
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` ci
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` ce
ON ci.cst_key = ce.CID
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_LOC_A101` cl
ON ci.cst_key = cl.string_field_0

---CREATING VIEWS 
CREATE VIEW gold.dim_customer AS
SELECT 
      ROW_NUMBER() OVER(ORDER BY cst_id) AS customer_key,
      ci.cst_id AS customer_id,
      ci.cst_key AS customer_number,
      ci.cst_firstname AS firstname,
      ci.cst_lastname AS lastname,
      ci.cst_marital_status AS marital_status,
      CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
           ELSE COALESCE(ce.GEN, 'n/a')
           END AS gender,
      ce.BDATE AS birth_date,
      cl.string_field_1 AS country
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_cust_info` ci
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_CUST_AZ12` ce
ON ci.cst_key = ce.CID
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_LOC_A101` cl
ON ci.cst_key = cl.string_field_0
