select*from employee;

select*from model limit 5;

SELECT sql
FROM sqlite_schema;

#Challenge 1.1
SELECT e.employeeId,e.firstName, e.lastName, e.title, m.firstName AS Manager_FirstName, e.lastName AS Manager_LastName
FROM employee e
INNER JOIN employee m on e.managerId = m.employeeId;

#Challenge 1.2- Find sales people who have zero sales
Select * from sales
WHERE customerId is null;

SELECT DISTINCT e.employeeID, e.firstName, e.lastName, s.salesAmount, s.salesID
FROM employee e
LEFT JOIN sales s ON e.employeeId = s.employeeId
WHERE e.title = 'Sales Person'
AND s.salesID IS NULL;

#Challeneg 1.3- list of sales and customer even if data has been removed

SELECT DISTINCT cus.firstName, cus.lastName, cus.email
FROM customer cus;

SELECT *
FROM sales
WHERE customerId = 0;

#To check duplicate items
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
