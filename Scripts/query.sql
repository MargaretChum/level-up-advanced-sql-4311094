select*from employee;

select*from model limit 5;

SELECT sql
FROM sqlite_schema;

--#Challenge 1.1
SELECT e.employeeId,e.firstName, e.lastName, e.title, m.firstName AS Manager_FirstName, e.lastName AS Manager_LastName
FROM employee e
INNER JOIN employee m on e.managerId = m.employeeId;

--#Challenge 1.2- Find sales people who have zero sales
Select * from sales
WHERE customerId is null;

SELECT DISTINCT e.employeeID, e.firstName, e.lastName, s.salesAmount, s.salesID
FROM employee e
LEFT JOIN sales s ON e.employeeId = s.employeeId
WHERE e.title = 'Sales Person'
AND s.salesID IS NULL;

--#Challeneg 1.3- list of sales and customer even if data has been removed

SELECT DISTINCT cus.firstName, cus.lastName, cus.email
FROM customer cus;

SELECT *
FROM sales
WHERE customerId = 0;

--#To check duplicate items
SELECT cus.firstName, cus.lastName, cus.email, COUNT(*) AS duplicate_count
FROM customer cus
GROUP BY cus.firstName, cus.lastName, cus.email
HAVING COUNT(*) > 1;

--Customer with orders
SELECT DISTINCT cus.firstName, cus.lastName, cus.email,s.salesAmount
FROM customer cus
JOIN sales s ON cus.customerId = s.customerId 
UNION
--Customer without order
SELECT cus.firstName, cus.lastName,cus.email,s.salesAmount
FROM customer cus
LEFT JOIN sales s ON cus.customerId = s.customerId 
WHERE s.salesId is NULL
UNION
--sales without customer information
SELECT cus.firstName, cus.lastName, cus.email,s.salesAmount
FROM sales s
LEFT JOIN customer cus ON cus.customerId = s.customerId 
WHERE s.customerID = 0;

--Challenge 2.1: sum the total of cars
SELECT e.firstName, e.lastName, count(*)as NumberOfCarSold
FROM Sales s
JOIN employee e ON s.employeeId = e.employeeId
GROUP BY e.firstName, e.lastName
ORDER BY NumberOfCarSold DESC;

--Challenge 2.2: list the least and most expensive car sold by each employee this year
SELECT e.firstName,e.lastName,min(s.salesAmount)AS least_price, max(s.salesAmount) AS most_expensive_price,s.soldDate
FROM Sales s
JOIN employee e on s.employeeId = e.employeeId
WHERE Date(s.soldDate) >= '2023-01-01'
GROUP BY e.firstName,e.lastName;

--Challenge 3.1: showing total sales per year
WITH ByYear AS (SELECT salesAmount,strftime('%Y',soldDate) AS soldYear
FROM sales)

SELECT soldYear, FORMAT('$%.2f', sum(salesAmount)) AS AnnualSales
FROM ByYear
GROUP BY soldYear
ORDER BY soldYear;

SELECT strftime('%Y',soldDate) AS sold_Year, 
FORMAT('$%.2f', sum(salesAmount)) AS Annual_Sales
FROM sales
GROUP BY sold_Year
ORDER BY sold_Year;

--Challenge 3.2- display the amount of sales per employee for each month in 2021
-- For Each Year
SELECT e.firstName,e.lastName,sum(salesAmount) AS AnnualSales
FROM Sales s
JOIN employee e on s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
GROUP BY e.firstName,e.lastName
ORDER BY AnnualSales DESC;

-- For each month
SELECT e.firstName,e.lastName,strftime('%m', s.soldDate)AS Month_2021,sum(s.salesAmount) AS monthlySales
FROM Sales s
JOIN employee e on s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
GROUP BY e.firstName,e.lastName,strftime('%m', s.soldDate);

-- For each month with a table in horzional (CASE)
-- 1. get the needed data
SELECT e.firstName,e.lastName,s.soldDate,s.salesAmount
FROM Sales s
JOIN employee e on s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
ORDER BY strftime('%m', s.soldDate) DESC;

-- 2. Make use of CASE statement for each month (Pivot the data)
SELECT e.firstName, e.lastName,
  CASE WHEN strftime('%m', s.soldDate) = '01' THEN s.salesAmount END AS JanSales,
  CASE WHEN strftime('%m', s.soldDate) = '02' THEN s.salesAmount END AS FebSales,   
  CASE WHEN strftime('%m', s.soldDate) = '03' THEN s.salesAmount END AS MarSales,
  CASE WHEN strftime('%m', s.soldDate) = '04' THEN s.salesAmount END AS AprSales,
  CASE WHEN strftime('%m', s.soldDate) = '05' THEN s.salesAmount END AS MaySales,
  CASE WHEN strftime('%m', s.soldDate) = '06' THEN s.salesAmount END AS JunSales,
  CASE WHEN strftime('%m', s.soldDate) = '07' THEN s.salesAmount END AS JulSales,
  CASE WHEN strftime('%m', s.soldDate) = '08' THEN s.salesAmount END AS AugSales,   
  CASE WHEN strftime('%m', s.soldDate) = '09' THEN s.salesAmount END AS SepSales,
  CASE WHEN strftime('%m', s.soldDate) = '10' THEN s.salesAmount END AS OctSales,
  CASE WHEN strftime('%m', s.soldDate) = '11' THEN s.salesAmount END AS NovSales,
  CASE WHEN strftime('%m', s.soldDate) = '12' THEN s.salesAmount END AS DecSales
FROM Sales s
JOIN employee e ON s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
ORDER BY e.lastName, e.firstName;

-- 3. sum by name (Pivot the data)
SELECT e.firstName, e.lastName,
  sum(CASE WHEN strftime('%m', s.soldDate) = '01' THEN s.salesAmount END) AS JanSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '02' THEN s.salesAmount END) AS FebSales,   
  sum(CASE WHEN strftime('%m', s.soldDate) = '03' THEN s.salesAmount END) AS MarSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '04' THEN s.salesAmount END) AS AprSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '05' THEN s.salesAmount END) AS MaySales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '06' THEN s.salesAmount END) AS JunSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '07' THEN s.salesAmount END) AS JulSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '08' THEN s.salesAmount END) AS AugSales,   
  sum(CASE WHEN strftime('%m', s.soldDate) = '09' THEN s.salesAmount END) AS SepSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '10' THEN s.salesAmount END) AS OctSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '11' THEN s.salesAmount END) AS NovSales,
  sum(CASE WHEN strftime('%m', s.soldDate) = '12' THEN s.salesAmount END) AS DecSales
FROM Sales s
JOIN employee e ON s.employeeId = e.employeeId
WHERE strftime('%Y', s.soldDate) = '2021'
GROUP BY e.lastName, e.firstName
ORDER BY e.lastName, e.firstName;

-- challenge 3.3- Sales where care purchased was electric
-- inventory ID with electric
Select modelID 
FROM model
WHERE EngineType = 'Electric';

-- Sales with electric
SELECT *,i.modelID
FROM sales s
JOIN inventory i ON s.inventoryID = i.inventoryId
WHERE i.modelID IN 
  (Select modelID 
  FROM model
  WHERE EngineType = 'Electric');

-- Only one model ID
SELECT *,i.modelID
FROM sales s
JOIN inventory i ON s.inventoryID = i.inventoryId
WHERE i.modelID = 
  (Select modelID 
  FROM model
  WHERE EngineType = 'Electric');

--Windows function
--Challenge 4.1- list of sales people and rank the car model they've sold the most
-- list of sales people
SELECT *
FROM employee
WHERE title = 'Sales Person';

--car model sold most
SELECT e.firstName, e.lastName, m.model, COUNT(m.model) AS NumberSold,
rank()OVER(PARTITION BY s.employeeId ORDER BY COUNT(m.model) desc) AS Rank
FROM sales s
JOIN employee e ON s.employeeId = e.employeeId
JOIN inventory i ON s.inventoryId = i.inventoryId
JOIN model m ON i.modelId = m.modelId
GROUP BY e.lastName, e.firstName, m.model;

SELECT e.firstName, e.lastName, m.model, COUNT(m.model) AS NumberSold,
rank()OVER( ORDER BY COUNT(m.model) desc) AS Rank
FROM sales s
JOIN employee e ON s.employeeId = e.employeeId
JOIN inventory i ON s.inventoryId = i.inventoryId
JOIN model m ON i.modelId = m.modelId
GROUP BY e.lastName, e.firstName, m.model;

--Challenge 4.2- Table showing total sales per month and Annual running total
-- BY month sales
SELECT 
  strftime('%Y',soldDate) AS soldYear,
  strftime('%m',soldDate) AS soldMonth, 
  format('$%.2f',sum(salesAmount))AS salesAmount
FROM sales
GROUP BY soldYear,soldMonth
ORDER BY soldYear DESC,soldMonth DESC;

--Add total annual sales
WITH monthlySales AS(
  SELECT 
  strftime('%Y',soldDate) AS soldYear,
  strftime('%m',soldDate) AS soldMonth, 
  sum(salesAmount)AS salesAmount
  FROM sales
  GROUP BY soldYear,soldMonth) 
SELECT 
  soldYear, 
  soldMonth,
  salesAmount,
  SUM(salesAmount) OVER(
  PARTITION BY soldYear ORDER BY soldYear, soldMonth) AS AnnualSalesAmount
FROM monthlySales
ORDER BY soldYear DESC,soldMonth DESC

-- Challenge 4.3 report showing the number of car sold this month and last month
--current month
SELECT strftime('%Y- %m', soldDate) AS monthSold, count(*) AS numberOfCarSold
FROM SALES
GROUP BY strftime('%Y -%m',soldDate)

-- Add previous month car sold
SELECT 
  strftime('%Y- %m', soldDate) AS monthSold, 
  count(*) AS numberOfCarSold,
  LAG(count(*),1,0) over(ORDER BY strftime('%Y- %m', soldDate)) AS lastMonthSold
FROM SALES
GROUP BY strftime('%Y -%m',soldDate)
ORDER BY strftime('%Y -%m',soldDate);

with soldDif AS
 (SELECT 
  strftime('%Y- %m', soldDate) AS monthSold, 
  count(*) AS numberOfCarSold,
  LAG(count(*),1,0) over(ORDER BY strftime('%Y- %m', soldDate)) AS lastMonthSold
  FROM SALES
  GROUP BY strftime('%Y -%m',soldDate)
  ORDER BY strftime('%Y -%m',soldDate))
SELECT monthSold,numberOfCarSold,lastMonthSold, numberOfCarSold-lastMonthSold AS difference_carSold
FROM soldDif



