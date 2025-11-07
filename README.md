# PostgreSQL playground

A containerized PostgreSQL instance pre-loaded with a generated data for SQL training and query practice. Provides a instant, consistent environment for learning and testing.

## Tables

<img src="./database.png" alt="Database schema">

## Commands

Start database:

```sh
docker compose up -d
```

Connect to database:

```sh
docker exec -it postgres_playground psql -U postgres -d database
```

> Type `quit` to exit

Perform SQL query from host machine:

```sh
docker exec \
    -it postgres_playground psql \
    -U postgres \
    -d database \
    -c "SELECT * FROM users LIMIT 10;"
```

Stop database:

```sh
docker compose down
```

Stop database and delete all data:

```sh
docker compose down -v
```

## Examples

Select names of inactive users:

```sql
SELECT name FROM users WHERE is_active = False;
```

Select products with prices more than 90:

```sql
SELECT name, price FROM products WHERE price > 90;
```

Select 5 newest products:

```sql
SELECT * FROM products ORDER BY created_at DESC LIMIT 5;
```

Mark user inactive:

```sql
UPDATE users SET is_active = False WHERE id = 1;
```

Create new user:

```sql
INSERT INTO users (name, email, is_active, metadata)
VALUES ('John Doe', 'john@example.com', TRUE, '{"language": "en"}');
```

Create new product:

```sql
INSERT INTO products (name, sku, category_id, price, tags, description)
VALUES ('Example Product Name', 'SKU-EXAMPLE-001', 1,
    29.99, ARRAY['new', 'featured'], 'Good product.'
);
```

Delete user:

```sql
DELETE FROM users WHERE id = 1001;
```

Count products:

```sql
SELECT COUNT(*) FROM products;
```

Find one of the cheapest product:

```sql
SELECT * FROM products ORDER BY price ASC LIMIT 1;
```

Find the most expensive products:

```sql
SELECT * FROM products WHERE price = (SELECT MAX(price) FROM products);
```

Find products with prices between 40 and 60 (inclusive):

```sql
SELECT * FROM products WHERE price BETWEEN 40 AND 60;
```

Show products with discount tag:

```sql
SELECT * FROM products WHERE 'discount' = ANY(tags);
```

```sql
SELECT * FROM products WHERE tags @> ARRAY['discount'];
```

Show users with English language preference:

```sql
SELECT * FROM users WHERE metadata->>'language' = 'en';
```

Show users created in last 10 days:

```sql
SELECT * FROM users WHERE created_at > NOW() - INTERVAL '10 days';
```

Show reviews that contain word 'fast' in comment column:

```sql
SELECT * FROM reviews WHERE comment ILIKE '%fast%';
```

Count active and inactive users:

```sql
SELECT is_active, COUNT(*) FROM users GROUP BY is_active;
```

Show products with category names:

```sql
SELECT p.*,
       c.name AS category_name
FROM products p
JOIN categories c ON p.category_id = c.id;
```

Show order items with order status and product name:

```sql
SELECT oi.id,
       oi.quantity,
       oi.unit_price,
       p.name AS product_name,
       o.status AS order_status
FROM order_items oi
JOIN products p ON oi.product_id = p.id
JOIN orders o ON oi.order_id = o.id;
```

Find products with the same name:

```sql
SELECT name,
       COUNT(*) AS count,
       ARRAY_AGG(id) AS ids
FROM products
GROUP BY name
HAVING COUNT(*) > 1
ORDER BY count DESC, name;
```

Add gender info to user's metadata:

```sql
UPDATE users
SET metadata = COALESCE(metadata, '{}'::JSONB) || '{"gender": "male"}'::JSONB
WHERE id = 1;
```

Remove gender info from user's metadata:

```sql
UPDATE users
SET metadata = metadata - 'gender'
WHERE id = 1;
```
