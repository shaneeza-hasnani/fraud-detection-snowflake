-- =============================================
-- 02_load.sql
-- Creates the raw transactions table
-- Data loaded via Snowsight UI uploader
-- =============================================

USE DATABASE fraud_project;
USE SCHEMA raw;

CREATE TABLE transactions (
    step            INT,
    type            VARCHAR(20),
    amount          FLOAT,
    nameOrig        VARCHAR(50),
    oldbalanceOrg   FLOAT,
    newbalanceOrig  FLOAT,
    nameDest        VARCHAR(50),
    oldbalanceDest  FLOAT,
    newbalanceDest  FLOAT,
    isFraud         INT,
    isFlaggedFraud  INT
);

-- verify load
SELECT COUNT(*) FROM transactions;
-- expected: ~6,362,620 rows

-- fraud vs legit split
SELECT 
    isFraud,
    COUNT(*) as transaction_count,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) as pct_of_total
FROM transactions
GROUP BY isFraud;
-- fraud rate: 0.13% (highly imbalanced, mirrors real-world financial crime data)
