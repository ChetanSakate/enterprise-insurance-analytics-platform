-- Ranking Analysis
-- Top 10 Customers By Premium Contribution
SELECT

    dc.CustomerID,
    dc.CustomerName,

    SUM(fp.PremiumAmount) AS TotalPremium,

    RANK() OVER(
        ORDER BY SUM(fp.PremiumAmount) DESC
    ) AS PremiumRank

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

GROUP BY
    dc.CustomerID,
    dc.CustomerName;
    
    
-- Module 2 — State Performance Ranking

SELECT

    dl.State,

    SUM(fp.PremiumAmount) AS PremiumRevenue,

    DENSE_RANK() OVER(
        ORDER BY SUM(fp.PremiumAmount) DESC
    ) AS StateRank

FROM FactPolicies fp

JOIN DimCustomer dc
ON fp.CustomerKey = dc.CustomerKey

JOIN DimLocation dl
ON dc.LocationKey = dl.LocationKey

GROUP BY dl.State;

-- Risk Ranking
--  Question: Which risk scores generate the highest premium?

SELECT

    dr.RiskScore,

    dr.RiskCategory,

    SUM(fp.PremiumAmount) AS PremiumRevenue,

    RANK() OVER(
        ORDER BY SUM(fp.PremiumAmount) DESC
    ) AS RiskRank

FROM FactPolicies fp

JOIN DimRisk dr
ON fp.RiskKey = dr.RiskKey

GROUP BY
    dr.RiskScore,
    dr.RiskCategory;