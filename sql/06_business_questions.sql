/* == 
Which Policy Type Generates The Highest Premium Revenue?
Business Objective
Identify the most valuable insurance product.
*/

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

/*Business Insight
Highest premium-generating products should receive:

More marketing budget

Cross-sell campaigns

Product innovation investment */

/* 
Question 2
Which Risk Category Generates Highest Premium Revenue?
Business Objective
Understand whether revenue is coming from
high-risk or low-risk customers.
*/

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


/*
Question 3
Which Policy Type Has Highest Claim Amount?
Business Objective
Identify products creating claim pressure.
*/

SELECT

    dp.PolicyType,

    ROUND(
        SUM(fc.ClaimAmount),
        2
    ) AS TotalClaimAmount

FROM FactClaims fc

JOIN DimPolicy dp
ON fc.PolicyKey = dp.PolicyKey

GROUP BY dp.PolicyType

ORDER BY TotalClaimAmount DESC;

/* Executive Insight
Products generating high claims may require pricing adjustments or underwriting review.*/

/* Question 4
Which States Generate Highest Premium Revenue?
Business Objective
Identify strongest geographic markets..*/

SELECT

    dl.State,

    ROUND(
        SUM(fp.PremiumAmount),
        2
    ) AS PremiumRevenue

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

JOIN DimLocation dl
ON dc.LocationKey = dl.LocationKey

GROUP BY dl.State

ORDER BY PremiumRevenue DESC;

/* 
Question 5
Which States Have Highest Claim Amount?
SQL
*/

SELECT

    dl.State,

    ROUND(
        SUM(fc.ClaimAmount),
        2
    ) AS TotalClaimAmount

FROM FactClaims fc

JOIN DimCustomer dc
ON fc.CustomerKey = dc.CustomerKey

JOIN DimLocation dl
ON dc.LocationKey = dl.LocationKey

GROUP BY dl.State

ORDER BY TotalClaimAmount DESC;

/*
Question 6
Which Payment Method Has Highest Failure Rate?
Business Objective
Improve premium collection efficiency.
*/

SELECT

    dpm.PaymentMethod,

    COUNT(*) AS TotalPayments,

    SUM(
        CASE
            WHEN dps.PaymentStatus='Failed'
            THEN 1
            ELSE 0
        END
    ) AS FailedPayments,

    ROUND(
        (
            SUM(
                CASE
                    WHEN dps.PaymentStatus='Failed'
                    THEN 1
                    ELSE 0
                END
            )
            /
            COUNT(*)
        ) * 100,
        2
    ) AS FailureRatePct

FROM FactPayments fp

JOIN DimPaymentMethod dpm
ON fp.PaymentMethodKey = dpm.PaymentMethodKey

JOIN DimPaymentStatus dps
ON fp.PaymentStatusKey = dps.PaymentStatusKey

GROUP BY dpm.PaymentMethod

ORDER BY FailureRatePct DESC;


/*
Question 7
Which Customers Should Be Targeted For Renewal Campaigns?
Business Objective
Identify immediate revenue opportunities.
*/

SELECT

    dc.CustomerID,

    dc.CustomerName,

    dp.PolicyType,

    dd.FullDate AS PolicyEndDate

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey

JOIN DimDate dd
ON fp.PolicyEndDateKey = dd.DateKey

WHERE dd.YearNumber = YEAR(CURDATE())

ORDER BY dd.FullDate;


/*
Question 9
Which Age Group Generates Highest Premium Revenue?
*/

SELECT

    dc.AgeBucket,

    ROUND(
        SUM(fp.PremiumAmount),
        2
    ) AS PremiumRevenue

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

GROUP BY dc.AgeBucket

ORDER BY PremiumRevenue DESC;

/* Question 9
Which Risk Category Is Most Profitable?
Business Objective
Revenue vs Claims comparison */

SELECT

    dr.RiskCategory,

    ROUND(
        SUM(fp.PremiumAmount),
        2
    ) AS PremiumRevenue,

    ROUND(
        SUM(fc.ClaimAmount),
        2
    ) AS ClaimAmount

FROM FactPolicies fp

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

JOIN FactClaims fc
ON fp.PolicyKey = fc.PolicyKey

GROUP BY dr.RiskCategory;
