/*==========================================================
FEATURE ENGINEERING
Purpose: Create a modelling dataset with engineered features
for Probability of Default (PD) modelling.
==========================================================*/

DROP TABLE IF EXISTS credit_card_features;

CREATE TABLE credit_card_features AS

SELECT *
FROM credit_card_clean;

------------------------------------------------------------
-- Feature: Average Bill
-- Purpose:
-- Represents the customer's average monthly statement balance.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN average_bill NUMERIC(12,2);

UPDATE credit_card_features

SET average_bill =
    (bill_amt1 +
     bill_amt2 +
     bill_amt3 +
     bill_amt4 +
     bill_amt5 +
     bill_amt6) / 6.0;

SELECT
    id,
    average_bill
FROM credit_card_features
LIMIT 10;	 

------------------------------------------------------------
-- Feature: Average Payment
-- Purpose:
-- The average amount the customer repays every month.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN average_payment NUMERIC(12,2);

UPDATE credit_card_features
SET average_payment =
    (pay_amt1 +
     pay_amt2 +
     pay_amt3 +
     pay_amt4 +
     pay_amt5 +
     pay_amt6) / 6.0;

SELECT
    id,
    average_bill,
    average_payment
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------
-- Feature: Credit Utilization Ratio
-- Purpose:
-- Measures the proportion of the available credit limit
-- that is being utilized on average.
-- Formula:
-- Average Bill / Credit Limit
------------------------------------------------------------


ALTER TABLE credit_card_features
ADD COLUMN credit_utilization_ratio NUMERIC(10,4);

UPDATE credit_card_features
SET credit_utilization_ratio =
    average_bill / NULLIF(limit_bal, 0);

SELECT
    id,
    limit_bal,
    average_bill,
    credit_utilization_ratio
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------
-- Feature: Payment-to-Bill Ratio
-- Purpose:
-- Measures how much of the average monthly bill the customer
-- repays on average.
-- Formula:
-- Average Payment / Average Bill
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN payment_to_bill_ratio NUMERIC(10,4);

UPDATE credit_card_features
SET payment_to_bill_ratio =
    average_payment / NULLIF(average_bill, 0);

SELECT
    id,
    average_bill,
    average_payment,
    payment_to_bill_ratio
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------------------------
-- Feature: Average Payment Delay
-- Purpose:
-- Measures the customer's average repayment delay across
-- the last six months.
-- Formula:
-- Average of PAY_0, PAY_2, PAY_3, PAY_4, PAY_5 and PAY_6
-- Note:
-- Negative values represent early payment or payment made before the due date.
--------------------------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN average_delay NUMERIC(10,2);

UPDATE credit_card_features
SET average_delay =
    (pay_0 +
     pay_2 +
     pay_3 +
     pay_4 +
     pay_5 +
     pay_6) / 6.0;

SELECT
    id,
    pay_0,
    pay_2,
    pay_3,
    pay_4,
    pay_5,
    pay_6,
    average_delay
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------
-- Feature: Maximum Payment Delay
-- Purpose:
-- Captures the highest repayment delay recorded over the
-- last six months.
-- Formula:
-- Maximum of PAY_0, PAY_2, PAY_3, PAY_4, PAY_5 and PAY_6
-- Note:
-- Negative values indicate early repayment.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN maximum_delay INTEGER;

UPDATE credit_card_features
SET maximum_delay =
    GREATEST(
        pay_0,
        pay_2,
        pay_3,
        pay_4,
        pay_5,
        pay_6
    );

SELECT
    id,
    pay_0,
    pay_2,
    pay_3,
    pay_4,
    pay_5,
    pay_6,
    maximum_delay
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------
-- Feature: Delay Frequency
-- Purpose:
-- Counts the number of months in which the customer made
-- a late payment during the last six months.
-- Formula:
-- Count of repayment status values greater than 0.
-- Note:
-- PAY_X > 0 indicates a delayed payment.
-- PAY_X <= 0 indicates payment on time or earlier.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN delay_frequency INTEGER;

UPDATE credit_card_features
SET delay_frequency =
      (CASE WHEN pay_0 > 0 THEN 1 ELSE 0 END)
    + (CASE WHEN pay_2 > 0 THEN 1 ELSE 0 END)
    + (CASE WHEN pay_3 > 0 THEN 1 ELSE 0 END)
    + (CASE WHEN pay_4 > 0 THEN 1 ELSE 0 END)
    + (CASE WHEN pay_5 > 0 THEN 1 ELSE 0 END)
    + (CASE WHEN pay_6 > 0 THEN 1 ELSE 0 END);

SELECT
    id,
    pay_0,
    pay_2,
    pay_3,
    pay_4,
    pay_5,
    pay_6,
    delay_frequency
FROM credit_card_features
LIMIT 10;


------------------------------------------------------------
-- Feature: Bill Volatility
-- Purpose:
-- Measures the variability of the customer's monthly bill
-- amounts over the last six months.
-- Formula:
-- Standard Deviation of BILL_AMT1 to BILL_AMT6
-- Note:
-- A value of 0 indicates identical bill amounts every month.
--------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN bill_volatility NUMERIC(12,2);

UPDATE credit_card_features c
SET bill_volatility = v.bill_std
FROM (
    SELECT
        id,
        STDDEV(val) AS bill_std
    FROM credit_card_features,
         LATERAL (
             VALUES
                 (bill_amt1),
                 (bill_amt2),
                 (bill_amt3),
                 (bill_amt4),
                 (bill_amt5),
                 (bill_amt6)
         ) AS bills(val)
    GROUP BY id
) v
WHERE c.id = v.id;

SELECT
    id,
    average_bill,
    bill_volatility
FROM credit_card_features
LIMIT 10;


-------------------------------------------------------------
-- Feature: Payment Volatility
-- Purpose:
-- Measures the variability of the customer's monthly payment
-- amounts over the last six months.
-- Formula:
-- Standard Deviation of PAY_AMT1 to PAY_AMT6
-------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN payment_volatility NUMERIC(12,2);

UPDATE credit_card_features c
SET payment_volatility = v.payment_std
FROM (
    SELECT
        id,
        STDDEV(val) AS payment_std
    FROM credit_card_features,
         LATERAL (
             VALUES
                 (pay_amt1),
                 (pay_amt2),
                 (pay_amt3),
                 (pay_amt4),
                 (pay_amt5),
                 (pay_amt6)
         ) AS payments(val)
    GROUP BY id
) v
WHERE c.id = v.id;

SELECT
    id,
    average_payment,
    payment_volatility
FROM credit_card_features
LIMIT 10;

--------------
-- VALIDATION
--------------

SELECT
    COUNT(*) AS total_rows,

    COUNT(average_bill) AS avg_bill,

    COUNT(average_payment) AS avg_payment,

    COUNT(credit_utilization_ratio) AS utilization,

    COUNT(payment_to_bill_ratio) AS payment_ratio,

    COUNT(average_delay) AS avg_delay,

    COUNT(maximum_delay) AS max_delay,

    COUNT(delay_frequency) AS delay_freq,

    COUNT(bill_volatility) AS bill_volatility,

    COUNT(payment_volatility) AS payment_volatility

FROM credit_card_features;

SELECT COUNT(*) AS zero_average_bill
FROM credit_card_features
WHERE average_bill = 0;

-------------------------------------------------
-- Update Payment-to-Bill Ratio
-- Replace NULL values (Average Bill = 0) with 0.
-------------------------------------------------

UPDATE credit_card_features
SET payment_to_bill_ratio = 0
WHERE payment_to_bill_ratio IS NULL;

SELECT COUNT(payment_to_bill_ratio)
FROM credit_card_features;



------------------------------------------------------------
-- Business Variable: Credit Limit Band
-- Purpose:
-- Segments customers according to their approved credit
-- limit for portfolio analysis and reporting.
--
-- Business Interpretation:
-- Higher credit limits generally indicate customers with
-- greater borrowing capacity and different risk profiles.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN credit_limit_band VARCHAR(20);

UPDATE credit_card_features
SET credit_limit_band =
CASE
    WHEN limit_bal < 50000 THEN 'Very Low'
    WHEN limit_bal < 100000 THEN 'Low'
    WHEN limit_bal < 200000 THEN 'Medium'
    WHEN limit_bal < 500000 THEN 'High'
    ELSE 'Very High'
END;

SELECT
    credit_limit_band,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY credit_limit_band
ORDER BY
MIN(limit_bal);


------------------------------------------------------------
-- Business Variable: Age Band
-- Purpose:
-- Segments customers into age groups for demographic
-- analysis and portfolio reporting.
--
-- Business Interpretation:
-- Different age groups often exhibit different borrowing,
-- spending and repayment behaviours.
--
-- Note:
-- This variable is intended for business analysis and
-- visualization. The original numeric AGE variable will
-- still be used for machine learning.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN age_band VARCHAR(20);

UPDATE credit_card_features
SET age_band =
CASE
    WHEN age < 30 THEN '21-29'
    WHEN age < 40 THEN '30-39'
    WHEN age < 50 THEN '40-49'
    WHEN age < 60 THEN '50-59'
    ELSE '60+'
END;

SELECT
    age_band,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY age_band
ORDER BY age_band;


------------------------------------------------------------
-- Business Variable: Utilization Band
-- Purpose:
-- Segments customers based on their average credit
-- utilization ratio.
--
-- Business Interpretation:
-- Customers with higher utilization are generally more
-- dependent on credit and may have a higher likelihood
-- of default.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN utilization_band VARCHAR(20);

UPDATE credit_card_features
SET utilization_band =
CASE
    WHEN credit_utilization_ratio < 0.30 THEN 'Low'
    WHEN credit_utilization_ratio < 0.60 THEN 'Medium'
    WHEN credit_utilization_ratio < 0.90 THEN 'High'
    ELSE 'Very High'
END;

SELECT
    utilization_band,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY utilization_band
ORDER BY
CASE utilization_band
    WHEN 'Low' THEN 1
    WHEN 'Medium' THEN 2
    WHEN 'High' THEN 3
    WHEN 'Very High' THEN 4
END;


------------------------------------------------------------
-- Business Variable: Payment Ratio Band
-- Purpose:
-- Segments customers according to the proportion of their
-- monthly bill that they repay on average.
--
-- Business Interpretation:
-- Customers with higher repayment ratios generally exhibit
-- stronger repayment discipline and lower credit risk.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN payment_ratio_band VARCHAR(20);

UPDATE credit_card_features
SET payment_ratio_band =
CASE
    WHEN payment_to_bill_ratio < 0.25 THEN 'Low'
    WHEN payment_to_bill_ratio < 0.50 THEN 'Medium'
    WHEN payment_to_bill_ratio < 0.75 THEN 'High'
    ELSE 'Very High'
END;

SELECT
    payment_ratio_band,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY payment_ratio_band
ORDER BY
CASE payment_ratio_band
    WHEN 'Low' THEN 1
    WHEN 'Medium' THEN 2
    WHEN 'High' THEN 3
    WHEN 'Very High' THEN 4
END;


------------------------------------------------------------
-- Business Variable: Delay Category
-- Purpose:
-- Categorizes customers based on the frequency of late
-- payments over the last six months.
--
-- Business Interpretation:
-- Customers with more frequent payment delays generally
-- represent higher credit risk and require closer
-- monitoring.
------------------------------------------------------------

ALTER TABLE credit_card_features
ADD COLUMN delay_category VARCHAR(20);

UPDATE credit_card_features
SET delay_category =
CASE
    WHEN delay_frequency = 0 THEN 'Never Late'
    WHEN delay_frequency <= 2 THEN 'Occasionally Late'
    WHEN delay_frequency <= 4 THEN 'Frequently Late'
    ELSE 'Chronically Late'
END;

SELECT
    delay_category,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY delay_category
ORDER BY
CASE delay_category
    WHEN 'Never Late' THEN 1
    WHEN 'Occasionally Late' THEN 2
    WHEN 'Frequently Late' THEN 3
    WHEN 'Chronically Late' THEN 4
END;