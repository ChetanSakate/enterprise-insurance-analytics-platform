-- SECTION 1 — Record Count Validation
-- To Ensure ETL loaded expected number of records.

SELECT
'DimCustomer' AS TableName,
COUNT(*) AS RecordCount
FROM DimCustomer;

SELECT
'DimPolicy' AS TableName,
COUNT(*) AS RecordCount
FROM DimPolicy;

SELECT
'DimRisk' AS TableName,
COUNT(*) AS RecordCount
FROM DimRisk;

SELECT
'FactPolicies' AS TableName,
COUNT(*) AS RecordCount
FROM FactPolicies;


SELECT
'FactClaims' AS TableName,
COUNT(*) AS RecordCount
FROM FactClaims;

SELECT
'FactPayments' AS TableName,
COUNT(*) AS RecordCount
FROM FactPayments;

/* SECTION 2 — Duplicate Checks */

SELECT

PolicyID,

COUNT(*) AS DuplicateCount

FROM DimPolicy

GROUP BY PolicyID

HAVING COUNT(*) > 1;

SELECT

ClaimID,

COUNT(*) AS DuplicateCount

FROM FactClaims

GROUP BY ClaimID

HAVING COUNT(*) > 1;

SELECT

PaymentID,

COUNT(*) AS DuplicateCount

FROM FactPayments

GROUP BY PaymentID

HAVING COUNT(*) > 1;

/* SECTION 3 — Referential Integrity Checks*/

SELECT *

FROM FactPolicies fp

LEFT JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

WHERE dc.CustomerKey IS NULL;

SELECT *

FROM FactPolicies fp

LEFT JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey

WHERE dp.PolicyKey IS NULL;

SELECT *

FROM FactClaims fc

LEFT JOIN DimClaimStatus dcs
ON fc.ClaimStatusKey = dcs.ClaimStatusKey

WHERE dcs.ClaimStatusKey IS NULL;

SELECT *

FROM FactPayments fp

LEFT JOIN DimPaymentStatus dps
ON fp.PaymentStatusKey = dps.PaymentStatusKey

WHERE dps.PaymentStatusKey IS NULL;


/* SECTION 4 — Null Key Validation */

SELECT

SUM(CustomerKey IS NULL) AS NullCustomerKeys,
SUM(PolicyKey IS NULL) AS NullPolicyKeys,
SUM(RiskKey IS NULL) AS NullRiskKeys

FROM FactPolicies;


SELECT

SUM(CustomerKey IS NULL) AS NullCustomerKeys,
SUM(PolicyKey IS NULL) AS NullPolicyKeys,
SUM(ClaimStatusKey IS NULL) AS NullClaimStatusKeys

FROM FactClaims;

SELECT

SUM(CustomerKey IS NULL) AS NullCustomerKeys,
SUM(PolicyKey IS NULL) AS NullPolicyKeys,
SUM(PaymentStatusKey IS NULL) AS NullPaymentStatusKeys

FROM FactPayments;

/* SECTION 5 — Measure Validation */

SELECT

ROUND(
SUM(PremiumAmount),
2
) AS TotalPremium

FROM FactPolicies;

SELECT

ROUND(
SUM(ClaimAmount),
2
) AS TotalClaims

FROM FactClaims;

SELECT

ROUND(
SUM(AmountPaid),
2
) AS TotalPayments

FROM FactPayments;


/* SECTION 6 — Date Integrity Checks */

SELECT *

FROM FactPolicies fp

LEFT JOIN DimDate dd
ON fp.PolicyStartDateKey = dd.DateKey

WHERE dd.DateKey IS NULL;

SELECT *

FROM FactClaims fc

LEFT JOIN DimDate dd
ON fc.ClaimDateKey = dd.DateKey

WHERE dd.DateKey IS NULL;

/* SECTION 7 — Executive Data Quality Scorecard */ 

SELECT

'FactPolicies' AS TableName,
COUNT(*) AS RecordCount

FROM FactPolicies

UNION ALL

SELECT
'FactClaims',
COUNT(*)
FROM FactClaims

UNION ALL

SELECT
'FactPayments',
COUNT(*)
FROM FactPayments;