/*==========================================================
SECTION 1
PORTFOLIO OVERVIEW
==========================================================*/

/*==========================================================
Business Question:
How many customers are in the credit portfolio?

Purpose:
Determine the size of the customer portfolio.

Business Insight:
Provides the total number of active customer records used
for analysis and model development.
==========================================================*/

SELECT
    COUNT(*) AS total_customers
FROM credit_card_features;


/*==========================================================
Business Question:
How many customers defaulted and how many did not?

Purpose:
Understand the class distribution of the portfolio.

Business Insight:
Provides the number of defaulting and non-defaulting
customers.
==========================================================*/

SELECT
    default_payment_next_month,
    COUNT(*) AS customers
FROM credit_card_features
GROUP BY default_payment_next_month
ORDER BY default_payment_next_month;


/*==========================================================
Business Question:
What percentage of customers defaulted?

Purpose:
Measure the overall credit risk of the portfolio.

Business Insight:
Higher default rates indicate greater portfolio risk and
potential financial losses.
==========================================================*/

SELECT
    ROUND(
        100.0 *
        SUM(CASE WHEN default_payment_next_month = 1 THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS default_rate_percent
FROM credit_card_features;


/*==========================================================
Business Question:
What are the key financial indicators of the portfolio?

Purpose:
Summarize the overall characteristics of the customer
portfolio.

Business Insight:
Provides an executive-level overview of customer
demographics, credit exposure, repayment behaviour,
and default risk.
==========================================================*/

SELECT

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS total_defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate_percent,

ROUND(AVG(limit_bal),2) AS avg_credit_limit,

ROUND(AVG(age),2) AS avg_age,

ROUND(AVG(average_bill),2) AS avg_monthly_bill,

ROUND(AVG(average_payment),2) AS avg_monthly_payment,

ROUND(
100.0 * AVG(credit_utilization_ratio),
2
) AS avg_credit_utilization_percent

FROM credit_card_features;


/*==========================================================
SECTION 2
CUSTOMER SEGMENTATION
==========================================================*/

/*==========================================================
Business Question:
What is the gender distribution of customers?

Purpose:
Understand the composition of the customer portfolio by
gender.

Business Insight:
Identifies the proportion of male and female customers,
supporting demographic analysis.
==========================================================*/

SELECT
    sex,
    CASE
        WHEN sex = 1 THEN 'Male'
        WHEN sex = 2 THEN 'Female'
    END AS gender,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_card_features
GROUP BY sex
ORDER BY sex;


/*==========================================================
Business Question:
What is the education profile of customers?

Purpose:
Analyze customer educational background.

Business Insight:
Helps understand which education groups dominate the
portfolio.
==========================================================*/

SELECT
    education,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_card_features
GROUP BY education
ORDER BY total_customers DESC;


/*==========================================================
Business Question:
How are customers distributed across marital status groups?

Purpose:
Understand the marital composition of the customer base.

Business Insight:
Useful for demographic profiling and customer
segmentation.
==========================================================*/

SELECT
    marriage,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_card_features
GROUP BY marriage
ORDER BY total_customers DESC;


/*==========================================================
Business Question:
How are customers distributed across age groups?

Purpose:
Identify the dominant customer age segments.

Business Insight:
Highlights which age groups make up the largest share
of the credit portfolio.
==========================================================*/

SELECT
    age_band,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_card_features
GROUP BY age_band
ORDER BY
CASE age_band
    WHEN '21-29' THEN 1
    WHEN '30-39' THEN 2
    WHEN '40-49' THEN 3
    WHEN '50-59' THEN 4
    WHEN '60+' THEN 5
END;


/*==========================================================
Business Question:
How are customers distributed across credit limit bands?

Purpose:
Understand how customers are segmented by approved
credit limits.

Business Insight:
Shows whether the portfolio is concentrated in lower,
medium, or higher credit limit categories.
==========================================================*/

SELECT
    credit_limit_band,
    COUNT(*) AS total_customers,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS percentage
FROM credit_card_features
GROUP BY credit_limit_band
ORDER BY
CASE credit_limit_band
    WHEN 'Very Low' THEN 1
    WHEN 'Low' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'High' THEN 4
    WHEN 'Very High' THEN 5
END;


/*==========================================================
SECTION 3
CREDIT RISK ANALYSIS
==========================================================*/

/*==========================================================
Business Question:
Does the default rate differ between male and female customers?

Purpose:
Compare repayment performance across gender groups.

Business Insight:
Identifies whether one gender exhibits a higher
proportion of defaults than the other.
==========================================================*/

SELECT

CASE
    WHEN sex = 1 THEN 'Male'
    WHEN sex = 2 THEN 'Female'
END AS gender,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY sex

ORDER BY default_rate DESC;

/*==========================================================
Business Question:
How does default risk vary across education levels?

Purpose:
Evaluate whether education level is associated with
credit default.

Business Insight:
Helps determine whether educational attainment
correlates with repayment behaviour.
==========================================================*/

SELECT

education,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY education

ORDER BY default_rate DESC;


/*==========================================================
Business Question:
How does default risk vary by marital status?

Purpose:
Compare repayment behaviour across marital groups.

Business Insight:
Supports demographic-based customer segmentation.
==========================================================*/

SELECT

marriage,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY marriage

ORDER BY default_rate DESC;


/*==========================================================
Business Question:
Which age groups have the highest default rates?

Purpose:
Assess credit risk across different age segments.

Business Insight:
Highlights age groups requiring closer portfolio
monitoring.
==========================================================*/

SELECT

age_band,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY age_band

ORDER BY
CASE age_band
    WHEN '21-29' THEN 1
    WHEN '30-39' THEN 2
    WHEN '40-49' THEN 3
    WHEN '50-59' THEN 4
    WHEN '60+' THEN 5
END;


/*==========================================================
Business Question:
How does default risk vary across credit limit bands?

Purpose:
Determine whether customers with different approved
credit limits exhibit different repayment behaviour.

Business Insight:
Supports portfolio segmentation and risk-based
credit management.
==========================================================*/

SELECT

credit_limit_band,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY credit_limit_band

ORDER BY
CASE credit_limit_band
    WHEN 'Very Low' THEN 1
    WHEN 'Low' THEN 2
    WHEN 'Medium' THEN 3
    WHEN 'High' THEN 4
    WHEN 'Very High' THEN 5
END;


/*==========================================================
Business Question:
How does default risk change with credit utilization?

Purpose:
Evaluate whether higher utilization is associated
with greater default risk.

Business Insight:
Customers with higher utilization ratios generally
represent greater credit risk and may require
closer monitoring.
==========================================================*/

SELECT

utilization_band,

COUNT(*) AS total_customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY utilization_band

ORDER BY
CASE utilization_band
    WHEN 'Low' THEN 1
    WHEN 'Medium' THEN 2
    WHEN 'High' THEN 3
    WHEN 'Very High' THEN 4
END;


/*==========================================================
SECTION 4
REPAYMENT BEHAVIOUR ANALYSIS
==========================================================*/

/*==========================================================
Business Question:
Do defaulters repay a smaller proportion of their bills?

Purpose:
Compare repayment discipline between defaulters and
non-defaulters.

Business Insight:
Lower payment-to-bill ratios indicate weaker repayment
behaviour and higher credit risk.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(AVG(payment_to_bill_ratio),2) AS avg_payment_ratio

FROM credit_card_features

GROUP BY default_payment_next_month;


/*==========================================================
Business Question:
Do defaulters experience longer payment delays?

Purpose:
Measure repayment delay across customer groups.

Business Insight:
Longer payment delays generally indicate deteriorating
credit quality.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(AVG(average_delay),2) AS average_delay

FROM credit_card_features

GROUP BY default_payment_next_month;


/*==========================================================
Business Question:
How severe are payment delays among defaulters?

Purpose:
Compare the worst payment delay experienced by each
customer group.

Business Insight:
Customers with higher maximum delays generally
represent greater repayment risk.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(AVG(maximum_delay),2) AS avg_maximum_delay

FROM credit_card_features

GROUP BY default_payment_next_month;


/*==========================================================
Business Question:
How does default rate change across delay categories?

Purpose:
Assess whether frequent late payments increase
default risk.

Business Insight:
Customers with chronic payment delays are expected
to exhibit substantially higher default rates.
==========================================================*/

SELECT

delay_category,

COUNT(*) AS customers,

SUM(default_payment_next_month) AS defaults,

ROUND(
100.0 * SUM(default_payment_next_month) / COUNT(*),
2
) AS default_rate

FROM credit_card_features

GROUP BY delay_category

ORDER BY
CASE delay_category
WHEN 'Never Late' THEN 1
WHEN 'Occasionally Late' THEN 2
WHEN 'Frequently Late' THEN 3
WHEN 'Chronically Late' THEN 4
END;


/*==========================================================
Business Question:
Do defaulters use a larger proportion of their credit?

Purpose:
Compare credit utilization between customer groups.

Business Insight:
Higher utilization often reflects greater financial
stress and elevated default risk.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(
AVG(credit_utilization_ratio) * 100,
2
) AS avg_utilization_percent

FROM credit_card_features

GROUP BY default_payment_next_month;


/*==========================================================
Business Question:
Do defaulters exhibit greater variability in monthly
bill amounts?

Purpose:
Measure billing stability across customer groups.

Business Insight:
Higher bill volatility may indicate unstable spending
patterns and increased repayment uncertainty.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(AVG(bill_volatility),2) AS avg_bill_volatility

FROM credit_card_features

GROUP BY default_payment_next_month;


/*==========================================================
Business Question:
Are payment amounts less consistent among defaulters?

Purpose:
Compare payment stability across customer groups.

Business Insight:
Greater payment volatility may reflect irregular
repayment behaviour and financial instability.
==========================================================*/

SELECT

CASE
    WHEN default_payment_next_month = 0 THEN 'Non-Default'
    ELSE 'Default'
END AS customer_status,

ROUND(AVG(payment_volatility),2) AS avg_payment_volatility

FROM credit_card_features

GROUP BY default_payment_next_month;