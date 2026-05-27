-- =============================================
-- 03_staging.sql
-- Cleans raw data and engineers fraud features
-- =============================================

USE DATABASE fraud_project;
USE SCHEMA staging;

CREATE TABLE transactions_clean AS
SELECT
    step,
    type,
    amount,
    nameOrig,
    oldbalanceOrg,
    newbalanceOrig,
    nameDest,
    oldbalanceDest,
    newbalanceDest,
    isFraud,

    -- feature 1: did the origin account get zeroed out?
    -- 97.5% of fraud cases drop the sender balance to zero
    CASE 
        WHEN newbalanceOrig = 0 AND oldbalanceOrg > 0 THEN 1 
        ELSE 0 
    END AS orig_account_zeroed,

    -- feature 2: did the destination balance not increase despite receiving funds?
    -- common indicator of layering or pass-through accounts
    CASE 
        WHEN newbalanceDest = oldbalanceDest AND amount > 0 THEN 1 
        ELSE 0 
    END AS dest_balance_unchanged,

    -- feature 3: high-risk transaction type
    -- 100% of fraud in this dataset is TRANSFER or CASH_OUT
    CASE 
        WHEN type IN ('TRANSFER', 'CASH_OUT') THEN 1 
        ELSE 0 
    END AS high_risk_type

FROM fraud_project.raw.transactions;


-- validate: check how well features correlate with actual fraud
SELECT 
    isFraud,
    SUM(orig_account_zeroed)    as zeroed_accounts,
    SUM(dest_balance_unchanged) as unchanged_dest,
    SUM(high_risk_type)         as high_risk_transactions,
    COUNT(*)                    as total
FROM transactions_clean
GROUP BY isFraud;
