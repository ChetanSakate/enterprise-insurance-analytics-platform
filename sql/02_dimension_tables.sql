/*================================================
Dimension: Location
================================================*/

CREATE TABLE DimLocation (

    LocationKey INT AUTO_INCREMENT PRIMARY KEY,

    City VARCHAR(100),

    State VARCHAR(100),

    ZipCode VARCHAR(20)

);


/*================================================
Dimension: Customer
================================================*/

CREATE TABLE DimCustomer (

    CustomerKey INT AUTO_INCREMENT PRIMARY KEY,

    CustomerID VARCHAR(50) NOT NULL,

    CustomerName VARCHAR(255),

    Gender VARCHAR(20),

    Age INT,

    AgeBucket VARCHAR(20),

    Occupation VARCHAR(255),

    MaritalStatus VARCHAR(50),

    LocationKey INT,

    FOREIGN KEY (LocationKey)
    REFERENCES DimLocation(LocationKey)

);


/*================================================
Dimension: Policy
================================================*/

CREATE TABLE DimPolicy (

    PolicyKey INT AUTO_INCREMENT PRIMARY KEY,

    PolicyID VARCHAR(50) NOT NULL,

    PolicyType VARCHAR(50),

    PaymentFrequency VARCHAR(50),

    PolicyStatus VARCHAR(50),

    PolicyDurationCategory VARCHAR(50)

);

/*================================================
Dimension: Risk
================================================*/

CREATE TABLE DimRisk (

    RiskKey INT AUTO_INCREMENT PRIMARY KEY,

    RiskScore INT,

    RiskCategory VARCHAR(50),

    HighRiskFlag VARCHAR(10)

);

/*================================================
Dimension: Date
================================================*/

CREATE TABLE DimDate (

    DateKey INT PRIMARY KEY,

    FullDate DATE,

    DayNumber INT,

    MonthNumber INT,

    MonthName VARCHAR(20),

    QuarterNumber INT,

    YearNumber INT,

    WeekNumber INT

);


SHOW TABLES;


CREATE TABLE DimClaimStatus (

    ClaimStatusKey INT AUTO_INCREMENT PRIMARY KEY,

    ClaimStatus VARCHAR(50) NOT NULL

);


CREATE TABLE DimPaymentStatus (

    PaymentStatusKey INT AUTO_INCREMENT PRIMARY KEY,

    PaymentStatus VARCHAR(50) NOT NULL

);


CREATE TABLE DimPaymentMethod (

    PaymentMethodKey INT AUTO_INCREMENT PRIMARY KEY,

    PaymentMethod VARCHAR(50) NOT NULL

);

SHOW TABLES;