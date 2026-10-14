use FinanceESG_db;
select * from `financeesgtable`;


-- 1-- Company Performance: Top 10 companies by revenue kaun-si hain?
SELECT CompanyName, SUM(Revenue) AS Total_Revenue
FROM financeesgtable
GROUP BY CompanyName
ORDER BY Total_Revenue DESC
LIMIT 10;

-- - Profitability Analysis: Industry-wise average profit margin kitna hai?
SELECT
    Industry,
    AVG(ProfitMargin) AS Avg_Profit_Margin
FROM financeesgtable
GROUP BY Industry
ORDER BY Avg_Profit_Margin DESC;

-- Growth Analysis: Year-wise revenue growth mein kaunsi industry sabse aage hai?
SELECT
    Year,
    SUM(Revenue) AS Total_Revenue
FROM financeesgtable
GROUP BY Year
ORDER BY Year;
-- Market Valuation: Highest MarketCap wali top 10 companies kaun-si hain?
SELECT
    CompanyName,
    SUM(MarketCap) AS Total_MarketCap
FROM financeesgtable
GROUP BY CompanyName
ORDER BY Total_MarketCap DESC
LIMIT 10;
-- Regional Analysis: Region-wise total revenue aur average profit margin kitna hai?
SELECT
    Region,
    SUM(Revenue) AS Total_Revenue,
    AVG(ProfitMargin) AS Avg_Profit_Margin
FROM financeesgtable
GROUP BY Region
ORDER BY Total_Revenue DESC;
-- ESG Performance: Highest ESG_Overall score wali top 10 companies kaun-si hain?
SELECT
    CompanyName,
    AVG(ESG_Overall) AS Avg_ESG_Score
FROM financeesgtable
GROUP BY CompanyName
ORDER BY Avg_ESG_Score DESC
LIMIT 10;
-- Sustainability Analysis: Kaunsi companies ka carbon emissions level sabse zyada hai?
SELECT
    CompanyName,
    SUM(Revenue) AS Total_Revenue,
    AVG(ProfitMargin) AS Avg_Profit_Margin,
    AVG(ESG_Overall) AS Avg_ESG_Score
FROM financeesgtable
GROUP BY CompanyName
ORDER BY Total_Revenue DESC
LIMIT 10;
-- Combined Performance: Kaunsi companies high revenue, high profit margin aur high ESG score achieve kar rahi hain?
WITH CTE AS (
    SELECT
        CompanyName,
        Year,
        SUM(Revenue) AS Revenue,
        LAG(SUM(Revenue)) OVER (
            PARTITION BY CompanyName
            ORDER BY Year
        ) AS Previous_Revenue
    FROM financeesgtable
    GROUP BY CompanyName, Year
)
SELECT
    CompanyName,
    Year,
    Revenue,
    Previous_Revenue,
    ROUND(
        (Revenue - Previous_Revenue) * 100.0 /
        NULLIF(Previous_Revenue, 0), 2
    ) AS Growth_Percentage
FROM CTE
ORDER BY CompanyName, Year;
-- Year-over-Year Analysis: Har company ki revenue growth previous year ke comparison mein kitni hai?
SELECT
    CompanyName,
    Industry,
    AVG(ProfitMargin) AS Company_Margin
FROM financeesgtable
GROUP BY CompanyName, Industry
HAVING AVG(ProfitMargin) > (
    SELECT AVG(F2.ProfitMargin)
    FROM financeesgtable F2
    WHERE F2.Industry = financeesgtable.Industry
)
ORDER BY Company_Margin DESC;


