--display every quarter since the start of 2017 and the average amount of days between ship date and order date
SELECT
ShipYear,
ShipQuarter,
AVG(DaysUntilShipped)
FROM
	(SELECT
		CustomerOrders.CreatedDate,
		Shipments.ShipDate,
		YEAR(Shipments.ShipDate) as ShipYear,
		CASE
			WHEN MONTH(Shipments.ShipDate) BETWEEN 1 and 3 THEN 'Q1'
			WHEN MONTH(Shipments.ShipDate) BETWEEN 4 and 6 THEN 'Q2'
			WHEN MONTH(Shipments.ShipDate) BETWEEN 7 and 9 THEN 'Q3'
			ELSE 'Q4'
		END AS ShipQuarter,
		DATEDIFF(day, CustomerOrders.CreatedDate, Shipments.ShipDate) AS DaysUntilShipped
	FROM Shipments
	INNER JOIN CustomerOrders
	ON Shipments.CONumber = CustomerOrders.CONumber AND Shipments.COLineNumber = CustomerOrders.COLineNumber
	WHERE Shipments.ShipDate BETWEEN '01/01/2017' and '09/30/2022') as s1
GROUP BY ShipYear, ShipQuarter
ORDER BY ShipYear, ShipQuarter

--display new 2022 customers, the associated sales rep, and their resale $
--group by customer AND rep (in case a customer has multiple locations and therefore multiple reps; order by highest resale $
SELECT
	CompanyName, 
	RepName, 
	ROUND(SUM(ResaleTotal),2) AS '2022 Resale Total' 
FROM POSOrders 
WHERE CompanyName IS NOT NULL
		AND CompanyName NOT IN (SELECT DISTINCT CompanyName FROM POSOrders WHERE CompanyName IS NOT NULL AND OrderDate < '01/01/2022')
GROUP BY CompanyName, RepName 
ORDER BY SUM(ResaleTotal) DESC;

--display top 10 San Diego-based customers in terms of average price of items purchased in 2022
--filter for at least 10 unique items bought and for two certain types of brands; filter out US Government as a customer
SELECT TOP 10 
	CompanyName,
	COUNT(DISTINCT ItemNumber) AS 'Unique Items Purchased',
	ROUND(AVG(ResaleUnitPrice),2) AS 'Average Unit Price of Items Purchased'
FROM POSOrders
WHERE ShipToCity = 'SAN DIEGO'
		AND (ItemNumber LIKE 'SF%' OR ItemNumber LIKE '%TD')
		AND CompanyName != 'US GOVERNMENT'
GROUP BY CompanyName
HAVING COUNT(DISTINCT ItemNumber) >= 10
ORDER BY AVG(ResaleUnitPrice) DESC;



