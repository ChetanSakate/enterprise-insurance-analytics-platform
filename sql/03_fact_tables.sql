/*================================================
Fact Table : Policies
Grain : 1 Row = 1 Policy
================================================*/

CREATE TABLE FactPolicies (

    PolicyFactKey INT AUTO_INCREMENT PRIMARY KEY,

    CustomerKey INT NOT NULL,

    PolicyKey INT NOT NULL,

    RiskKey INT NOT NULL,

    PolicyStartDateKey INT,

    PolicyEndDateKey INT,

    PremiumAmount DECIMAL(18,2),

    CoverageAmount DECIMAL(18,2),

    PolicyCount INT DEFAULT 1,

    FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    FOREIGN KEY (PolicyKey)
        REFERENCES DimPolicy(PolicyKey),

    FOREIGN KEY (RiskKey)
        REFERENCES DimRisk(RiskKey),

    FOREIGN KEY (PolicyStartDateKey)
        REFERENCES DimDate(DateKey),

    FOREIGN KEY (PolicyEndDateKey)
        REFERENCES DimDate(DateKey)

);


/*================================================
Fact Table : Claims
Grain : 1 Row = 1 Claim
================================================*/

CREATE TABLE FactClaims (

    ClaimFactKey INT AUTO_INCREMENT PRIMARY KEY,

    ClaimID VARCHAR(50),

    CustomerKey INT NOT NULL,

    PolicyKey INT NOT NULL,

    ClaimStatusKey INT NOT NULL,

    ClaimDateKey INT,

    SettlementDateKey INT,

    ClaimAmount DECIMAL(18,2),

    SettlementDays INT,

    ClaimCount INT DEFAULT 1,

    FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    FOREIGN KEY (PolicyKey)
        REFERENCES DimPolicy(PolicyKey),

    FOREIGN KEY (ClaimStatusKey)
        REFERENCES DimClaimStatus(ClaimStatusKey),

    FOREIGN KEY (ClaimDateKey)
        REFERENCES DimDate(DateKey),

    FOREIGN KEY (SettlementDateKey)
        REFERENCES DimDate(DateKey)

);

/*================================================
Fact Table : Payments
Grain : 1 Row = 1 Payment
================================================*/

CREATE TABLE FactPayments (

    PaymentFactKey INT AUTO_INCREMENT PRIMARY KEY,

    PaymentID VARCHAR(50),

    CustomerKey INT NOT NULL,

    PolicyKey INT NOT NULL,

    PaymentStatusKey INT NOT NULL,

    PaymentMethodKey INT NOT NULL,

    PaymentDateKey INT,

    AmountPaid DECIMAL(18,2),

    PaymentCount INT DEFAULT 1,

    FOREIGN KEY (CustomerKey)
        REFERENCES DimCustomer(CustomerKey),

    FOREIGN KEY (PolicyKey)
        REFERENCES DimPolicy(PolicyKey),

    FOREIGN KEY (PaymentStatusKey)
        REFERENCES DimPaymentStatus(PaymentStatusKey),

    FOREIGN KEY (PaymentMethodKey)
        REFERENCES DimPaymentMethod(PaymentMethodKey),

    FOREIGN KEY (PaymentDateKey)
        REFERENCES DimDate(DateKey)

);


show tables;