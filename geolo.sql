CREATE TABLE public.olist_geolocation_dataset (
    geolocation_zip_code_prefix integer,
    geolocation_lat double precision,
    geolocation_lng double precision,
    geolocation_city text,
    geolocation_state text,
);
CREATE TABLE public.olist_customers_dataset (
    customer_id VARCHAR(255),
    customer_unique_id VARCHAR(255) NOT NULL,
    customer_zip_code_prefix integer,
    customer_city text,
    customer_state text,
    PRIMARY KEY(customer_id, customer_unique_id),
    CONSTRAINT fk_customer_zip FOREIGN KEY (customer_zip_code_prefix) REFERENCES public.olist_geolocation_dataset(geolocation_zip_code_prefix)
);
CREATE TABLE public.olist_sellers_dataset (
    seller_id VARCHAR(255) PRIMARY KEY,
    seller_zip_code_prefix integer,
    seller_city text,
    seller_state text,
    CONSTRAINT fk_seller_zip FOREIGN KEY (seller_zip_code_prefix) REFERENCES public.olist_geolocation_dataset(geolocation_zip_code_prefix)
);
CREATE TABLE public.olist_orders_dataset (
    order_id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255) NOT NULL,
    order_status text,
    order_purchase_timestamp timestamp without time zone,
    order_approved_at timestamp without time zone,
    order_delivered_carrier_date timestamp without time zone,
    order_delivered_customer_date timestamp without time zone,
    order_estimated_delivery_date timestamp without time zone,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES public.olist_customers_dataset(customer_id)
);
CREATE TABLE public.olist_products_dataset (
    product_id VARCHAR(255) PRIMARY KEY,
    product_category_name text,
    product_name_lenght integer,
    product_description_lenght integer,
    product_photos_qty integer,
    product_weight_g integer,
    product_length_cm integer,
    product_height_cm integer,
    product_width_cm integer
);
CREATE TABLE public.olist_order_items_dataset (
    order_id VARCHAR(255),
    order_item_id integer,
    product_id VARCHAR(255),
    seller_id VARCHAR(255),
    shipping_limit_date timestamp without time zone,
    price double precision,
    freight_value double precision,
    PRIMARY KEY (order_id, order_item_id),
    CONSTRAINT fk_order_id_items FOREIGN KEY (order_id) REFERENCES public.olist_orders_dataset(order_id),
    CONSTRAINT fk_seller_id FOREIGN KEY (seller_id) REFERENCES public.olist_sellers_dataset(seller_id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES public.olist_products_dataset(product_id)
);
CREATE TABLE public.olist_order_payments_dataset (
    order_id VARCHAR(255) PRIMARY KEY,
    payment_sequential integer,
    payment_type text,
    payment_installments integer,
    payment_value double precision,
    CONSTRAINT fk_order_id_payments FOREIGN KEY (order_id) REFERENCES public.olist_orders_dataset(order_id)
);
CREATE TABLE public.olist_order_reviews_dataset (
    review_id VARCHAR(255),
    order_id VARCHAR(255),
    review_score integer,
    review_comment_title text,
    review_comment_message text,
    review_creation_date date,
    review_answer_timestamp timestamp without time zone,
    PRIMARY KEY(review_id,order_id),
    CONSTRAINT fk_order_id_reviews FOREIGN KEY (order_id) REFERENCES public.olist_orders_dataset(order_id)
);

CREATE TABLE public.product_category_name_translation (
    product_category_name text,
    product_category_name_english text
);