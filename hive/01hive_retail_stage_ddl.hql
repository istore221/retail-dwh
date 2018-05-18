-- Create staging database for retail_db@mysql
CREATE DATABASE IF NOT EXISTS retail_stage;

-- Switch to retail_stage database
USE retail_stage;

-- hive.execution.engine=tez
-- hive.exec.dynamic.partition.mode=nonstrict
-- hive.exec.dynamic.partition=true

--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/departments
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_departments.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_departments.avsc

-- ALTER TABLE departments ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE departments;

CREATE EXTERNAL TABLE IF NOT EXISTS departments
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/departments'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_departments.avsc');

--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/categories
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_categories.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_categories.avsc

-- ALTER TABLE categories ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE categories;


CREATE EXTERNAL TABLE IF NOT EXISTS categories
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/categories'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_categories.avsc');


--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/products
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_products.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_products.avsc

-- ALTER TABLE products ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE products;


CREATE EXTERNAL TABLE IF NOT EXISTS products
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/products'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_products.avsc');



--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/customers
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_customers.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_customers.avsc

-- ALTER TABLE customers ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE customers;

CREATE EXTERNAL TABLE IF NOT EXISTS customers
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/customers'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_customers.avsc');



--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/orders
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_orders.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_orders.avsc

-- ALTER TABLE orders ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE orders;

CREATE EXTERNAL TABLE IF NOT EXISTS orders
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/orders'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_orders.avsc');




--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/order_items
--hadoop fs -mkdir -p warehouse/retail_edw/retail_stage/avro
--hadoop fs -copyFromLocal ~/retail_dwh/avro/retail_stage_order_items.avsc warehouse/retail_edw/retail_stage/avro/retail_stage_order_items.avsc

-- ALTER TABLE order_items ADD PARTITION (imported_date='yyyy-mm-dd') OR  MSCK REPAIR TABLE order_items;

CREATE EXTERNAL TABLE IF NOT EXISTS order_items
PARTITIONED BY (imported_date STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.avro.AvroSerDe'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.avro.AvroContainerOutputFormat'
LOCATION '/user/${user.name}/warehouse/retail_edw/retail_stage/order_items'
TBLPROPERTIES ('avro.schema.url'='/user/${user.name}/warehouse/retail_edw/retail_stage/avro/retail_stage_order_items.avsc');
