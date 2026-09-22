create database Pharmaceutical_Supply_Chain;
use Pharmaceutical_Supply_Chain;

#Total Demand
SELECT SUM(Demand_Forecast) AS Total_Demand
FROM supply_data;

#Total Stock
SELECT SUM(Optimal_Stock_Level) AS Total_Stock
FROM supply_data;

#Understock vs Overstock Count
SELECT Stock_Status, COUNT(*) AS Count
FROM supply_data
GROUP BY Stock_Status;

#Top Understocked Drugs
SELECT Drug, Stock_Difference
FROM supply_data
WHERE Stock_Difference < 0
ORDER BY Stock_Difference ASC
LIMIT 10;

#Strategy Performance
SELECT Restocking_Strategy,
       COUNT(*) AS Total_Items,
       SUM(CASE WHEN Stock_Status = 'Understock' THEN 1 ELSE 0 END) AS Understock_Count
FROM supply_data
GROUP BY Restocking_Strategy;

#Average Demand
SELECT AVG(Demand_Forecast) AS Avg_Demand
FROM supply_data;

#MAX and MIN
SELECT 
    MIN(Demand_Forecast) AS Min_Demand,
    MAX(Demand_Forecast) AS Max_Demand
FROM supply_data;

#Total Understock Quantity
SELECT SUM(ABS(Stock_Difference)) AS Total_Understock_Units
FROM supply_data
WHERE Stock_Difference < 0;

#Total Overstock Quantity
SELECT SUM(Stock_Difference) AS Total_Overstock_Units
FROM supply_data
WHERE Stock_Difference > 0;

#% of Understock vs Overstock
SELECT 
    Stock_Status,
    Concat(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM supply_data),'%') AS Percentage
FROM supply_data
GROUP BY Stock_Status;

#Top 5 Most Critical Drugs (Highest Shortage)
SELECT Drug, Stock_Difference
FROM supply_data
WHERE Stock_Difference < 0
ORDER BY Stock_Difference ASC
LIMIT 5;

#Top 5 Overstocked Drugs
SELECT Drug, Stock_Difference
FROM supply_data
WHERE Stock_Difference > 0
ORDER BY Stock_Difference DESC
LIMIT 5;

#Drugs Close to Optimal (Perfect Planning)
SELECT Drug, Stock_Difference
FROM supply_data
WHERE ABS(Stock_Difference) < 10;

#Which Strategy Has More Risk?
SELECT 
    Restocking_Strategy,
    COUNT(*) AS Total_Drugs,
    SUM(CASE WHEN Stock_Status = 'Understock' THEN 1 ELSE 0 END) AS Understock_Count,
    CONCAT(ROUND(
        SUM(CASE WHEN Stock_Status = 'Understock' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 
        2
    ), '%') AS Understock_Percentage
FROM supply_data
GROUP BY Restocking_Strategy;

#Average Stock Difference by Strategy
SELECT 
    Restocking_Strategy,
    AVG(Stock_Difference) AS Avg_Stock_Difference
FROM supply_data
GROUP BY Restocking_Strategy;

#High Demand but Low Stock (CRITICAL)
SELECT Drug, Demand_Forecast, Optimal_Stock_Level
FROM supply_data
WHERE Demand_Forecast > Optimal_Stock_Level
ORDER BY Demand_Forecast DESC;

#Low Demand but High Stock (WASTE)
SELECT Drug, Demand_Forecast, Optimal_Stock_Level
FROM supply_data
WHERE Optimal_Stock_Level > Demand_Forecast
ORDER BY Optimal_Stock_Level DESC;

#Demand Bucketing
SELECT 
    CASE 
        WHEN Demand_Forecast < 50 THEN 'Low Demand'
        WHEN Demand_Forecast BETWEEN 50 AND 100 THEN 'Medium Demand'
        ELSE 'High Demand'
    END AS Demand_Category,
    COUNT(*) AS Count
FROM supply_data
GROUP BY Demand_Category;

#Stock Difference Bucketing
SELECT 
    CASE 
        WHEN Stock_Difference < -50 THEN 'High Shortage'
        WHEN Stock_Difference BETWEEN -50 AND 0 THEN 'Low Shortage'
        WHEN Stock_Difference BETWEEN 0 AND 50 THEN 'Low Overstock'
        ELSE 'High Overstock'
    END AS Stock_Category,
    COUNT(*) AS Count
FROM supply_data
GROUP BY Stock_Category;

#Rank Drugs by Demand
SELECT 
    Drug,
    Demand_Forecast,
    DENSE_RANK() OVER (ORDER BY Demand_Forecast DESC) AS Demand_Rank
FROM supply_data;

#Rank by Shortage Severity
SELECT 
    Drug,
    Stock_Difference,
    DENSE_RANK() OVER (ORDER BY Stock_Difference ASC) AS Shortage_Rank
FROM supply_data;

#Combined Business Insight Query
SELECT 
    Drug,
    Demand_Forecast,
    Optimal_Stock_Level,
    Stock_Difference,
    CASE 
        WHEN Stock_Difference < 0 THEN 'Reorder Immediately'
        WHEN Stock_Difference BETWEEN 0 AND 20 THEN 'Monitor'
        ELSE 'Excess Stock'
    END AS Action
FROM supply_data;