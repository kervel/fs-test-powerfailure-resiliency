-- initdb.sql
CREATE DATABASE mydatabase;
CREATE USER myuser WITH ENCRYPTED PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
\c mydatabase;
set role myuser;

-- Create a table
CREATE TABLE test (
    id SERIAL PRIMARY KEY,
    num INTEGER,
    data VARCHAR
);
