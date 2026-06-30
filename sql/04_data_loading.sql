

INSERT INTO DimLocation
(
    City,
    State,
    ZipCode
)

SELECT DISTINCT

    TRIM(
        SUBSTRING_INDEX(
            Address,
            ',',
            1
        )
    ) AS City,

    TRIM(
        SUBSTRING_INDEX(
            SUBSTRING_INDEX(
                Address,
                ',',
                2
            ),
            ',',
            -1
        )
    ) AS State,

    TRIM(
        SUBSTRING_INDEX(
            Address,
            ',',
            -1
        )
    ) AS ZipCode

FROM stg_insurance;

SELECT COUNT(*) AS TotalLocations
FROM DimLocation;

SELECT *
FROM DimLocation
LIMIT 5;

SELECT COUNT(*) FROM DimLocation;





-- Load DimCustomer

INSERT INTO DimCustomer
(
    CustomerID,
    CustomerName,
    Gender,
    Age,
    AgeBucket,
    Occupation,
    MaritalStatus,
    LocationKey
)

SELECT DISTINCT

    s.CustomerID,
    s.CustomerName,
    s.Gender,
    s.Age,
    s.AgeBucket,
    s.Occupation,
    s.MaritalStatus,

    l.LocationKey

FROM stg_insurance s

JOIN DimLocation l

ON TRIM(
       SUBSTRING_INDEX(
           s.Address,
           ',',
           1
       )
   ) = l.City

AND TRIM(
       SUBSTRING_INDEX(
           SUBSTRING_INDEX(
               s.Address,
               ',',
               2
           ),
           ',',
           -1
       )
   ) = l.State

AND TRIM(
       SUBSTRING_INDEX(
           s.Address,
           ',',
           -1
       )
   ) = l.ZipCode;
   
   select count(*) from DimCustomer;
   SELECT * FROM DimCustomer LIMIT 5;
   
   SELECT COUNT(*)
FROM stg_insurance;

SELECT COUNT(DISTINCT CustomerID)
FROM stg_insurance;

SELECT
COUNT(*) AS TotalRows,
COUNT(DISTINCT CustomerID) AS UniqueCustomers
FROM stg_insurance;

SELECT
COUNT(*)
FROM
(
    SELECT DISTINCT
        CustomerID
    FROM stg_insurance
) x;

SELECT
COUNT(*) AS TotalRows,
COUNT(DISTINCT CustomerID) AS UniqueCustomers,
COUNT(DISTINCT PolicyID) AS UniquePolicies
FROM stg_insurance;

SELECT
COUNT(*) AS TotalRows,
COUNT(DISTINCT PolicyID) AS UniquePolicies
FROM stg_insurance;

SELECT COUNT(DISTINCT PolicyID)
FROM stg_insurance;

/*=========================================
LOAD DIMPOLICY
=========================================*/

INSERT INTO DimPolicy
(
    PolicyID,
    PolicyType,
    PaymentFrequency,
    PolicyStatus,
    PolicyDurationCategory
)

SELECT DISTINCT

    PolicyID,
    PolicyType,
    PaymentFrequency,
    PolicyStatus,
    PolicyDurationCategory

FROM stg_insurance;

SELECT COUNT(*)
FROM DimPolicy;

SELECT *
FROM DimPolicy
LIMIT 10;


SELECT COUNT(*) 
FROM stg_insurance;

SELECT COUNT(DISTINCT
       CONCAT(
           RiskScore,
           RiskCategory,
           HighRiskFlag
       ) 
) as Risk_Profile
FROM stg_insurance;

/*=========================================
LOAD DIMRISK
=========================================*/

INSERT INTO DimRisk
(
    RiskScore,
    RiskCategory,
    HighRiskFlag
)

SELECT DISTINCT

    RiskScore,
    RiskCategory,
    HighRiskFlag

FROM stg_insurance;

select count(*) from dimrisk;

select * from dimrisk limit 5;

ALTER TABLE DimClaimStatus

ADD COLUMN StatusGroup VARCHAR(50),

ADD COLUMN StatusDescription VARCHAR(255);

describe dimclaimstatus;
SET SQL_SAFE_UPDATES = 0;
UPDATE DimClaimStatus
SET
    StatusGroup = 'Closed',
    StatusDescription = 'Claim Approved and Settled'
WHERE ClaimStatus = 'Approved';

UPDATE DimClaimStatus
SET
    StatusGroup = 'Closed',
    StatusDescription = 'Claim Rejected'
WHERE ClaimStatus = 'Denied';

UPDATE DimClaimStatus
SET
    StatusGroup = 'Open',
    StatusDescription = 'Claim Under Review'
WHERE ClaimStatus = 'Pending';

select * from dimclaimstatus;

INSERT INTO DimClaimStatus
(
    ClaimStatus
)

SELECT DISTINCT
       ClaimStatus
FROM stg_claims;

SELECT COUNT(*)
FROM DimClaimStatus;

SELECT *
FROM DimClaimStatus;

ALTER TABLE DimPaymentStatus

ADD COLUMN StatusGroup VARCHAR(50),

ADD COLUMN StatusDescription VARCHAR(255);

INSERT INTO DimPaymentStatus
(
    PaymentStatus
)

SELECT DISTINCT
       PaymentStatus
FROM stg_payments;

UPDATE DimPaymentStatus
SET
    StatusGroup = 'Completed',
    StatusDescription = 'Payment received successfully'
WHERE PaymentStatus = 'Successful';

UPDATE DimPaymentStatus
SET
    StatusGroup = 'Exception',
    StatusDescription = 'Payment failed or rejected'
WHERE PaymentStatus = 'Failed';

SELECT *
FROM DimPaymentStatus;


INSERT INTO DimPaymentMethod
(
    PaymentMethod
)

SELECT DISTINCT
       PaymentMethod
FROM stg_payments;

SELECT *
FROM DimPaymentMethod;

SELECT * FROM DimPaymentStatus;
select * from dimdate;

SELECT
MIN(PolicyStartDate),
MAX(PolicyEndDate)
FROM stg_insurance;

SELECT
MIN(DateOfClaim),
MAX(DateOfClaim)
FROM stg_claims;

SELECT
MIN(DateOfPayment),
MAX(DateOfPayment)
FROM stg_payments;


SET @start_date = '2014-01-01';
SET @end_date   = '2035-12-31';

SELECT VERSION();

SET SESSION cte_max_recursion_depth = 10000;
INSERT INTO DimDate
(
    DateKey,
    FullDate,
    DayNumber,
    MonthNumber,
    MonthName,
    QuarterNumber,
    YearNumber,
    WeekNumber
)

WITH RECURSIVE DateSeries AS
(
    SELECT DATE('2014-01-01') AS dt

    UNION ALL

    SELECT DATE_ADD(dt, INTERVAL 1 DAY)
    FROM DateSeries
    WHERE dt < '2035-12-31'
)

SELECT

    DATE_FORMAT(dt,'%Y%m%d') + 0 AS DateKey,

    dt AS FullDate,

    DAY(dt) AS DayNumber,

    MONTH(dt) AS MonthNumber,

    MONTHNAME(dt) AS MonthName,

    QUARTER(dt) AS QuarterNumber,

    YEAR(dt) AS YearNumber,

    WEEK(dt) AS WeekNumber

FROM DateSeries;

SELECT COUNT(*)
FROM DimDate;

SELECT *
FROM DimDate
LIMIT 10;


/*=========================================
LOAD FACTPOLICIES
=========================================*/

INSERT INTO FactPolicies
(
    CustomerKey,
    PolicyKey,
    RiskKey,

    PolicyStartDateKey,
    PolicyEndDateKey,

    PremiumAmount,
    CoverageAmount,

    PolicyCount
)

SELECT

    dc.CustomerKey,

    dp.PolicyKey,

    dr.RiskKey,

    dstart.DateKey,

    dend.DateKey,

    s.PremiumAmount,

    s.CoverageAmount,

    1 AS PolicyCount

FROM stg_insurance s

JOIN DimCustomer dc
ON s.CustomerID = dc.CustomerID

JOIN DimPolicy dp
ON s.PolicyID = dp.PolicyID

JOIN DimRisk dr
ON s.RiskScore = dr.RiskScore
AND s.RiskCategory = dr.RiskCategory
AND s.HighRiskFlag = dr.HighRiskFlag

JOIN DimDate dstart
ON s.PolicyStartDate = dstart.FullDate

JOIN DimDate dend
ON s.PolicyEndDate = dend.FullDate;

SELECT COUNT(*)
FROM FactPolicies;

SELECT *
FROM FactPolicies
LIMIT 10;

/*=========================================
LOAD FACTCLAIMS
=========================================*/

INSERT INTO FactClaims
(
    ClaimID,

    CustomerKey,
    PolicyKey,

    ClaimStatusKey,

    ClaimDateKey,
    SettlementDateKey,

    ClaimAmount,
    SettlementDays,

    ClaimCount
)

SELECT

    c.ClaimID,

    dc.CustomerKey,

    dp.PolicyKey,

    dcs.ClaimStatusKey,

    dclaim.DateKey,

    dsettle.DateKey,

    c.ClaimAmount,

    c.SettlementDays,

    1 AS ClaimCount

FROM stg_claims c

JOIN stg_insurance s
ON c.PolicyID = s.PolicyID

JOIN DimCustomer dc
ON s.CustomerID = dc.CustomerID

JOIN DimPolicy dp
ON c.PolicyID = dp.PolicyID

JOIN DimClaimStatus dcs
ON c.ClaimStatus = dcs.ClaimStatus

JOIN DimDate dclaim
ON c.DateOfClaim = dclaim.FullDate

LEFT JOIN DimDate dsettle
ON c.SettlementDate = dsettle.FullDate;

SELECT *
FROM stg_claims
WHERE SettlementDate = ''
LIMIT 10;

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDate IS NULL;

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDate = '';

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDate = '0000-00-00';

SELECT
SettlementDate,
COUNT(*)
FROM stg_claims
GROUP BY SettlementDate
ORDER BY SettlementDate;

UPDATE stg_claims
SET SettlementDate = NULL
WHERE SettlementDate = '';

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDate IS NULL;

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDays = '';

DESCRIBE stg_claims;

UPDATE stg_claims
SET SettlementDays = NULL
WHERE SettlementDays = '';

SELECT COUNT(*)
FROM stg_claims
WHERE SettlementDays IS NULL;


/*=========================================
LOAD FACTPAYMENTS
=========================================*/

INSERT INTO FactPayments
(
    PaymentID,

    CustomerKey,
    PolicyKey,

    PaymentStatusKey,
    PaymentMethodKey,

    PaymentDateKey,

    AmountPaid,

    PaymentCount
)

SELECT

    p.PaymentID,

    dc.CustomerKey,

    dp.PolicyKey,

    dps.PaymentStatusKey,

    dpm.PaymentMethodKey,

    dd.DateKey,

    p.AmountPaid,

    1 AS PaymentCount

FROM stg_payments p

JOIN stg_insurance s
ON p.PolicyID = s.PolicyID

JOIN DimCustomer dc
ON s.CustomerID = dc.CustomerID

JOIN DimPolicy dp
ON p.PolicyID = dp.PolicyID

JOIN DimPaymentStatus dps
ON p.PaymentStatus = dps.PaymentStatus

JOIN DimPaymentMethod dpm
ON p.PaymentMethod = dpm.PaymentMethod

JOIN DimDate dd
ON p.DateOfPayment = dd.FullDate;

/*=========================================
LOAD FACTPAYMENTS
=========================================*/

INSERT INTO FactPayments
(
    PaymentID,

    CustomerKey,
    PolicyKey,

    PaymentStatusKey,
    PaymentMethodKey,

    PaymentDateKey,

    AmountPaid,

    PaymentCount
)

SELECT

    p.PaymentID,

    dc.CustomerKey,

    dp.PolicyKey,

    dps.PaymentStatusKey,

    dpm.PaymentMethodKey,

    dd.DateKey,

    p.AmountPaid,

    1 AS PaymentCount

FROM stg_payments p

JOIN stg_insurance s
ON p.PolicyID = s.PolicyID

JOIN DimCustomer dc
ON s.CustomerID = dc.CustomerID

JOIN DimPolicy dp
ON p.PolicyID = dp.PolicyID

JOIN DimPaymentStatus dps
ON p.PaymentStatus = dps.PaymentStatus

JOIN DimPaymentMethod dpm
ON p.PaymentMethod = dpm.PaymentMethod

JOIN DimDate dd
ON p.DateOfPayment = dd.FullDate;

TRUNCATE TABLE FactPayments;


SELECT COUNT(*)
FROM FactPayments;

SELECT *
FROM FactPayments
LIMIT 10;