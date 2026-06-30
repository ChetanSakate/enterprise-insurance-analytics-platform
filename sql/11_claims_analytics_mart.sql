/*
===========================================================
OBJECT NAME : Claims_Analytics_Mart
AUTHOR      : Chetan Sakate
PROJECT     : Insurance Analytics Platform
PURPOSE     :

Business-ready analytics mart designed for Claims Operations
and Executive Claims Reporting.

Grain:
-----------------------------------------------------------
1 Row = 1 Claim

Primary Consumers:
-----------------------------------------------------------
• Claims Operations Team
• Chief Risk Officer
• Claims Managers
• Fraud Analytics Team
• Tableau Dashboard - Page 3

Key Capabilities:
-----------------------------------------------------------
✓ Claim Trend Analysis
✓ Settlement Performance
✓ Claim Approval Rate
✓ High Value Claim Monitoring
✓ Claim Severity Analysis
✓ Geographic Claim Analysis
===========================================================
*/

CREATE OR REPLACE VIEW Claims_Analytics_Mart AS

SELECT

    fc.ClaimID,

    fc.ClaimAmount,

    fc.SettlementDays,


    dcs.ClaimStatus,

    dcs.StatusGroup,

    dcs.StatusDescription,
    
    
    
    dd_claim.FullDate AS ClaimDate,

    dd_claim.YearNumber AS ClaimYear,

    dd_claim.MonthName AS ClaimMonth,

    dd_settle.FullDate AS SettlementDate,
    
    
    
    dp.PolicyID,

    dp.PolicyType,

    dp.PolicyStatus,

    fp.PremiumAmount,

    fp.CoverageAmount,
    
    
    
    dr.RiskScore,

    dr.RiskCategory,
    
    
    dc.CustomerID,

    dc.Gender,

    dc.Age,

    dc.AgeBucket,
    
    dl.City,

    dl.State,

    dl.ZipCode,
    
        CASE
        WHEN fc.ClaimAmount >= 50000 THEN 1
        ELSE 0
    END AS HighClaimFlag,
    
    
        CASE
        WHEN dcs.ClaimStatus = 'Approved' THEN 1
        ELSE 0
    END AS ApprovedClaimFlag,
    
    
        CASE

        WHEN fc.ClaimAmount < 10000
            THEN 'Low'

        WHEN fc.ClaimAmount < 50000
            THEN 'Medium'

        ELSE 'High'

    END AS ClaimSeverity
    
    
    FROM FactClaims fc

JOIN DimClaimStatus dcs
ON fc.ClaimStatusKey = dcs.ClaimStatusKey

JOIN FactPolicies fp
ON fc.PolicyKey = fp.PolicyKey

JOIN DimPolicy dp
ON fp.PolicyKey = dp.PolicyKey

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

JOIN DimCustomer dc
ON fc.CustomerKey = dc.CustomerKey

JOIN DimLocation dl
ON dc.LocationKey = dl.LocationKey

JOIN DimDate dd_claim
ON fc.ClaimDateKey = dd_claim.DateKey

LEFT JOIN DimDate dd_settle
ON fc.SettlementDateKey = dd_settle.DateKey;


SELECT COUNT(*)
FROM Claims_Analytics_Mart;

SELECT *
FROM Claims_Analytics_Mart
LIMIT 5;