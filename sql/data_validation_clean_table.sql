SELECT *
FROM stg_credit_card_clients
LIMIT 10;

-- Check for Null Values
SELECT
    COUNT(*) AS total_rows,

    COUNT(*) - COUNT(id) AS id_nulls,
    COUNT(*) - COUNT(limit_bal) AS limit_bal_nulls,
    COUNT(*) - COUNT(sex) AS sex_nulls,
    COUNT(*) - COUNT(education) AS education_nulls,
    COUNT(*) - COUNT(marriage) AS marriage_nulls,
    COUNT(*) - COUNT(age) AS age_nulls,

    COUNT(*) - COUNT(pay_0) AS pay_0_nulls,
    COUNT(*) - COUNT(pay_2) AS pay_2_nulls,
    COUNT(*) - COUNT(pay_3) AS pay_3_nulls,
    COUNT(*) - COUNT(pay_4) AS pay_4_nulls,
    COUNT(*) - COUNT(pay_5) AS pay_5_nulls,
    COUNT(*) - COUNT(pay_6) AS pay_6_nulls,

    COUNT(*) - COUNT(bill_amt1) AS bill_amt1_nulls,
    COUNT(*) - COUNT(bill_amt2) AS bill_amt2_nulls,
    COUNT(*) - COUNT(bill_amt3) AS bill_amt3_nulls,
    COUNT(*) - COUNT(bill_amt4) AS bill_amt4_nulls,
    COUNT(*) - COUNT(bill_amt5) AS bill_amt5_nulls,
    COUNT(*) - COUNT(bill_amt6) AS bill_amt6_nulls,

    COUNT(*) - COUNT(pay_amt1) AS pay_amt1_nulls,
    COUNT(*) - COUNT(pay_amt2) AS pay_amt2_nulls,
    COUNT(*) - COUNT(pay_amt3) AS pay_amt3_nulls,
    COUNT(*) - COUNT(pay_amt4) AS pay_amt4_nulls,
    COUNT(*) - COUNT(pay_amt5) AS pay_amt5_nulls,
    COUNT(*) - COUNT(pay_amt6) AS pay_amt6_nulls,

    COUNT(*) - COUNT(default_payment_next_month) AS target_nulls

FROM stg_credit_card_clients;

-- Check Duplicate IDs

SELECT
    id,
    COUNT(*) AS occurrences
FROM stg_credit_card_clients
GROUP BY id
HAVING COUNT(*) > 1;

-- Verify Primary Key

SELECT COUNT(DISTINCT id) AS unique_customers
FROM stg_credit_card_clients;

-- Verify Target Variable

SELECT
    default_payment_next_month,
    COUNT(*) AS customers
FROM stg_credit_card_clients
GROUP BY default_payment_next_month
ORDER BY default_payment_next_month;


/*==========================================================
DATA PROFILING
Purpose: Understand the distribution and validity of
categorical and numerical variables before data cleaning.
==========================================================*/

------------------------------------------------------------
-- 1. EDUCATION
-- Check the frequency of each education category.
-- This helps identify invalid or unexpected category codes
-- (e.g., 0, 5, 6) before standardization.
------------------------------------------------------------

SELECT
    education,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY education
ORDER BY education;


------------------------------------------------------------
-- 2. MARRIAGE
-- Check the distribution of marital status categories.
-- Identify invalid values (e.g., 0) that may require
-- recoding during data preparation.
------------------------------------------------------------

SELECT
    marriage,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY marriage
ORDER BY marriage;


------------------------------------------------------------
-- 3. SEX
-- Verify that only valid gender codes exist.
-- Expected values:
-- 1 = Male
-- 2 = Female
------------------------------------------------------------

SELECT
    sex,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY sex
ORDER BY sex;


------------------------------------------------------------
-- 4. REPAYMENT STATUS (PAY_0)
-- Examine repayment status codes and their frequency.
-- Understanding these values is essential before
-- feature engineering delinquency-related variables.
------------------------------------------------------------

SELECT
    pay_0,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_0
ORDER BY pay_0;


------------------------------------------------------------
-- 5. REPAYMENT STATUS (PAY_2)
------------------------------------------------------------

SELECT
    pay_2,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_2
ORDER BY pay_2;


------------------------------------------------------------
-- 6. REPAYMENT STATUS (PAY_3)
------------------------------------------------------------

SELECT
    pay_3,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_3
ORDER BY pay_3;


------------------------------------------------------------
-- 7. REPAYMENT STATUS (PAY_4)
------------------------------------------------------------

SELECT
    pay_4,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_4
ORDER BY pay_4;


------------------------------------------------------------
-- 8. REPAYMENT STATUS (PAY_5)
------------------------------------------------------------

SELECT
    pay_5,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_5
ORDER BY pay_5;


------------------------------------------------------------
-- 9. REPAYMENT STATUS (PAY_6)
------------------------------------------------------------

SELECT
    pay_6,
    COUNT(*) AS customer_count
FROM stg_credit_card_clients
GROUP BY pay_6
ORDER BY pay_6;


------------------------------------------------------------
-- 10. AGE
-- Review the minimum, maximum, and average customer age.
-- Helps detect unrealistic values before modeling.
------------------------------------------------------------

SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    ROUND(AVG(age), 2) AS average_age
FROM stg_credit_card_clients;


------------------------------------------------------------
-- 11. CREDIT LIMIT
-- Review the range and average credit limit.
-- Helps identify potential outliers or invalid values.
------------------------------------------------------------

SELECT
    MIN(limit_bal) AS minimum_credit_limit,
    MAX(limit_bal) AS maximum_credit_limit,
    ROUND(AVG(limit_bal), 2) AS average_credit_limit
FROM stg_credit_card_clients;



/*==========================================================
DATA PREPARATION
Purpose: Create a cleaned version of the raw dataset for
feature engineering and machine learning.
==========================================================*/

DROP TABLE IF EXISTS credit_card_clean;

CREATE TABLE credit_card_clean AS

SELECT

    id,
    limit_bal,
    sex,

    ------------------------------------------------------------
    -- Standardize education categories
    -- Map invalid codes (0, 5, 6) to 'Others' (4)
    ------------------------------------------------------------
    CASE
        WHEN education IN (0, 5, 6) THEN 4
        ELSE education
    END AS education,

    ------------------------------------------------------------
    -- Standardize marriage categories
    -- Map invalid code (0) to 'Others' (3)
    ------------------------------------------------------------
    CASE
        WHEN marriage = 0 THEN 3
        ELSE marriage
    END AS marriage,

    age,

    pay_0,
    pay_2,
    pay_3,
    pay_4,
    pay_5,
    pay_6,

    bill_amt1,
    bill_amt2,
    bill_amt3,
    bill_amt4,
    bill_amt5,
    bill_amt6,

    pay_amt1,
    pay_amt2,
    pay_amt3,
    pay_amt4,
    pay_amt5,
    pay_amt6,

    default_payment_next_month

FROM stg_credit_card_clients;

------------------------------------------------------------
-- Verify education categories after standardization
------------------------------------------------------------

SELECT
    education,
    COUNT(*) AS customer_count
FROM credit_card_clean
GROUP BY education
ORDER BY education;

------------------------------------------------------------
-- Verify marriage categories after standardization
------------------------------------------------------------

SELECT
    marriage,
    COUNT(*) AS customer_count
FROM credit_card_clean
GROUP BY marriage
ORDER BY marriage;

-- Check for negative bill amounts

SELECT COUNT(*) AS negative_bill_records
FROM credit_card_clean
WHERE bill_amt1 < 0
   OR bill_amt2 < 0
   OR bill_amt3 < 0
   OR bill_amt4 < 0
   OR bill_amt5 < 0
   OR bill_amt6 < 0;

-- Check for negative payment amounts

SELECT COUNT(*) AS negative_payment_records
FROM credit_card_clean
WHERE pay_amt1 < 0
   OR pay_amt2 < 0
   OR pay_amt3 < 0
   OR pay_amt4 < 0
   OR pay_amt5 < 0
   OR pay_amt6 < 0;

-- Ensure no records were lost during cleaning

SELECT COUNT(*) AS total_rows
FROM credit_card_clean;