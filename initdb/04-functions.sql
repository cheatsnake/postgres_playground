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
