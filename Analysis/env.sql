CREATE DATABASE dev;

CREATE SCHEMA dev.raw_data;
CREATE SCHEMA dev.analytics;
CREATE SCHEMA dev.adhoc;

CREATE ROLE analytics_users;

CREATE USER logicat01 PASSWORD='Logicat01';
CREATE USER logicat02 PASSWORD='logicat02';
CREATE USER logicat03 PASSWORD='logicat03';
CREATE USER logicat04 PASSWORD='logicat04';

GRANT ROLE  analytics_users TO USER logicat01;
GRANT ROLE  analytics_users TO USER logicat02;
GRANT ROLE  analytics_users TO USER logicat03;
GRANT ROLE  analytics_users TO USER logicat04;

set up analytics_users
GRANT USAGE ON DATABASE DEV TO ROLE ANALYTICS_USERS;
GRANT USAGE on schema dev.raw_data to ROLE analytics_users;
GRANT SELECT on all tables in schema dev.raw_data to ROLE analytics_users;
GRANT ALL on schema dev.analytics to ROLE analytics_users;
GRANT ALL on all tables in schema dev.analytics to ROLE analytics_users;
GRANT ALL on schema dev.adhoc to ROLE analytics_users;
GRANT ALL on all tables in schema dev.adhoc to ROLE analytics_users;

GRANT SELECT ON ALL TABLES IN SCHEMA dev.raw_data TO ROLE ANALYTICS_USERS;
GRANT SELECT ON FUTURE TABLES IN SCHEMA dev.raw_data TO ROLE ANALYTICS_USERS;