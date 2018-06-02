-- pig -param imported_date=2013-05-05 -x mapreduce -useHCatalog  edw_load_fact_sales.pig

staging_orders = LOAD 'retail_stage.orders' using org.apache.hive.hcatalog.pig.HCatLoader();

staging_order_items = LOAD 'retail_stage.order_items' using org.apache.hive.hcatalog.pig.HCatLoader();

joined_orders = JOIN staging_order_items BY order_item_order_id, staging_orders BY order_id;

col_map = FOREACH joined_orders generate order_item_order_id,staging_orders::order_customer_id,order_item_product_id,order_item_product_price,order_item_subtotal;
