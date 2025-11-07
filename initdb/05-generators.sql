-- categories
INSERT INTO categories (name) VALUES
('Clothes'),
('Electronics'),
('Garden'),
('Food'),
('Home'),
('Sports'),
('Toys'),
('Automotive'),
('Health');

-- users
INSERT INTO users (name, email, created_at, metadata, is_active)
SELECT
  'User ' || i::text,
  format('user%s@example.com', lpad(i::text, 4, '0')),
  random_timestamp(),
  jsonb_build_object(
    'signup_source', random_array_element(array['web','mobile','api']),
    'language', random_array_element(array['en','zh','hi','es','ar'])
  ),
  (random() > 0.05)
FROM generate_series(1,1000) AS s(i);

-- products
INSERT INTO products (name, sku, category_id, price, tags, description, created_at)
SELECT
  random_product_name(),
  'SKU-' || lpad(i::text,4,'0'),
  (random_int(1,9))::smallint,
  random_float(),
  ARRAY[random_array_element(array['new','popular','discount','limited'])],
  random_product_description(),
  random_timestamp()
FROM generate_series(1,200) AS s(i);

-- orders
INSERT INTO orders (user_id, status, created_at, total_amount)
SELECT
  (random_int(1,1000))::bigint,
  random_array_element(array['pending','paid','shipped','cancelled']),
  random_timestamp(),
  0
FROM generate_series(1,5000) AS s(i);

-- order_items: variable items per order
INSERT INTO order_items (order_id, product_id, quantity, unit_price)
SELECT o.id,
       (random_int(1,200))::bigint,
       random_int(1,5),
       random_float(1,500)
FROM orders o
CROSS JOIN LATERAL generate_series(1, random_int(1,5)) AS gs(i)
WHERE o.id BETWEEN 1 AND 5000;

-- update orders.total_amount from sum of order_items
UPDATE orders o
SET total_amount = sub.sum_amount
FROM (
  SELECT order_id, sum(quantity * unit_price)::numeric(12,2) AS sum_amount
  FROM order_items
  GROUP BY order_id
) sub
WHERE o.id = sub.order_id;

-- payments: insert payments for many 'paid' orders
INSERT INTO payments (order_id, amount, paid_at, method, meta)
SELECT o.id, o.total_amount,
       o.created_at + (random_int(1, 7) || ' days')::INTERVAL,
       random_array_element(array['card','paypal','bank']),
       jsonb_build_object('txn', 'TX-'||o.id)
FROM orders o
WHERE o.status = 'paid' AND random() > 0.2;

-- reviews
INSERT INTO reviews (user_id, product_id, rating, comment, created_at)
SELECT
  random_int(1,1000)::bigint,
  random_int(1,200)::bigint,
  random_int(1,5)::smallint,
  random_review_comment(),
  random_timestamp()
FROM generate_series(1,3000) AS s(i);
