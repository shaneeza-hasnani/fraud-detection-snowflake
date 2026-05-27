-- =============================================
-- 04_mart.sql
-- Builds fraud scores and risk tiers
-- =============================================

USE DATABASE fraud_project;
USE SCHEMA mart;

CREATE TABLE fraud_scores AS
SELECT
    nameOrig,
    nameDest,
    type,
    amount,
    isFraud,
    orig_account_zeroed,
    dest_balance_unchanged,
    high_risk_type,

    -- simple rule-based fraud score (0-3)
    (orig_account_zeroed + dest_balance_unchanged + high_risk_type) AS fraud_score,

    -- risk tier based on score
    CASE 
        WHEN (orig_account_zeroed + dest_balance_unchanged + high_risk_type) = 3 THEN 'HIGH'
        WHEN (orig_account_zeroed + dest_balance_unchanged + high_risk_type) = 2 THEN 'MEDIUM'
        WHEN (orig_account_zeroed + dest_balance_unchanged + high_risk_type) = 1 THEN 'LOW'
        ELSE 'MINIMAL'
    END AS risk_tier

FROM staging.transactions_clean;


-- final results: fraud rate by risk tier
SELECT 
    risk_tier,
    COUNT(*)                                            as total_transactions,
    SUM(isFraud)                                        as actual_fraud,
    ROUND(SUM(isFraud) * 100.0 / COUNT(*), 2)          as fraud_rate_pct
FROM fraud_scores
GROUP BY risk_tier
ORDER BY fraud_rate_pct DESC;
