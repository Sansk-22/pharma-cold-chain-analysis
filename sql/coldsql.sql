CREATE DATABASE pharma_cold_chain;
USE pharma_cold_chain;


CREATE TABLE shipments (
    Shipment_ID          VARCHAR(20),
    Product              VARCHAR(50),
    Route                VARCHAR(50),
    Vendor               VARCHAR(50),
    Dispatch_Timestamp   DATETIME,
    Delivery_Timestamp   DATETIME,
    Transit_Hours        INT,
    Avg_Temperature_C    DECIMAL(5,2),
    Max_Temperature_C    DECIMAL(5,2),
    Min_Temperature_C    DECIMAL(5,2),
    Breach_Hours         INT,
    Batch_Value_Lakhs    DECIMAL(10,2),
    Destination          VARCHAR(50),
    Compliance_Status    VARCHAR(20),
    Num_Temp_Readings    INT,
    Month                INT,
    Month_Name           VARCHAR(15),
    Season               VARCHAR(15),
    Value_At_Risk        DECIMAL(10,2)
);
SELECT COUNT(*) FROM shipments;   -- expect 485
DESCRIBE shipments;

SELECT 
    Route,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS total_value_at_risk_lakhs
FROM shipments
GROUP BY Route
ORDER BY failure_rate_pct DESC;

SELECT 
    Vendor, 
    Route,
    COUNT(*) AS shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS total_value_at_risk_lakhs
FROM shipments
GROUP BY Vendor, Route
HAVING COUNT(*) >= 5
ORDER BY failure_rate_pct DESC
LIMIT 10;

SELECT 
    Month,
    Month_Name,
    Season,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS monthly_value_at_risk_lakhs
FROM shipments
GROUP BY Month, Month_Name, Season
ORDER BY Month;

SELECT 
    Product,
    COUNT(*) AS total_shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS total_value_at_risk_lakhs,
    ROUND(AVG(Batch_Value_Lakhs), 2) AS avg_batch_value_lakhs
FROM shipments
GROUP BY Product
ORDER BY total_value_at_risk_lakhs DESC;

SELECT 
    Vendor,
    Month,
    monthly_shipments,
    monthly_failure_rate,
    ROUND(AVG(monthly_failure_rate) OVER (
        PARTITION BY Vendor 
        ORDER BY Month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3month_avg_failure_rate
FROM (
    SELECT 
        Vendor,
        Month,
        COUNT(*) AS monthly_shipments,
        ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS monthly_failure_rate
    FROM shipments
    GROUP BY Vendor, Month
) AS monthly_stats
ORDER BY Vendor, Month;

SELECT 
    Vendor,
    Month,
    monthly_shipments,
    monthly_failure_rate,
    ROUND(AVG(monthly_failure_rate) OVER (
        PARTITION BY Vendor 
        ORDER BY Month 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS rolling_3month_avg_failure_rate
FROM (
    SELECT 
        Vendor,
        Month,
        COUNT(*) AS monthly_shipments,
        ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS monthly_failure_rate
    FROM shipments
    GROUP BY Vendor, Month
) AS monthly_stats
WHERE Vendor = 'ColdEx Logistics'
ORDER BY Month;

SELECT 
    Vendor,
    Product,
    Season,
    COUNT(*) AS shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS value_at_risk_lakhs
FROM shipments
GROUP BY Vendor, Product, Season
HAVING COUNT(*) >= 4
ORDER BY failure_rate_pct DESC
LIMIT 15;

SELECT 
    Vendor,
    Season,
    COUNT(*) AS shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS value_at_risk_lakhs
FROM shipments
GROUP BY Vendor, Season
ORDER BY Vendor, 
    CASE Season 
        WHEN 'Winter' THEN 1 
        WHEN 'Summer' THEN 2 
        WHEN 'Monsoon' THEN 3 
        WHEN 'Post-Monsoon' THEN 4 
    END;
    
    SELECT 
    Product,
    Vendor,
    Season,
    COUNT(*) AS shipments,
    SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) AS failures,
    ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct,
    ROUND(SUM(Value_At_Risk), 2) AS value_at_risk_lakhs
FROM shipments
GROUP BY Product, Vendor, Season
HAVING COUNT(*) >= 5
ORDER BY failure_rate_pct DESC;

SELECT 
    Vendor, Route, failure_rate_pct,
    RANK() OVER (ORDER BY failure_rate_pct DESC) AS risk_rank
FROM (
    SELECT 
        Vendor, Route,
        ROUND(100.0 * SUM(CASE WHEN Compliance_Status = 'Non-Compliant' THEN 1 ELSE 0 END) / COUNT(*), 2) AS failure_rate_pct
    FROM shipments
    GROUP BY Vendor, Route
    HAVING COUNT(*) >= 5
) t;