use my_database;

CREATE OR REPLACE STAGE my_s3_stage
URL = 's3://dockerfilenew/'
CREDENTIALS = (
    AWS_KEY_ID = '',
    AWS_SECRET_KEY = ''
)
FILE_FORMAT = (TYPE = JSON);


list@my_s3_Stage;

CREATE OR REPLACE TABLE kafka_data (
    raw VARIANT
);



CREATE OR REPLACE PIPE kafka_pipe
AUTO_INGEST = TRUE
AS
COPY INTO kafka_data(raw)
FROM @my_s3_stage
FILE_FORMAT = (TYPE = JSON);





show pipes like 'kafka_pipe';

select * from kafka_data;


create or replace stream kafka_stream
on table kafka_data;

select * from kafka_stream;


CREATE OR REPLACE TABLE silver_table (
    this_is NUMBER
);


insert into silver_table(this_is)
select raw : "Raw":: number
from kafka_stream
where metadata$action = 'insert';


select * from silver_table;












































SELECT 
    raw:"This is"::int AS value
FROM kafka_data;



CREATE OR REPLACE TABLE kafka_clean (
    value INT
);

INSERT INTO kafka_clean
SELECT raw:"This is"::int
FROM kafka_data;


SELECT * FROM kafka_clean;


USE DATABASE my_database;
USE SCHEMA public;

CREATE OR REPLACE STAGE weather_stage;
SHOW STAGES;

LIST @weather_stage;


SELECT COUNT(*) FROM weather_raw;





