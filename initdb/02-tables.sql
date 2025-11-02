CREATE TABLE users (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name       TEXT NOT NULL,
  email      TEXT NOT NULL UNIQUE,
  is_active  BOOLEAN NOT NULL DEFAULT TRUE,
  metadata   JSONB DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE categories (
  id   SMALLINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE products (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name        TEXT NOT NULL,
  sku         TEXT UNIQUE,
  category_id SMALLINT  NOT NULL REFERENCES categories(id),
  price       NUMERIC(10,2) NOT NULL CHECK (price >= 0),
  tags        TEXT[] DEFAULT ARRAY[]::TEXT[],
  description TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE orders (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id      BIGINT NOT NULL REFERENCES users(id),
  status       TEXT NOT NULL CHECK (status IN ('pending','paid','shipped','cancelled','refunded')),
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  total_amount NUMERIC(12,2) NOT NULL DEFAULT 0
);

CREATE TABLE order_items (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id   BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id BIGINT NOT NULL REFERENCES products(id),
  quantity   INT NOT NULL CHECK (quantity > 0),
  unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0)
);

CREATE TABLE payments (
  id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  order_id     BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  amount       NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
  paid_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  method       TEXT NOT NULL,
  meta         JSONB DEFAULT '{}'::jsonb
);

CREATE TABLE reviews (
  id         BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  user_id    BIGINT NOT NULL REFERENCES users(id),
  product_id BIGINT NOT NULL REFERENCES products(id),
  rating     SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment    TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
