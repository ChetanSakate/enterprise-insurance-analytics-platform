CREATE TABLE stg_insurance (

    CustomerID VARCHAR(50),

    CustomerName VARCHAR(255),

    Gender VARCHAR(20),

    Age INT,

    Occupation VARCHAR(255),

    MaritalStatus VARCHAR(50),

    Address VARCHAR(255),

    AgeBucket VARCHAR(50),

    MarriedFlag INT,

    SeniorCitizenFlag INT,

    CustomerSegment VARCHAR(50),

    PolicyID VARCHAR(50),

    PolicyType VARCHAR(50),

    CoverageAmount DECIMAL(18,2),

    PremiumAmount DECIMAL(18,2),

    PolicyStartDate DATE,

    PolicyEndDate DATE,

    PaymentFrequency VARCHAR(50),

    PolicyStatus VARCHAR(50),

    PolicyDurationDays INT,

    PolicyDurationCategory VARCHAR(50),

    ActivePolicyFlag INT,

    AgentID VARCHAR(50),

    RenewalStatus VARCHAR(50),

    PolicyDiscounts DECIMAL(18,2),

    RiskScore INT,

    HighRiskFlag INT,

    RiskCategory VARCHAR(50),

    HighRiskFlagText VARCHAR(20),

    RenewalSegment VARCHAR(50)

);


CREATE TABLE stg_claims (

    ClaimID VARCHAR(50),

    DateOfClaim VARCHAR(50),

    ClaimAmount DECIMAL(18,2),

    ClaimStatus VARCHAR(50),

    ReasonForClaim VARCHAR(255),

    SettlementDate VARCHAR(50),

    PolicyID VARCHAR(50),

    SettlementDateMissingFlag INT,

    HighClaimFlag INT,

    SettlementDays VARCHAR(50),

    SettlementMissingFlag INT,

    ClaimAmountCategory VARCHAR(50),

    ApprovedClaimFlag INT

);

CREATE TABLE stg_payments (

    PaymentID VARCHAR(50),

    DateOfPayment DATE,

    AmountPaid DECIMAL(18,2),

    PaymentMethod VARCHAR(50),

    PaymentStatus VARCHAR(50),

    PolicyID VARCHAR(50),

    FailedPaymentFlag INT,

    PaymentYear varchar(50),

    PaymentMonth Varchar(50),

    SuccessfulPaymentFlag INT,

    FailedPaymentFlag2 INT

);

drop table stg_payments;

show tables;

SELECT COUNT(*) FROM stg_insurance;
SELECT COUNT(*) FROM stg_claims;
SELECT COUNT(*) FROM stg_payments;

SELECT *
FROM stg_insurance
LIMIT 5;

DESCRIBE stg_insurance;
SELECT
    Address,

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

FROM stg_insurance
LIMIT 10;

--  DimLocation


