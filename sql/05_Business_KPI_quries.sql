-- KPI 1 — Total Policies
SELECT
COUNT(*) AS TotalPolicies
FROM FactPolicies;

-- KPI 2 — Total Customers

SELECT
COUNT(*) AS TotalCustomers
from dimcustomer;

-- KPI 3 — Total Premium Revenue
SELECT
ROUND(SUM(PremiumAmount),2) AS TotalPremiumRevenue
FROM FactPolicies;

-- "Total premium revenue exceeds ₹52.6 lakh"

-- KPI 4 — Total Claim Amount

SELECT
ROUND(SUM(ClaimAmount),2) AS TotalClaimAmount
FROM FactClaims;

-- "Claims significantly exceed premium collections, indicating either synthetic data characteristics or a potentially unsustainable claims-to-premium ratio"

-- KPI 5 - Claim Ratio %

SELECT

ROUND(
(
    (SELECT SUM(ClaimAmount)
     FROM FactClaims)

    /

    (SELECT SUM(PremiumAmount)
     FROM FactPolicies)

) * 100,
2
) AS ClaimRatioPct;

/*== Likely synthetic training data.

In real insurance business,
claim ratio >100% is alarming.*/

-- KPI 6 - Active Policy %

SELECT

ROUND(
(
COUNT(
    CASE
        WHEN dp.PolicyStatus='Active'
        THEN 1
    END
)
/
COUNT(*)
) * 100,
2
) AS ActivePolicyPct

FROM FactPolicies fp

JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey;

-- "Only one-third of policies remain active. High lapse and termination rates may indicate retention challenges."

-- KPI 7 - Renewel Rate %

SELECT

ROUND(
(
COUNT(
    CASE
        WHEN RenewalStatus='Renewed'
        THEN 1
    END
)
/
COUNT(*)
) * 100,
2
) AS RenewalRatePct

FROM stg_insurance;

/* Renewal performance is weak.

Retention campaigns should be reviewed.*/

-- KPI 8 — Payment Success Rate %

SELECT

ROUND(
(
COUNT(
CASE
WHEN dps.PaymentStatus='Successful'
THEN 1
END
)
/
COUNT(*)
) * 100,
2
) AS PaymentSuccessRate

FROM FactPayments fp

JOIN DimPaymentStatus dps
ON fp.PaymentStatusKey =
   dps.PaymentStatusKey;
   
/* Almost half of payment attempts fail.

Revenue collection process requires attention.*/

-- KPI 9 — High Risk Policies %

SELECT

ROUND(
(
COUNT(
CASE
WHEN dr.RiskCategory='High Risk'
THEN 1
END
)
/
COUNT(*)
) * 100,
2
) AS HighRiskPolicyPct

FROM FactPolicies fp

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey;

/* Nearly 40% of the portfolio
belongs to high-risk customers.

Underwriting rules should be reviewed.*/

-- KPI 10 — Policies Expiring This Year

SELECT

COUNT(*) AS PoliciesExpiringThisYear

FROM FactPolicies fp

JOIN DimDate dd
ON fp.PolicyEndDateKey =
   dd.DateKey

WHERE dd.YearNumber = YEAR(CURDATE());


-- KPI 11 — Premium Revenue By Policy Type

SELECT

dp.PolicyType,

ROUND(
SUM(fp.PremiumAmount),
2
) AS PremiumRevenue

FROM FactPolicies fp

JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey

GROUP BY dp.PolicyType

ORDER BY PremiumRevenue DESC;


-- KPI 12 — Claim Amount By Claim Status

SELECT

dcs.ClaimStatus,

ROUND(
SUM(fc.ClaimAmount),
2
) AS ClaimAmount

FROM FactClaims fc

JOIN DimClaimStatus dcs
ON fc.ClaimStatusKey =
   dcs.ClaimStatusKey

GROUP BY dcs.ClaimStatus;

-- KPI 13 — Premium Revenue By Risk Category
SELECT

dr.RiskCategory,

ROUND(
SUM(fp.PremiumAmount),
2
) AS PremiumRevenue

FROM FactPolicies fp

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

GROUP BY dr.RiskCategory

ORDER BY PremiumRevenue DESC;

-- KPI 14 — Payment Method Analysis
SELECT

dpm.PaymentMethod,

COUNT(*) AS PaymentCount,

ROUND(
SUM(fp.AmountPaid),
2
) AS AmountCollected

FROM FactPayments fp

JOIN DimPaymentMethod dpm
ON fp.PaymentMethodKey =
   dpm.PaymentMethodKey

GROUP BY dpm.PaymentMethod;

-- KPI 15 — Customer Distribution By Age Bucket
SELECT

AgeBucket,

COUNT(*) AS CustomerCount

FROM DimCustomer

GROUP BY AgeBucket

ORDER BY CustomerCount DESC;
