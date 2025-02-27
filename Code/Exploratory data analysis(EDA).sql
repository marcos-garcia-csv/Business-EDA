USE Northwind;

#Exploratory Data Analysis (EDA)

#Listing top 10 most expensive products
SELECT ProductName AS Product_Name,
       price AS Price
FROM   products
ORDER  BY price DESC
LIMIT  10; 

#Retrieving all orders placed by customers.
SELECT     customers.customername         AS Customer_Name,
           Count(DISTINCT orders.orderid) AS Total_Orders
FROM       customers
INNER JOIN orders
ON         customers.customerid = orders.customerid
INNER JOIN orderdetails
ON         orders.orderid = orderdetails.orderid
GROUP BY   customers.customername
ORDER BY total_orders DESC;

#Total revenue per month in the year 1996
SELECT
  MONTHNAME(orders.OrderDate) as Month, 
  SUM(orderdetails.Quantity * products.Price)  AS Total_Revenue
from 
  orders 
  INNER JOIN orderdetails on orders.OrderID = orderdetails.OrderID 
  INNER JOIN products on orderdetails.ProductID = products.ProductID
WHERE YEAR(orders.OrderDate) = 1996
GROUP BY 
  MONTHNAME(orders.OrderDate),MONTH(orders.OrderDate)
ORDER BY
  MONTH(orders.OrderDate);
  
#Listing Products between 50 and 100
SELECT productname AS Product_Name,
       price AS Price
FROM   products
WHERE Price BETWEEN 50 and 100
ORDER  BY price DESC;

#Showing the most recent 20 orders
SELECT date_format(orderdate,"%Y-%m-%d") as Date, 
COUNT(orderid) AS Orders
FROM orders 
GROUP BY orderdate
ORDER BY orderdate desc limit 20;

# Average Price of all products
SELECT ROUND(AVG(Price),2) as Average_Price
FROM products;

#Showing Sales by Categories
SELECT categories.categoryName AS Category,
SUM(orderdetails.quantity * products.Price) as Sales
FROM categories
left JOIN products on categories.categoryID = products.categoryID
left JOIN orderdetails on products.ProductID = orderdetails.ProductID
GROUP BY Category
ORDER BY Sales DESC;

#Total revenue by Supplier
SELECT suppliers.SupplierName AS Supplier,
SUM(orderdetails.quantity * products.Price) as Sales
FROM suppliers
LEFT JOIN products on suppliers.SupplierID = products.SupplierID
LEFT JOIN orderdetails on products.ProductID = orderdetails.ProductID
GROUP BY Supplier
ORDER BY Sales DESC;

#Total Orders by Employee
SELECT concat(employees.FirstName," ",employees.LastName) as Employee_Name,
COUNT(DISTINCT(orders.orderID)) as Total_Orders
FROM employees
LEFT JOIN orders on employees.EmployeeID = orders.EmployeeID
LEFT JOIN orderdetails on orders.OrderID = orderdetails.OrderID
GROUP BY Employee_Name
ORDER BY Total_Orders DESC;

#Displaying customer who have placed more than five orders
SELECT  customers.customername as Name,
count(DISTINCT(orderdetails.orderID)) as Total_Orders
FROM customers
left join orders on customers.CustomerID = orders.CustomerID
left join orderdetails on orders.OrderID = orderdetails.OrderID
GROUP BY Name
HAVING Total_Orders >= 5
ORDER BY Total_Orders DESC;

#Showing order by Product
SELECT products.ProductName,
count(DISTINCT(orderdetails.OrderID)) as Total_Orders
FROM products
left join orderdetails on products.productid = orderdetails.productid
group by products.ProductName
order by Total_Orders DESC;

#Get products that have were ordered only once.
SELECT ProductName 
FROM Products 
WHERE Productid IN (
	SELECT ProductID 
	FROM Orderdetails 
	GROUP BY ProductID
	HAVING COUNT(OrderID) = 1 
	ORDER BY COUNT(OrderID) DESC
);

#Creating a view for employee performance based on orders handled
CREATE VIEW Employee_Performance AS 
SELECT CONCAT(Employees.FirstName," ",Employees.LastName) as Employee_Name,
COUNT(DISTINCT(Orders.OrderID)) as Total_Orders
FROM Employees
LEFT JOIN Orders on Employees.EmployeeID = Orders.EmployeeID
LEFT JOIN Orderdetails on Orders.OrderID = Orderdetails.OrderID
GROUP BY Employee_Name
ORDER BY Total_Orders DESC;

#Creating a view for customer order history.
CREATE VIEW CustomerOrderHistory AS
SELECT
	customers.CustomerName,
    Orders.OrderID,
    Orders.OrderDate,
    Shippers.Shippername,
    CONCAT(Employees.FirstName," ",Employees.LastName) as Employee_Name,
    SUM(Products.Price * Orderdetails.Quantity) as Total_Sales
FROM Orders
LEFT JOIN Customers ON Orders.customerID = Customers.Customerid
LEFT JOIN Orderdetails ON Orders.Orderid = Orderdetails.Orderid
LEFT JOIN Products ON Orderdetails.Productid = Products.Productid
LEFT JOIN Shippers ON Orders.ShipperID = Shippers.Shipperid
LEFT JOIN Employees ON Orders.Employeeid = Employees.Employeeid
GROUP BY Orders.OrderID;

