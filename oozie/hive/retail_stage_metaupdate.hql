ALTER TABLE departments
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");

ALTER TABLE categories
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");

ALTER TABLE customers
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");

ALTER TABLE order_items
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");

ALTER TABLE orders
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");

ALTER TABLE products
ADD IF NOT EXISTS PARTITION ( imported_date="${imported_date}");
