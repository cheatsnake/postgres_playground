-- random integer generator
CREATE OR REPLACE FUNCTION random_int(
    min_val INT DEFAULT 0,
    max_val INT DEFAULT 100
)
RETURNS INT AS $$
    SELECT floor(random() * (max_val - min_val + 1)) + min_val;
$$ LANGUAGE SQL VOLATILE;

-- random element from provided array
CREATE OR REPLACE FUNCTION random_array_element(anyarray)
RETURNS anyelement AS $$
    SELECT $1[random_int(1, array_length($1, 1))];
$$ LANGUAGE SQL VOLATILE;

-- random float generator
CREATE OR REPLACE FUNCTION random_float(
    min_val NUMERIC DEFAULT 0,
    max_val NUMERIC DEFAULT 100,
    decimals INT DEFAULT 1
)
RETURNS NUMERIC AS $$
    SELECT ROUND(
        (min_val + (max_val - min_val) * random())::NUMERIC,
        decimals
    );
$$ LANGUAGE SQL VOLATILE;

-- random timestamp generator
CREATE OR REPLACE FUNCTION random_timestamp(
    min_days INTEGER DEFAULT 0,
    max_days INTEGER DEFAULT 365
)
RETURNS TIMESTAMPTZ AS $$
    SELECT now() - (random_int(min_days, max_days) || ' days')::INTERVAL
    - (random_int(1,24) || ' hours')::INTERVAL
    - (random_int(1,60) || ' minutes')::INTERVAL
    - (random_int(1,60) || ' seconds')::INTERVAL;
$$ LANGUAGE SQL VOLATILE;

-- random product name
CREATE OR REPLACE FUNCTION random_product_name()
RETURNS TEXT AS $$
    SELECT
        CASE WHEN random() < 0.7 THEN  -- 70% chance to have adjective
            random_array_element(ARRAY['Basic', 'Standard', 'Premium', 'Deluxe', 'Pro', 'Elite', 'Essential', 'Advanced', 'Super', 'Ultra']) || ' '
        ELSE '' END ||
        random_array_element(ARRAY['Widget', 'Gadget', 'Tool', 'Device', 'System', 'Kit', 'Set', 'Package', 'Product', 'Item']) ||
        CASE WHEN random() < 0.3 THEN  -- 30% chance to have suffix
            ' ' || random_array_element(ARRAY['Plus', 'Max', 'Lite', 'X', '2024', 'Edition', 'Bundle'])
        ELSE '' END;
$$ LANGUAGE SQL VOLATILE;

-- random product description
CREATE OR REPLACE FUNCTION random_product_description()
RETURNS TEXT AS $$
    SELECT
        random_array_element(ARRAY['High-quality', 'Reliable', 'Innovative', 'Premium', 'Durable', 'Efficient']) || ' ' ||
        random_array_element(ARRAY['product', 'item', 'device', 'tool', 'solution']) || ' ' ||
        random_array_element(ARRAY['designed for', 'perfect for', 'ideal for', 'suitable for', 'made for']) || ' ' ||
        random_array_element(ARRAY['everyday use', 'professional use', 'home use', 'all your needs', 'optimal performance']) || '.';
$$ LANGUAGE SQL VOLATILE;

-- random review comment generator
CREATE OR REPLACE FUNCTION random_review_comment()
RETURNS TEXT AS $$
    SELECT
        random_array_element(
            ARRAY[
                'Great product!',
                'Excellent quality.',
                'Highly recommended.',
                'Not satisfied.',
                'Disappointed.'
            ]
        ) ||
        CASE WHEN random() < 0.3 THEN  -- 30% chance to add suffix
            random_array_element(ARRAY['', ' Would buy again.', ' Fast shipping.', ' Good value.', ' Great service.'])
        ELSE ''
        END;
$$ LANGUAGE SQL VOLATILE;
