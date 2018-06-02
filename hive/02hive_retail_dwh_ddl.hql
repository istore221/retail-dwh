-- Create dwh database for retail_db@mysql
CREATE DATABASE IF NOT EXISTS retail_dwh;

-- Switch to retail_dwh database
USE retail_dwh;

-- hive.execution.engine=tez
-- hive.exec.dynamic.partition.mode=nonstrict
-- hive.exec.dynamic.partition=true
-- hive.enforce.bucketing=true

--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/dim_departments
--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_dwh/dim_departments/retail_dwh_dim_departments.avsc warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_departments.avsc

-- ALTER TABLE dim_departments ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE dim_departments;

/*
set hive.enforce.bucketing = true;
set hive.enforce.sorting=true;

INSERT INTO TABLE retail_dwh.dim_departments
SELECT stg_dep.department_id,stg_dep.department_name FROM retail_stage.departments stg_dep
WHERE stg_dep.imported_date='2017-05-07';

*/

CREATE EXTERNAL TABLE IF NOT EXISTS dim_departments
--CLUSTERED BY (department_id) SORTED BY (department_id) INTO 256 BUCKETS
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_dwh/dim_departments'
TBLPROPERTIES ('avro.schema.url'='hdfs://sandbox-hdp.hortonworks.com:8020/user/${user.name}/warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_departments.avsc');


-- create 'customers', 'personal_info'
-- alter 'customers', NAME=>'personal_info', VERSIONS=>3
-- scan "customers"
-- get 'customers', '100', {COLUMN => 'personal_info:customer_city', VERSIONS => 3}
-- scan "customers",{VERSIONS => 3}
-- put 'customers',100,'personal_info:customer_city','kandy'


CREATE EXTERNAL TABLE dim_customers
(
 customer_id INT,
 customer_fname VARCHAR(45),
 customer_lname VARCHAR(45),
 customer_email VARCHAR(45),
 customer_street VARCHAR(255),
 customer_city VARCHAR(45),
 customer_state VARCHAR(45),
 customer_zipcode VARCHAR(45)

)
STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
WITH SERDEPROPERTIES ("hbase.columns.mapping"=":key,personal_info:customer_fname,personal_info:customer_lname,personal_info:customer_email,personal_info:customer_street,personal_info:customer_city,personal_info:customer_state,personal_info:customer_zipcode")
TBLPROPERTIES ("hbase.table.name"="customers");


--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/dim_products
--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_dwh/dim_products/retail_dwh_dim_products.avsc warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_products.avsc

-- ALTER TABLE dim_products ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE dim_products;

/*

set hive.exec.dynamic.partition.mode=true;
set hive.exec.dynamic.partition=nonstrict;

INSERT INTO TABLE retail_dwh.dim_products PARTITION(product_category_id)
SELECT stg_prod.product_id,stg_prod.product_name,stg_prod.product_price,stg_prod.product_category_id
FROM retail_stage.products stg_prod
WHERE stg_prod.imported_date='2015-05-05';

*/

CREATE EXTERNAL TABLE IF NOT EXISTS dim_products
--PARTITIONED BY (product_category_id INT)
--CLUSTERED BY (product_id) SORTED BY (product_id) INTO 256 BUCKETS
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_dwh/dim_products'
TBLPROPERTIES ('avro.schema.url'='hdfs://sandbox-hdp.hortonworks.com:8020/user/${user.name}/warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_products.avsc');



--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/dim_categories
--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_dwh/dim_categories/retail_dwh_dim_categories.avsc warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_categories.avsc

-- ALTER TABLE dim_categories ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE dim_categories;


/*

set hive.exec.dynamic.partition.mode=true;
set hive.exec.dynamic.partition=nonstrict;

INSERT INTO TABLE retail_dwh.dim_categories  PARTITION(category_department_id)
SELECT stg_cat.category_id,stg_cat.category_name,stg_cat.category_department_id
FROM retail_stage.categories stg_cat
WHERE stg_cat.imported_date='2017-05-07';


*/

CREATE EXTERNAL TABLE IF NOT EXISTS dim_categories
--PARTITIONED BY (category_department_id INT)
--CLUSTERED BY (category_id) SORTED BY (category_id) INTO 256 BUCKETS
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_dwh/dim_categories'
TBLPROPERTIES ('avro.schema.url'='hdfs://sandbox-hdp.hortonworks.com:8020/user/${user.name}/warehouse/retail_edw/retail_dwh/avro/retail_dwh_dim_categories.avsc');



--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/fact_sales
--hadoop fs -mkdir -p warehouse/retail_edw/retail_dwh/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_dwh/fact_sales/retail_dwh_fact_sales.avsc warehouse/retail_edw/retail_dwh/avro/retail_dwh_fact_sales.avsc

-- ALTER TABLE fact_sales ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE fact_sales;

-- quearies will be mainly fired to analyse  department level prefomance over time


CREATE EXTERNAL TABLE IF NOT EXISTS fact_sales(
  order_id INT,
  customer_id INT,
  product_id INT,
  product_price DECIMAL,
  qty INT,
  subtotal DECIMAL,
  category_id INT,
  category_name VARCHAR(45),
  department_name VARCHAR(45)
)
PARTITIONED BY (year STRING,month STRING,day STRING,department_id INT)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS PARQUET
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_dwh/fact_sales'
TBLPROPERTIES ("parquet.compression"="SNAPPY");
