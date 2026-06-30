

CREATE OR REPLACE VIEW Insurance_Analytics_Mart AS

WITH ClaimSummary AS
(
    SELECT

        PolicyKey,

        COUNT(*) AS ClaimCount,

        SUM(ClaimAmount) AS TotalClaimAmount,

        AVG(ClaimAmount) AS AvgClaimAmount

    FROM FactClaims

    GROUP BY PolicyKey
),

PaymentSummary AS
(
    SELECT

        PolicyKey,

        COUNT(*) AS PaymentCount,

        SUM(AmountPaid) AS TotalAmountPaid,

        SUM(
            CASE
                WHEN PaymentStatusKey = 1
                THEN 1
                ELSE 0
            END
        ) AS SuccessfulPayments,

        SUM(
            CASE
                WHEN PaymentStatusKey = 2
                THEN 1
                ELSE 0
            END
        ) AS FailedPayments

    FROM FactPayments

    GROUP BY PolicyKey
)

SELECT

    dc.CustomerID,
    dc.CustomerName,
    dc.Gender,
    dc.Age,
    dc.AgeBucket,
    dc.MaritalStatus,

    dl.City,
    dl.State,
    dl.ZipCode,

    dp.PolicyID,
    dp.PolicyType,
    dp.PolicyStatus,
    dp.PaymentFrequency,
    dp.PolicyDurationCategory,
    
    dd_start.FullDate AS PolicyStartDate,
    dd_start.YearNumber AS PolicyStartYear,
    dd_start.MonthNumber AS PolicyStartMonthNumber,
    dd_start.MonthName AS PolicyStartMonth,
    dd_end.FullDate AS PolicyEndDate,
    dd_end.YearNumber AS PolicyEndYear,

    dr.RiskScore,
    dr.RiskCategory,

    fp.PremiumAmount,
    fp.CoverageAmount,
    fp.PolicyCount,

    COALESCE(cs.ClaimCount,0) AS ClaimCount,
    COALESCE(cs.TotalClaimAmount,0) AS TotalClaimAmount,
    COALESCE(cs.AvgClaimAmount,0) AS AvgClaimAmount,

    COALESCE(ps.PaymentCount,0) AS PaymentCount,
    COALESCE(ps.TotalAmountPaid,0) AS TotalAmountPaid,
    COALESCE(ps.SuccessfulPayments,0) AS SuccessfulPayments,
    COALESCE(ps.FailedPayments,0) AS FailedPayments

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

JOIN DimLocation dl
ON dc.LocationKey = dl.LocationKey

JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

LEFT JOIN ClaimSummary cs
ON fp.PolicyKey = cs.PolicyKey

LEFT JOIN PaymentSummary ps
ON fp.PolicyKey = ps.PolicyKey

JOIN DimDate dd_start
ON fp.PolicyStartDateKey = dd_start.DateKey

JOIN DimDate dd_end
ON fp.PolicyEndDateKey = dd_end.DateKey;

DESCRIBE DimCustomer;
SELECT *
FROM DimCustomer
LIMIT 3;

DESCRIBE DimLocation;
DESCRIBE DimPolicy;

SELECT COUNT(*) FROM Insurance_Analytics_Mart;

SELECT * FROM Insurance_Analytics_Mart LIMIT 5;

DESCRIBE FactPolicies;