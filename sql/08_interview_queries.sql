/* Interview : SECTION 1 — CTE QUESTIONS:

 Question 1
Find Top 5 Customers by Premium Revenue
CTE Solution */

WITH CustomerPremium AS
(
    SELECT

        dc.CustomerID,
        dc.CustomerName,

        SUM(fp.PremiumAmount) AS TotalPremium

    FROM FactPolicies fp

    JOIN DimCustomer dc
    ON fp.CustomerKey = dc.CustomerKey

    GROUP BY
        dc.CustomerID,
        dc.CustomerName
)

SELECT *

FROM CustomerPremium

ORDER BY TotalPremium DESC

LIMIT 5;


/* Interview Question 2
Find States Contributing More Than Average Premium Revenue */

WITH StateRevenue AS
(
    SELECT

        dl.State,

        SUM(fp.PremiumAmount) AS Revenue

    FROM FactPolicies fp

    JOIN DimCustomer dc
    ON fp.CustomerKey = dc.CustomerKey

    JOIN DimLocation dl
    ON dc.LocationKey = dl.LocationKey

    GROUP BY dl.State
)

SELECT *

FROM StateRevenue

WHERE Revenue >
(
    SELECT AVG(Revenue)
    FROM StateRevenue
);


/* WINDOW FUNCTION QUESTIONS */

/*
Interview Question 3 : Rank Customers by Premium Revenue*/

SELECT

    dc.CustomerID,

    SUM(fp.PremiumAmount) AS Revenue,

    RANK() OVER
    (
        ORDER BY
        SUM(fp.PremiumAmount) DESC
    ) AS RevenueRank

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

GROUP BY dc.CustomerID;

/* Interview Question 4
Top Customer Within Each State */

WITH CustomerRevenue AS
(
    SELECT

        dl.State,

        dc.CustomerID,

        SUM(fp.PremiumAmount) AS Revenue,

        ROW_NUMBER() OVER
        (
            PARTITION BY dl.State
            ORDER BY SUM(fp.PremiumAmount) DESC
        ) AS rn

    FROM FactPolicies fp

    JOIN DimCustomer dc
    ON fp.CustomerKey = dc.CustomerKey

    JOIN DimLocation dl
    ON dc.LocationKey = dl.LocationKey

    GROUP BY
        dl.State,
        dc.CustomerID
)

SELECT *

FROM CustomerRevenue

WHERE rn = 1;

/* SECTION 3 — BUSINESS CASE SQL */

/* Interview Question 5
Which Policy Types Have Above Average Claim Amount? */

WITH PolicyClaims AS
(
    SELECT

        dp.PolicyType,

        SUM(fc.ClaimAmount) AS TotalClaims

    FROM FactClaims fc

    JOIN DimPolicy dp
    ON fc.PolicyKey = dp.PolicyKey

    GROUP BY dp.PolicyType
)

SELECT *

FROM PolicyClaims

WHERE TotalClaims >
(
    SELECT AVG(TotalClaims)
    FROM PolicyClaims
);


/* Interview Question 6
Which States Have Both High Revenue and High Claims? */

WITH RevenueByState AS
(
    SELECT

        dl.State,

        SUM(fp.PremiumAmount) AS Revenue

    FROM FactPolicies fp

    JOIN DimCustomer dc
    ON fp.CustomerKey = dc.CustomerKey

    JOIN DimLocation dl
    ON dc.LocationKey = dl.LocationKey

    GROUP BY dl.State
),

ClaimsByState AS
(
    SELECT

        dl.State,

        SUM(fc.ClaimAmount) AS Claims

    FROM FactClaims fc

    JOIN DimCustomer dc
    ON fc.CustomerKey = dc.CustomerKey

    JOIN DimLocation dl
    ON dc.LocationKey = dl.LocationKey

    GROUP BY dl.State
)

SELECT

    r.State,
    r.Revenue,
    c.Claims

FROM RevenueByState r

JOIN ClaimsByState c
ON r.State = c.State;



/* SECTION 4 — SCENARIO-BASED INTERVIEW QUESTIONS
Interview Question 7
Detect Potential Fraud Claims */

SELECT

    fc.ClaimID,

    fc.ClaimAmount,

    dr.RiskCategory

FROM FactClaims fc

JOIN FactPolicies fp
ON fc.PolicyKey = fp.PolicyKey

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

WHERE

    fc.ClaimAmount > 90000

AND dr.RiskCategory = 'High Risk';

DESCRIBE FactClaims;

/* Interview Question 8
Find Customers Who Have Never Made Successful Payment */

SELECT

    dc.CustomerID

FROM DimCustomer dc

WHERE dc.CustomerKey NOT IN
(
    SELECT DISTINCT
           fp.CustomerKey

    FROM FactPayments fp

    JOIN DimPaymentStatus dps
    ON fp.PaymentStatusKey =
       dps.PaymentStatusKey

    WHERE dps.PaymentStatus='Successful'
);

/* SECTION 5 — ANALYTICS ENGINEER QUESTIONS
Interview Question 9
Validate Fact vs Dimension Counts*/

SELECT

    COUNT(*) AS FactPoliciesCount,

    COUNT(DISTINCT PolicyKey)
        AS DistinctPolicies

FROM FactPolicies;

/* Interview Question 10
Detect Orphan Records */

SELECT *

FROM FactPolicies fp

LEFT JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

WHERE dc.CustomerKey IS NULL;

/* SECTION 6 — CONSULTING CASE
Interview Question 11

Business asks:

Revenue is growing but profit is falling. Where would you investigate first? */

SELECT

    dr.RiskCategory,

    SUM(fp.PremiumAmount) AS Revenue,

    SUM(fc.ClaimAmount) AS Claims

FROM DimRisk dr

LEFT JOIN FactPolicies fp
ON dr.RiskKey = fp.RiskKey

LEFT JOIN FactClaims fc
ON dr.RiskKey = fc.RiskKey

GROUP BY dr.RiskCategory;

