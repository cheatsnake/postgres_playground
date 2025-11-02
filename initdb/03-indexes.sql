CREATE INDEX products_tags_idx ON products USING GIN (tags);

CREATE INDEX orders_user_idx ON orders(user_id);
CREATE INDEX orders_status_created_idx ON orders(status, created_at);

CREATE INDEX order_items_order_idx ON order_items(order_id);

CREATE INDEX payments_order_idx ON payments(order_id);

CREATE INDEX reviews_product_idx ON reviews(product_id);
