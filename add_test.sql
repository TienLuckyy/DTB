CREATE OR REPLACE FUNCTION add_customer_and_order(
    in_customer_id VARCHAR,
    in_customer_unique_id VARCHAR,
    in_zip_code_prefix INTEGER,
    in_city TEXT,
    in_state TEXT,
    in_order_id VARCHAR,
    in_order_status TEXT,
    in_purchase_timestamp TIMESTAMP
)
RETURNS VOID AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM olist_customers_dataset WHERE customer_id = in_customer_id
    ) THEN
        INSERT INTO olist_customers_dataset(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state)
        VALUES (in_customer_id, in_customer_unique_id, in_zip_code_prefix, in_city, in_state);
    END IF;

    IF EXISTS (
        SELECT 1 FROM olist_customers_dataset WHERE customer_id = in_customer_id
    ) THEN
        INSERT INTO olist_orders_dataset(order_id, customer_id, order_status, order_purchase_timestamp)
        VALUES (in_order_id, in_customer_id, in_order_status, in_purchase_timestamp);
    ELSE
        RAISE EXCEPTION 'Customer ID % not in customers', in_customer_id;
    END IF;
END;
$$ LANGUAGE plpgsql;
SELECT add_customer_and_order(
    'abc123', 'uid123', 12345, 'Sao Paulo', 'SP',
    'order001', 'delivered', '2023-06-15 10:00:00'
);