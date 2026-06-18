Create database Sales;

use sales;

create table market(
ORDERNUMBER int,
QUANTITYORDERED int,
PRICEEACH decimal (10,2),
ORDERLINENUMBER int,
SALES decimal (10,2),
ORDERDATE varchar (100),
STATUS varchar (100),
QTR_ID int,
MONTH_ID int,
YEAR_ID int,
PRODUCTLINE varchar (100),
MSRP int,
PRODUCTCODE varchar (100),
CUSTOMERNAME varchar (100),
PHONE varchar (100),
ADDRESSLINE1 varchar (100),
ADDRESSLINE2 varchar (100),
CITY varchar (100),
STATE varchar (100),
POSTALCODE varchar (100),
COUNTRY varchar (100),
TERRITORY varchar (100),
CONTACTLASTNAME varchar (100),
CONTACTFIRSTNAME varchar (100),
DEALSIZE varchar (100));



select * from sales_data_sample;

select count(*) from sales_data_sample;

--------------------------------------------------------------------
------------------ DATA CLEANING ----------------------------


------------ CREATING A SEPERATE DATASET TABLE FOR CLEANING AND ANALYSIS -----------------

Create table sales_2
like sales_data_sample;


insert sales_2
select *
from sales_data_sample;

Select * from  sales_2;

--------- CONVERT ORDERDATE (TEXT TO DATE TYPE) ----------------

Update sales_2 
set ORDERDATE = str_to_date(ORDERDATE, '%m/%d/%Y %H:%i' );

Alter table sales_2
modify  ORDERDATE DATE;

select ORDERDATE from sales_2
limit 10;

------------------------------------------------------
------------- Exploring The Data Set ------------------


---- Count total rows of all the data set
select count(*) as total_row
 from sales_2;
 
 
----- First 10 rows on the data set
select * from sales_2 
limit 10;

------- ----- Distinct ROWS ---

select distinctrow STATUS 
FROM sales_2;

select distinctrow PRODUCTLINE
FROM sales_2;


select distinctrow DEALSIZE
FROM sales_2;


------------------------------------------------------------------------------
-------------- CORE QUERIES (SELECT, WHERE, ORDERBY) --------------------------

------ ALL Cancelled orders

Select ORDERNUMBER, CUSTOMERNAME, SALES, ORDERDATE
From sales_2 
Where STATUS = 'Cancelled';


------- Orders over $5,000 in Revenue 

Select ORDERNUMBER, CUSTOMERNAME, ORDERDATE, SALES
From sales_2 
Where SALES > 5000
Order by SALES Desc;

----- Large deals only, sorted by sales
Select ORDERNUMBER, CUSTOMERNAME, ORDERDATE, SALES, DEALSIZE 
From sales_2 
Where DEALSIZE = 'Large'
Order by SALES Desc;

--------------- -------------------------------------------------------
------------ AGGREGATES (GROUP BY, HAVING, SUM/AVG/COUNT) ------------

------- Total revenue by product line
select PRODUCTLINE, round(SUM(SALES), 2)  AS TOTAL_REVENUE, count(*) as TOTAL_ORDERS
From sales_2
group by PRODUCTLINE
Order by TOTAL_REVENUE DESC;

------- Revenue by Year

select YEAR_ID, round(SUM(SALES), 2)  AS TOTAL_REVENUE, count(*) as TOTAL_ORDERS
From sales_2
group by YEAR_ID
Order by YEAR_ID DESC;

----- Customers who spent more than $100,000 Total 

select CUSTOMERNAME, count(*) as TOTAL_ORDERS, round(SUM(SALES), 2)  AS TOTAL_REVENUE
From sales_2
Group by CUSTOMERNAME
Having TOTAL_REVENUE > 100000
Order by TOTAL_REVENUE DESC;



---------------------------------------------------------------
--------- Advanced SQL Concepts (SUB QUERIES) --------------------------------

----  1. Top product in each product line

Select PRODUCTLINE, PRODUCTCODE, Round(SUM(SALES), 2) AS TOTAL_SALES
From sales_2
Group by PRODUCTLINE, PRODUCTCODE
Order by  TOTAL_SALES Desc;


Select PRODUCTLINE, PRODUCTCODE, TOTAL_SALES,
Rank () over (partition by PRODUCTLINE
 Order by TOTAL_SALES
DESC) as RNK
FROM
(Select PRODUCTLINE, PRODUCTCODE, Round(SUM(SALES), 2) AS TOTAL_SALES
From sales_2
Group by PRODUCTLINE, PRODUCTCODE) 
Sub;

------- 2. Order above the average order value
Select ORDERNUMBER, CUSTOMERNAME, round(Avg(SALES),2) as Avg_sale
from sales_2
Group by ORDERNUMBER, CUSTOMERNAME
order by Avg_Sale desc;

Select ORDERNUMBER, CUSTOMERNAME, SALES
from sales_2
Where SALES > (Select Avg(SALES) From sales_2)
Order by SALES DESC;


------ 3. Running total of revenue by month in 2004

Select 
	MONTH_ID, Round(sum(SALES), 2) as Monthly_Revenue,
     Sum(Sum(SALES)) Over (Order by MONTH_ID) AS Running_Total  
	From sales_2
	Where YEAR_ID = 2004
    Group by MONTH_ID;

------------------------------------------------------------------
----------- Business Question -------------------------------------

---------- 1. Top-performing products 

Select 
PRODUCTCODE, PRODUCTLINE, Round(SUM(SALES), 2) AS TOTAL_REVENUE,
SUM(QUANTITYORDERED) AS Total_Unit_Solid
from sales_2
Group by PRODUCTCODE, PRODUCTLINE
Order by TOTAL_REVENUE Desc
Limit 10;

----------- OR -------------------------

Select PRODUCTLINE, PRODUCTCODE, TOTAL_SALES, Total_Unit_Solid,
Rank () over (partition by PRODUCTLINE
 Order by TOTAL_SALES
DESC) as RNK
FROM
(Select PRODUCTCODE, PRODUCTLINE, Round(SUM(SALES), 2) AS TOTAL_SALES, SUM(QUANTITYORDERED) AS Total_Unit_Solid
From sales_2
Group by PRODUCTLINE, PRODUCTCODE) 
Sub;
	

------- 2. Top - Performance Customer
Select 
PRODUCTCODE, CUSTOMERNAME, Round(SUM(SALES), 2) AS TOTAL_REVENUE
from sales_2
Group by PRODUCTCODE, CUSTOMERNAME
Order by TOTAL_REVENUE Desc;

-------------- OR ------------------

Select  CUSTOMERNAME, TOTAL_REVENUE,
Rank () over (partition by CUSTOMERNAME
 Order by  TOTAL_REVENUE
DESC) as RNK
FROM
(Select CUSTOMERNAME, Round(SUM(SALES), 2) AS TOTAL_REVENUE
From sales_2
Group by CUSTOMERNAME) 
Sub;

------------ 3. Revenue Trends Over Time

---- Revenue by Year plus Month

Select YEAR_ID, MONTH_ID, Round(Sum(SALES), 2) As Total_Revenue
From sales_2
Group by YEAR_ID, MONTH_ID
Order by YEAR_ID, MONTH_ID Desc;

--------------- 4. Customer Purchasing Behaviour

---- Average order value per customer

Select CUSTOMERNAME,
		Count(distinct ORDERNUMBER) AS Num_Order,
        Round(Sum(SALES), 2) AS Total_spent,
        Round(Sum(SALES)/Count(distinct ORDERNUMBER),2) as Avg_order
        from sales_2
        Group by CUSTOMERNAME
        Order by Avg_order Desc;
        




	
    