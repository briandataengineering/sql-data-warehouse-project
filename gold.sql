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


<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  PRODUCT FINAL_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

SELECT 
      ROW_NUMBER() OVER(ORDER BY pc.prd_start_dt,pc.prd_key ) AS product_key,
      pc.prd_id AS product_id,
      pc.prd_key AS product_number,
      pc.cat_id AS category_id,
      pc.prd_nm AS product_name,
      pc.prd_cost AS cost,
      pc.prd_line AS product_line,
      pc.prd_start_dt AS start_date,
      pc.prd_end_dt AS end_date,
      pe.CAT AS category,
      pe.SUBCAT AS subcategory,
      CASE WHEN MAINTENANCE IS TRUE THEN 'Yes'
           ELSE 'No'
           END AS maintenance
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` pc
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_PX_CAT_G1V2` pe
ON pc.cat_id= pe.ID


CREATE VIEW gold.dim_product AS 
SELECT 
      ROW_NUMBER() OVER(ORDER BY pc.prd_start_dt,pc.prd_key ) AS product_key,
      pc.prd_id AS product_id,
      pc.prd_key AS product_number,
      pc.cat_id AS category_id,
      pc.prd_nm AS product_name,
      pc.prd_cost AS cost,
      pc.prd_line AS product_line,
      pc.prd_start_dt AS start_date,
      pc.prd_end_dt AS end_date,
      pe.CAT AS category,
      pe.SUBCAT AS subcategory,
      CASE WHEN MAINTENANCE IS TRUE THEN 'Yes'
           ELSE 'No'
           END AS maintenance
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_prd_info` pc
LEFT JOIN `project-7dde7e10-dbf5-4abe-b54.silver.erp_PX_CAT_G1V2` pe
ON pc.cat_id= pe.ID



<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  SALES FINAL_TABLE
<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CREATE VIEW gold.dim_sales AS
SELECT 
      sls_ord_num AS order_num,
      sls_prd_key AS product_key,
      sls_order_dt AS order_date,
      sls_ship_dt AS shipping_date,
      sls_due_dt AS due_date,
      sls_price AS price,
      sls_quantity AS quantity,
      sls_sales AS sales
FROM `project-7dde7e10-dbf5-4abe-b54.silver.crm_sales_details`



