# Fraud Detection Pipeline in Snowflake

End-to-end SQL pipeline built on 6.3 million synthetic financial transactions. Raw data goes in, fraud risk scores come out.

## What it does

Takes PaySim transaction data and runs it through three layers:

- **Raw** — source data loaded as-is
- **Staging** — cleaned and feature engineered
- **Mart** — scored and tiered by fraud risk

The final output is a risk tier (HIGH / MEDIUM / LOW / MINIMAL) for every transaction, based on three behavioral features.

## Results

| Risk Tier | Transactions | Actual Fraud | Fraud Rate |
|-----------|-------------|--------------|------------|
| HIGH      | 5,145       | 3,912        | 76.03%     |
| MEDIUM    | 1,510,439   | 4,258        | 0.28%      |
| LOW       | 3,571,953   | 43           | 0.00%      |
| MINIMAL   | 1,275,083   | 0            | 0.00%      |

76% of transactions flagged HIGH risk turned out to be actual fraud. The dataset is highly imbalanced at 0.13% fraud rate, which mirrors real-world financial crime data.

## Features engineered

**orig_account_zeroed** — flags transactions where the origin account balance dropped to zero. 97.5% of fraud cases in this dataset zeroed out the sender account.

**dest_balance_unchanged** — flags transactions where the destination balance did not increase despite receiving funds, a common indicator of layering.

**high_risk_type** — flags TRANSFER and CASH_OUT transaction types, which account for 100% of fraud in this dataset.

## Files

| File | What it does |
|------|-------------|
| `01_setup.sql` | Creates database and schemas |
| `02_load.sql` | Table definition for raw data |
| `03_staging.sql` | Cleans data and engineers features |
| `04_mart.sql` | Builds fraud scores and risk tiers |

## Dataset

[PaySim Synthetic Financial Dataset](https://www.kaggle.com/datasets/ealaxi/paysim1) — 6.3M simulated mobile money transactions with ground truth fraud labels.

## Tech

Snowflake (SQL), Snowsight, COPY INTO for data loading
