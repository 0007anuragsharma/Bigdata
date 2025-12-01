CREATE DATABASE PROJECTSAKILA;



USE PROJECTSAKILA;

CREATE OR REPLACE STAGE sakila_stage
URL='s3://projectsakiladatabase01/sakila/'
CREDENTIALS=(
  AWS_KEY_ID=''
  AWS_SECRET_KEY=''
)
FILE_FORMAT = (TYPE='PARQUET');

LIST @SAKILA_STAGE;


CREATE OR REPLACE TABLE actor (
  actor_id INT,
  first_name STRING,
  last_name STRING,
  last_update TIMESTAMP
);
-- snowpipe for Actor_table

CREATE OR REPLACE PIPE actor_pipe
AUTO_INGEST = TRUE
AS
COPY INTO actor
(
  actor_id,
  first_name,
  last_name,
  last_update
)
FROM (
  SELECT
    $1:actor_id::INT,
    $1:first_name::STRING,
    $1:last_name::STRING,
    $1:last_update::TIMESTAMP
  FROM @sakila_stage/actor/
)
FILE_FORMAT = (TYPE='PARQUET')
ON_ERROR = 'CONTINUE';

SHOW PIPES LIKE 'ACTOR_PIPE';

SELECT * FROM actor ORDER BY last_update DESC;

--ALTER PIPE actor_pipe SET PIPE_EXECUTION_PAUSED = TRUE;
--ALTER PIPE actor_pipe SET PIPE_EXECUTION_PAUSED = FALSE;




SHOW PIPES LIKE 'ACTOR_PIPE';

-------------------------------------------------------
-- 3. FILM
-------------------------------------------------------
CREATE OR REPLACE TABLE film (
  film_id INT,
  title STRING,
  description STRING,
  release_year INT,
  language_id INT,
  rental_duration INT,
  rental_rate FLOAT,
  length INT,
  replacement_cost FLOAT,
  rating STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE film_pipe
AUTO_INGEST = TRUE
AS
COPY INTO film
FROM @sakila_stage/film/
FILE_FORMAT = (TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 4. CUSTOMER
-------------------------------------------------------
CREATE OR REPLACE TABLE customer (
  customer_id INT,
  store_id INT,
  first_name STRING,
  last_name STRING,
  email STRING,
  address_id INT,
  active INT,
  create_date TIMESTAMP,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE customer_pipe
AUTO_INGEST = TRUE
AS
COPY INTO customer
FROM @sakila_stage/customer/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 5. RENTAL
-------------------------------------------------------
CREATE OR REPLACE TABLE rental (
  rental_id INT,
  rental_date TIMESTAMP,
  inventory_id INT,
  customer_id INT,
  return_date TIMESTAMP,
  staff_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE rental_pipe
AUTO_INGEST = TRUE
AS
COPY INTO rental
FROM @sakila_stage/rental/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 6. PAYMENT
-------------------------------------------------------
CREATE OR REPLACE TABLE payment (
  payment_id INT,
  customer_id INT,
  staff_id INT,
  rental_id INT,
  amount FLOAT,
  payment_date TIMESTAMP,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE payment_pipe
AUTO_INGEST=TRUE
AS
COPY INTO payment
FROM @sakila_stage/payment/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 7. STAFF
-------------------------------------------------------
CREATE OR REPLACE TABLE staff (
  staff_id INT,
  first_name STRING,
  last_name STRING,
  address_id INT,
  picture STRING,
  email STRING,
  store_id INT,
  active INT,
  username STRING,
  password STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE staff_pipe
AUTO_INGEST=TRUE
AS
COPY INTO staff
FROM @sakila_stage/staff/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 8. STORE
-------------------------------------------------------
CREATE OR REPLACE TABLE store (
  store_id INT,
  manager_staff_id INT,
  address_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE store_pipe
AUTO_INGEST = TRUE
AS
COPY INTO store
FROM @sakila_stage/store/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 9. ADDRESS
-------------------------------------------------------
CREATE OR REPLACE TABLE address (
  address_id INT,
  address STRING,
  address2 STRING,
  district STRING,
  city_id INT,
  postal_code STRING,
  phone STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE address_pipe
AUTO_INGEST = TRUE
AS
COPY INTO address
FROM @sakila_stage/address/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 10. CITY
-------------------------------------------------------
CREATE OR REPLACE TABLE city (
  city_id INT,
  city STRING,
  country_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE city_pipe
AUTO_INGEST = TRUE
AS
COPY INTO city
FROM @sakila_stage/city/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 11. COUNTRY   (FIXED ❗)
-------------------------------------------------------
CREATE OR REPLACE TABLE country (
  country_id INT,
  country STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE country_pipe
AUTO_INGEST = TRUE
AS
COPY INTO country
FROM @sakila_stage/country/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 12. CATEGORY (FIXED ❗)
-------------------------------------------------------
CREATE OR REPLACE TABLE category (
  category_id INT,
  name STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE category_pipe
AUTO_INGEST = TRUE
AS
COPY INTO category
FROM @sakila_stage/category/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 13. FILM_CATEGORY
-------------------------------------------------------
CREATE OR REPLACE TABLE film_category (
  film_id INT,
  category_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE film_category_pipe
AUTO_INGEST = TRUE
AS
COPY INTO film_category
FROM @sakila_stage/film_category/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 14. FILM_ACTOR
-------------------------------------------------------
CREATE OR REPLACE TABLE film_actor (
  actor_id INT,
  film_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE film_actor_pipe
AUTO_INGEST = TRUE
AS
COPY INTO film_actor
FROM @sakila_stage/film_actor/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 15. INVENTORY
-------------------------------------------------------
CREATE OR REPLACE TABLE inventory (
  inventory_id INT,
  film_id INT,
  store_id INT,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE inventory_pipe
AUTO_INGEST = TRUE
AS
COPY INTO inventory
FROM @sakila_stage/inventory/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;


-------------------------------------------------------
-- 16. LANGUAGE
-------------------------------------------------------
CREATE OR REPLACE TABLE language (
  language_id INT,
  name STRING,
  last_update TIMESTAMP
);

CREATE OR REPLACE PIPE language_pipe
AUTO_INGEST = TRUE
AS
COPY INTO language
FROM @sakila_stage/language/
FILE_FORMAT=(TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;




----------------------------------------------------

-- 16 film_text

----------------------------------------------------


CREATE OR REPLACE TABLE film_text (
  film_id INT,
  title STRING,
  description STRING
);


CREATE OR REPLACE PIPE film_text_pipe
AUTO_INGEST = TRUE
AS
COPY INTO film_text
FROM @sakila_stage/film_text/
FILE_FORMAT = (TYPE='PARQUET')
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE;
































SELECT * FROM actor;
SELECT * FROM address;
SELECT * FROM category;
SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM customer;
SELECT * FROM film;
SELECT * FROM film_actor;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM language;
SELECT * FROM payment;
SELECT * FROM rental;
SELECT * FROM staff;
SELECT * FROM store;
SELECT * FROM film_text;


SHOW PIPES;






















