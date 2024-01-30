use classicmodels;

-- Day 3 
-- Question 1
select * from customers;
select customerNumber,customerName,state,creditlimit from customers 
where state is not null having creditlimit between 50000 and 100000 order by creditlimit desc;

-- Question 2

select * from products;
select distinct productline from products where productline like"%cars";

-- Day 4
-- Question 1
select * from orders;
select ordernumber,status,comments, ifnull(comments,"-") from orders where status = "Shipped";

-- Question 2 
select * from employees;
select employeeNumber,firstName,jobTitle,
case 
when jobTitle="President" then "P"
when jobTitle like "%)" then "SM"
when jobTitle="Sales Rep" then "SR"
when jobTitle like "%vp%" then "VP"
end as "JobTitile_Abbrivation" 
from employees;


-- Day 5
-- Question 1
select * from Payments;
select year(paymentDate) as Year,min(amount) as "Min Amount" from payments group by year
order by Year;

-- Question 2
select * from orders;
select * from orderdetails;
SELECT YEAR(orderDate) AS orderYear, CONCAT('Q', QUARTER(orderDate)) AS quarter, 
COUNT(DISTINCT customerNumber) AS uniqueCustomers, 
COUNT(orderNumber) AS totalOrders FROM orders GROUP BY orderYear, quarter ORDER BY orderYear, quarter;

-- Question 3 
select * from payments;
select date_format(paymentDate,'%b') as month, concat(format(sum(amount)/1000,0),'k') as formattedAmount
from payments group by month having sum(amount) between 500000 and 1000000 order by sum(amount) desc;

-- Day6 
-- Question 1
create table journey (Bus_ID int not null,Bus_Name varchar(25) not null,Source_Station varchar(25) not null,
Destination varchar(30) not null, Email varchar(30) unique);
desc journey;

-- Question 2
create table vendor (vendor_Id int primary key,Name varchar(20) not null,Email varchar(30) unique,
Country varchar(25) default "N/A");
desc vendor;

-- Question 3
use classicmodels;
Create table movies(Movie_id int primary key, Name varchar(25) not null, Release_Year int default ("-"),
Cast varchar(25) not null, Gender varchar(15) check(Gender="Male/Female"),No_of_Shows int check(No_of_Shows>0));
desc movies;

-- Question 4 (a)
create table product (product_id int primary key,product_name varchar(25) not null unique,
Description varchar(20),supplier_id int, foreign key(supplier_id) references supplier(supplier_id));
desc product;

-- Question 4 (b)
create table supplier(supplier_id int primary key,supplier_name varchar(25),location varchar(25));
desc supplier;

-- Question 4 (c)

create table Stock(id int primary key,product_id int, foreign key(product_id) references Stock(id),balance_stock int);
desc Stock;

-- Day 7
-- Question 1
select * from employees;
select * from customers;

select employeeNumber,concat(lastname," ", firstname) as "Sales Person",count(employeeNumber) 
as "Unique Customers" from employees join customers 
on employees.employeeNumber = customers.salesRepEmployeeNumber 
group by employeeNumber order by count(employeeNumber) desc;

-- Question 2 (Partially Done)
select * from Customers;
select * from Orders;
select * from orderdetails;
select * from products;

SELECT c.customerNumber AS CustomerNumber, c.customerName AS CustomerName, 
p.productCode AS ProductCode, p.productName AS ProductName, SUM(od.quantityOrdered) AS Ordered_Qty, 
IFNULL(p.quantityInStock, 0) AS Total_inventory, IFNULL(p.quantityInStock - SUM(od.quantityOrdered), 0) AS Left_Qty
 FROM Customers c 
 JOIN Orders o ON c.customerNumber = o.customerNumber 
 JOIN OrderDetails od ON o.orderNumber = od.orderNumber 
 JOIN Products p ON od.productCode = p.productCode 
 LEFT JOIN products s ON p.productCode = s.productCode 
 GROUP BY c.customerNumber, p.productCode ORDER BY c.customerNumber;

-- Question 3
create table Laptop(L_id int primary key ,Laptop_Name varchar(25) not null,
C_id int, foreign key(C_id) references Colours(C_id));
desc Laptop;
insert into Laptop values(1,"DELL",101),(2,"HP",102);
select * from Laptop;
create table Colours(C_id int primary key,Colour_Name varchar(25) not null);
desc Colours;
insert into Colours values(101,"White"),(102,"Silver"),(103,"Black");
select * from Colours;

select Laptop_Name,Colour_Name from Laptop cross join Colours order by Laptop_Name;

-- Question 4
create table Project(Employee_ID int,Full_Name varchar(20) not null,Gender varchar(15),
Manager_Id int);
desc Project;
INSERT INTO Project VALUES(1, 'Pranaya', 'Male', 3);
INSERT INTO Project VALUES(2, 'Priyanka', 'Female', 1);
INSERT INTO Project VALUES(3, 'Preety', 'Female', NULL);
INSERT INTO Project VALUES(4, 'Anurag', 'Male', 1);
INSERT INTO Project VALUES(5, 'Sambit', 'Male', 1);
INSERT INTO Project VALUES(6, 'Rajesh', 'Male', 3);
INSERT INTO Project VALUES(7, 'Hina', 'Female', 3);
select * from Project;

select p.full_name as Manager_Name,e.full_name as Emp_Name from Project as e join Project as p
 on e.manager_id=p.employee_id;
 
 -- Day 8
 drop table faculty;
 create table faculty (Faculty_id int,Name varchar(20),State varchar(25),Country varchar(30));
 desc faculty;
 alter table faculty modify column faculty_id int primary key auto_increment;
 alter table faculty add column City varchar(25) not null after Name;
 
 -- Day 9 
 drop table university;
create table university (id int,Name varchar(70));
INSERT INTO University
VALUES (1, "       Pune          University     "), 
               (2, "  Mumbai          University     "),
              (3, "     Delhi   University     "),
              (4, "Madras University"),
              (5, "Nagpur University");
select * from university;
select Id,trim(Name) as Name from university;
set sql_safe_updates=0; 
UPDATE university SET Name = REPLACE(Name,'','');
use classicmodels;

-- Day 10 
select * from orders;
 CREATE VIEW products_status AS SELECT YEAR(o.orderDate) AS Year, 
 CONCAT( count(od.priceEach), ' (', ROUND((SUM(od.priceEach * od.quantityOrdered) / 
 (SELECT SUM(od2.priceEach * od2.quantityOrdered) FROM OrderDetails od2)) * 100), '%)' ) AS Value 
 FROM Orders o JOIN OrderDetails od ON o.orderNumber = od.orderNumber GROUP BY Year ORDER BY Value desc;
 
 select * from products_status;
 
 
-- Day 11
-- Question 1
select * from customers;
call classicmodels.CustomerLevel();

-- Question 2
select * from Customers;
select * from payments;
call classicmodels.Get_Country_Payments(2003, 'france');

use classicmodels;
-- Day 12
-- Question 1
select year(orderDate) as "Year",monthname(orderDate) as "Month",
count(orderNumber) as "Total Orders",
concat(round(count(orderNumber)-LAG(count(orderNumber),1) over()/
LAG(count(orderNumber),1) over() *100), "%") as "% YoY Change" 
from orders group by year,month;

-- Question 2
create table EMP_UDF (EMP_id int primary key auto_increment, Name varchar(30), DOB Date);
drop table EMP_UDF;
INSERT INTO Emp_UDF(Name, DOB)
VALUES ("Piyush", "1990-03-30"), 
("Aman", "1992-08-15"), 
("Meena", "1998-07-28"), 
("Ketan", "2000-11-21"), 
("Sanjay", "1995-05-21");
select * from EMP_UDF;

DELIMITER //

CREATE FUNCTION calculate_age(date_of_birth DATE) 
RETURNS VARCHAR(50) 
DETERMINISTIC 
BEGIN 
DECLARE years INT; 
DECLARE months INT; 
DECLARE age VARCHAR(50);

SET years = TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE());
SET months = TIMESTAMPDIFF(MONTH, date_of_birth, CURDATE()) % 12;

IF years = 0 THEN
    SET age = CONCAT(months, "months");
ELSEIF months = 0 THEN
    SET age = CONCAT(years, "years");
ELSE
    SET age = CONCAT(years, "years", months, "months");
END IF;

RETURN age;
END //

DELIMITER ;

SELECT Emp_ID,Name, DOB, calculate_age(DOB) AS Age FROM emp_udf;


-- Day 13
-- Question 1
select * from customers;
select * from orders;

select customerNumber,customerName  from customers
where customerNumber not in (select customerNumber from orders);

-- Question 2
select customerNumber, CustomerName,ifNULL(count(orderNumber),0) as "Total Orders" from customers left join orders using(customerNumber)
group by customerNumber,customerName union 
select customerNumber, CustomerName, ifnull(count(orderNumber),0) as "Total Orders" from orders right join customers using(customerNumber)
group by customerNumber,customerName;

-- Question 3
select * from orderdetails;

with OrderedQuantities AS (
select ordernumber, quantityordered,
ROW_NUMBER() OVER (PARTITION BY ordernumber ORDER BY quantityordered DESC) AS rnk from orderdetails)
select ordernumber, quantityordered FROM OrderedQuantities
WHERE rnk = 2;

-- Question 4
SELECT max(ProductCount) AS "MAX(Total)",
min(ProductCount) AS "MIN(Total)"
FROM (SELECT OrderNumber, COUNT(*) AS ProductCount FROM Orderdetails GROUP BY OrderNumber ) AS Counts;

-- Question 5
select * from products;
select ProductLine, COUNT(*) as Total FROM Products 
JOIN (select AVG(BuyPrice) as AvgBuyPrice FROM Products ) AS avg_prices 
ON BuyPrice > avg_prices.AvgBuyPrice GROUP BY ProductLine ORDER BY Total DESC;

-- Day 14
 Create TABLE Emp_EH (EmpID INT PRIMARY KEY, EmpName VARCHAR(255), EmailAddress VARCHAR(255));
 call classicmodels.errorhandlingDay14(1, 'Deepa', 'deepa@gmail.com');
 
 -- Day 15
create table Emp_BIT (Name VARCHAR(25), Occupation VARCHAR(25), Working_date DATE, Working_hours INT);
insert into Emp_BIT values
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);
select * from emp_bit;
insert into Emp_BIT values
('Carol', 'Scientist', '2020-10-04', -12);
