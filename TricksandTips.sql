
--Here are some practice queries using various tricks and ways of doing something-----

Select *
From HumanResources.Employee
Where JobTitle In('Tool Designer', 'Marketing Specialist')
and Gender In('M')
or
OrganizationLevel In('4')

--Use IN for an = and make a list instead of writing each item out.

Select *
From HumanResources.Employee
Where JobTitle In('Tool Designer', 'Marketing Specialist')
and (Gender = 'M'
or
OrganizationLevel In('4'))

--Use parenthesis to alter how the WHERE statements breaks down and/or---

Select * 
From Person.Person
Where PersonType = 'EM'
and Title is not null
or (MiddleName is null and LastName = 'Scott')


--BETWEEN for values within a range----

Select SalesOrderID, AccountNumber, CustomerID, TotalDue
From Sales.SalesOrderHeader
Where TotalDue Between 25000 and 30000
--<= 30000 and TotalDue >= 20000
Order by TotalDue

Select OrderDate, SubTotal, TaxAmt, Freight, TotalDue
From Purchasing.PurchaseOrderHeader
Where TotalDue > 50000
and Freight < 1000

Select OrderDate, SubTotal, TaxAmt, Freight, TotalDue
From Purchasing.PurchaseOrderHeader
Where SubTotal Between 10000 and 30000
order by TotalDue



--Wildcards with Strings--

Select *
From Person.Person
Where FirstName like 'Tom%'
and LastName like 'Bl%'

--Names starting with a or b or c ending in anything--

Select *
From Person.Person
Where Firstname like '[abcdefg]%'
--or a range of [a-g]%
Order by Firstname


Select *
From HumanResources.Employee
Where JobTitle not like '%[0-3]%'


Select *
From Person.Person
Where FirstName like '%.'
and MiddleName is not null
Order by 1 desc



Select OrganizationLevel as [Organization Level], JobTitle as [Job Title], VacationHours as [Vacation Hours], SickLeaveHours as [Sick Leave Hours]
From HumanResources.Employee
Order by 1, 3 desc


--Concatenate cells together, splitting by spaces--

Select 
(Case
	When MiddleName is not null THEN Concat(FirstName, ' ', MiddleName, ' ', LastName)
	When Middlename is null THEN Concat(FirstName, ' ', LastName)
	End) as [Full Name]
From Person.Person

Select Concat(FirstName, ' ', LastName, ' - ', PersonType)
From Person.Person
Order by 1


--Using math in queries --

Select SalesYTD * CommissionPct as Commissionytd
From Sales.SalesPerson

Select (SalesYTD * CommissionPct + Bonus) as IncomeYTD
From Sales.SalesPerson

--Multiply a whole integer value by 1.0 to get a decimal value out of it--

Select SafetyStockLevel, ReorderPoint, ReorderPoint / (SafetyStockLevel * 1.0)
From Production.Product



Select BusinessEntityID, VacationHours, SickLeaveHours,
SickLeaveHours + VacationHours as [Total Time Off],
((SickLeaveHours + VacationHours)  * 1.0) / 8 as [Total Days Off]
From HumanResources.Employee
Where SalariedFlag = 0
Order by [Total Time Off] desc



--Left and Right-----


Select PhoneNumber,
	Left(PhoneNumber, 3) as AreaCode
From Person.PersonPhone
Where PhoneNumber not Like '%()%'
and LEN(PhoneNumber) = 12

Select AccountNumber, 
Right(AccountNumber, 5) as QuickNum
From Sales.SalesOrderHeader

Select CardNumber, right(CardNumber, 4) as LastFour
From Sales.CreditCard

Select EmailAddress, Len(EmailAddress) - 20 as EmailIdLength,
Left(EmailAddress, Len(EmailAddress) - 20) as EmailId
From Person.EmailAddress
Order by EmailIdLength desc

Select NationalIDNumber, Len(NationalIDNumber),
Right('0000000000' + NationalIDNumber, 10) as PaddedID
From HumanResources.Employee

--Replace------


Select EmailAddress, Replace(EmailAddress, 'adventure-works', 'hotmail') as HotmailAddresses
From Person.EmailAddress

Select Description,
Replace(Replace(Description, ',', ''), '.', '')
From Production.ProductDescription 

Select ReviewerName, Comments, Replace(Replace(Comments, '.', ''), ',', '')
From Production.ProductReview

Select FirstName,LastName
From Person.Person
Where LEN(LastName) > 10
Order by LEN(LastName)


--Selecting very specific dates and date ranges--

Select getdate()


Select Datefromparts(2002,1,28)

Select OrderDate, SalesOrderID, Status, Year(OrderDate) as OrderYear
From sales.SalesOrderHeader
Where OrderDate between Datefromparts(2013,1,1) and DATEFROMPARTS(2014,1,1)

Select OrderDate, Year(OrderDate) as year
From sales.SalesOrderHeader
Where Year(OrderDate) = 2013

Select Year(Getdate()), Month(Getdate()), Day(Getdate())

Select DATEFROMPARTS(Year(Getdate()), Month(Getdate()), 5)

Select Day(Getdate()) as Today, Month(Getdate()) as ThisMonth, Year(Getdate()) as ThisYear

Select PurchaseOrderID, OrderDate, TotalDue
From Purchasing.PurchaseOrderHeader
Where OrderDate Between DATEFROMPARTS(2011,1,1) and DATEFROMPARTS(2011,7,31)
and TotalDue > 10000

--In the past week...--

Select Getdate() - 7
From Purchasing.PurchaseOrderHeader

Select getdate() as CurrentDate,
DATEFROMPARTS(Year(getdate()), Month(Getdate()), 1) as FirstofMonth,
DATEADD(month, -1, DATEFROMPARTS(Year(getdate()), Month(Getdate()), 1)) as FirstDayPrevMonth,
DATEADD(Day, -1, DATEFROMPARTS(Year(getdate()), Month(Getdate()), 1)) as LastDayPrevMonth


----Time between...-------

Select OrderDate, ShipDate, Datediff(Day, OrderDate, ShipDate) as DayDifference
From Sales.SalesOrderHeader

Select OrderDate, ShipDate, Datediff(Month, OrderDate, ShipDate)
From Sales.SalesOrderHeader


--100 days from today--

Select Dateadd(Day, +100, Datefromparts(Year(Getdate()), Month(Getdate()), Day(getdate())))

Select Dateadd(Month, +6, DATEFROMPARTS(Year(getdate()), Month(Getdate()), Day(getdate())))

--How many days until the last day of the year (2023)--

Select Datediff(Day, Getdate(), Dateadd(Day, -1, Datefromparts(2024,1,1)))

 
 --Data types!----

 Select TotalDue, Cast(TotalDue as int) as TruncatedDue
 From Sales.SalesOrderHeader

 Select OrderDate
 From Sales.SalesOrderHeader
 Where OrderDate >= Year(GETDATE()) - 2 
 Order by 1

 Select Cast(123 as int)
Select Cast('2020-01-01' as Date)

--Converting datetime to date and calculating yesterday's date-----

Select 
Cast(Dateadd(Day, -1, getdate()) as Date)

Select Title, FirstName, MiddleName, LastName, Suffix, Concat(PersonType, '-', BusinessEntityID) as PersonID
From Person.Person
Where MiddleName is not null 
and (Title is not null OR Suffix is not null)


--NULL values--- Replacing NUll for a string or int---


Select Title, FirstName, MiddleName, LastName, isnull(Title, 'No Title') as ModifiedTitle 
From Person.Person


Select *
From Sales.SalesPerson
Where ISNULL(SalesQuota, 0) != 250000

Select Name, Isnull(Color, 'None') as ModifiedColor, Isnull(Weight, 0) as ModifiedWeight
From Production.Product
Where ISNULL(Weight, 0) < 10
Order by Weight


-----Case statements--------


Select Case
		When 1 = 2 Then 'A'
		When 3 < 2 Then 'B'
		Else 'D'
		End as FirstCase



Select JobTitle,
Case
When JobTitle Like '%President%' Then 'President'
When JobTitle Like '%Manager%' Then 'Manager'
When JobTitle Like '%Production%' Then 'Production'
Else 'Other'
End as JobCategory
From HumanResources.Employee
Order by JobCategory

Select OrderDate,
Cast('07-31-2013' as Date) as CurrentDate,
--DateDiff(Day, OrderDate, Cast('07-31-2013' as Date)) as ElapsedDate,
Case
	When DateDiff(Day, OrderDate, Cast('07-31-2013' as Date)) < 10 THEN '< 10 Days'
	When DateDiff(Day, OrderDate, Cast('07-31-2013' as Date)) Between 10 and 19 THEN '10 - 19 Days'
	Else '20 or more days'
	End AS PriorityOrder
From Sales.SalesOrderHeader
Where OrderDate Between Cast('07-01-2013' as Date) AND Cast('07-31-2013' as Date)


Select Name, ISNULL(ListPrice, 0) as ItemPrice,
Case
	When ListPrice > 1000 Then 'Premium'
	When ListPrice Between 100 and 10000 Then 'Mid-Range'
	Else 'Value'
	End as PriceCategory
From Production.Product
Order by ItemPrice desc



Select BusinessEntityID, Hiredate, SalariedFlag, CAST(Getdate() as Date) as Today,
Case
	When SalariedFlag = 1 AND Datediff(Year, CAST(HireDate as Date), Getdate()) >= 10 Then 'Non-Exempt: 10+ Years'
	When SalariedFlag = 1 AND Datediff(Year, CAST(HireDate as Date), Getdate()) < 10 Then 'Non-Exempt: < 10 Years'
	When SalariedFlag = 0 AND Datediff(Year, CAST(HireDate as Date), Getdate()) >= 10 Then 'Exempt: 10+ Years'
	Else 'Exempt: < 10 Years'
	END as [Employee Tenure]
From HumanResources.Employee


--Combining Data from other sources -----
--Union to stack into one column. Unique values only for Union. Must also have equal no.s of select columns. Cannot mix value types (int, varchar, etc)---------

Select SalesOrderID, 'Customer Order' as OrderType,
Cast(OrderDate as Date) as OrderDates,
Cast(TotalDue as int) TotalDue
From Sales.SalesOrderHeader
Where Year(OrderDate) = 2013

Union

Select PurchaseOrderID, 'Vendor Order' as OrderType,
Cast(OrderDate as Date) as OrderDates,
Cast(TotalDue as int) TotalDue
From Purchasing.PurchaseOrderHeader
Where Year(OrderDate) = 2013

--


Select
Cast(OrderDate as Date) as OrderDates
From Sales.SalesOrderHeader
Where Year(OrderDate) = 2013

Union All  --All will return ALL records, not unique only---

Select 
Cast(OrderDate as Date) as OrderDates
From Purchasing.PurchaseOrderHeader
Where Year(OrderDate) = 2013



----------JOINs-------------------------------------
--Just putting 'join' is an inner join. it will only display matching results, nothing more, not ALL data

Select B.FirstName, B.LastName, B.PersonType, A.[TerritoryID], A.[SalesQuota], A.[Bonus], A.[CommissionPct], A.[SalesYTD], A.[SalesLastYear]
From Sales.SalesPerson as A
Join Person.Person as B
On A.BusinessEntityID = B.BusinessEntityID

Select A.FirstName, A.LastName, B.EmailAddress
From Person.Person as A
Join Person.EmailAddress as B
On A.BusinessEntityID = B.BusinessEntityID


Select A.Name, A.ListPrice, B.Rating
From Production.Product as A
Join Production.ProductReview as B
On A.ProductID = B.ProductID

------Joining 3 tables into one. 

Select C.Name, C.[Group], B.FirstName, B.LastName, B.PersonType, A.[TerritoryID], A.[SalesQuota], A.[Bonus], A.[CommissionPct], A.[SalesYTD], A.[SalesLastYear]
From Sales.SalesPerson as A
Join Person.Person as B
On A.BusinessEntityID = B.BusinessEntityID
Join Sales.SalesTerritory as C
On A.TerritoryID = C.TerritoryID


Select A.FirstName, A.LastName, B.EmailAddress, C.PhoneNumber, Left(C.PhoneNumber, 3) as AreaCode, E.City
From Person.Person as A
Join Person.EmailAddress as B
On A.BusinessEntityID = B.BusinessEntityID
Join Person.PersonPhone as C
On B.BusinessEntityID = C.BusinessEntityID
Join Person.BusinessEntityAddress as D
On D.BusinessEntityID = C.BusinessEntityID
Join Person.Address as E
On E.AddressID = D.AddressID
Where PhoneNumber like '206%'

----Outer Left----
--Yields data with *any matching* data


Select A.BusinessEntityID, A.FirstName, A.LastName, B.Jobtitle, B.VacationHours, B.SickLeaveHours,
C.EmailAddress
From Person.Person as A
Left Outer Join HumanResources.Employee as B
On B.BusinessEntityID = A.BusinessEntityID
and B.VacationHours > 50                 --Put here instead of Where. Gets rid of all nulls if put in Where, after the Inner Join
Join Person.EmailAddress as C
On C.BusinessEntityID = A.BusinessEntityID     --Notice the 'on' sequencing
Where A.FirstName = 'John'
Order by A.BusinessEntityID


Select A.BusinessEntityID, A.SalesQuota, Cast(A.SalesYTD as int), B.Name as TerritoryName
From Sales.SalesPerson as A
Left Join Sales.SalesTerritory as B
On A.TerritoryID = B.TerritoryID
Where A.SalesYTD < 2000000


--Coding challenges involving all concepts above--
--Chal 1

Select 
Case
	When A.OrderQty > 500 Then 'Large'
	When A.OrderQty > 50 and A.OrderQty <= 500 Then 'Medium' 
	Else 'Small'
	End  as OrderSizeCategory,
A.PurchaseOrderID, A.PurchaseOrderDetailID, A.OrderQty, A.UnitPrice, A.LineTotal, 
Cast(B.OrderDate as Date) as OrderDate, 
C.Name as ProductName,
IsNull(D.Name,'None') as Subcategory,
IsNull(E.Name,'None') as Category

From Purchasing.PurchaseOrderDetail as A
Join Purchasing.PurchaseOrderHeader as B
on A.PurchaseOrderID = B.PurchaseOrderID
Join Production.Product as C
on A.ProductID = C.ProductID
Left Join Production.ProductSubcategory as D
On C.ProductSubcategoryID = D.ProductSubcategoryID
Left Join Production.ProductCategory as E
On D.ProductCategoryID = E.ProductCategoryID

Where Month(B.OrderDate) = 12
Order By B.OrderDate

-------------------------
------------Chal 2--------------------------------------------------------------

Select 'Sale' as OrderType,
Case
	When A.OrderQty > 500 Then 'Large'
	When A.OrderQty > 50 and A.OrderQty <= 500 Then 'Medium' 
	Else 'Small'
	End  as OrderSizeCategory,
A.SalesOrderID as OrderID, A.SalesOrderDetailID as OrderDetailID, A.OrderQty, A.UnitPrice, Cast(A.LineTotal as int) as LineTotal, 
Cast(B.OrderDate as Date) as OrderDate, 
C.Name as ProductName,
IsNull(D.Name,'None') as Subcategory,
IsNull(E.Name,'None') as Category

From Sales.SalesOrderDetail as A
Join Sales.SalesOrderHeader as B
on A.SalesOrderID = B.SalesOrderID
Join Production.Product as C
on A.ProductID = C.ProductID
Left Join Production.ProductSubcategory as D
On C.ProductSubcategoryID = D.ProductSubcategoryID
Left Join Production.ProductCategory as E
On D.ProductCategoryID = E.ProductCategoryID

Where Month(B.OrderDate) = 12

UNION

Select 'Purchase' as OrderType,
Case
	When A.OrderQty > 500 Then 'Large'
	When A.OrderQty > 50 and A.OrderQty <= 500 Then 'Medium' 
	Else 'Small'
	End  as OrderSizeCategory,
A.PurchaseOrderID, A.PurchaseOrderDetailID, A.OrderQty, A.UnitPrice, A.LineTotal, 
Cast(B.OrderDate as Date) as OrderDate, 
C.Name as ProductName,
IsNull(D.Name,'None') as Subcategory,
IsNull(E.Name,'None') as Category

From Purchasing.PurchaseOrderDetail as A
Join Purchasing.PurchaseOrderHeader as B
on A.PurchaseOrderID = B.PurchaseOrderID
Join Production.Product as C
on A.ProductID = C.ProductID
Left Join Production.ProductSubcategory as D
On C.ProductSubcategoryID = D.ProductSubcategoryID
Left Join Production.ProductCategory as E
On D.ProductCategoryID = E.ProductCategoryID

Where Month(B.OrderDate) = 12

Order by OrderDate desc

---------------------Why did that work????? ^
--Chal 3-----------------------------------------

Select A.BusinessEntityID, A.PersonType, 
	Case
		When MiddleName is not null then CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
		Else CONCAT(FirstName, ' ', LastName)
		End as [Full Name],
C.AddressLine1 as Address, C.City, C.PostalCode,
D.Name as State, 
E.Name as Country

From Person.Person as A
Join Person.BusinessEntityAddress as B
On A.BusinessEntityID = B.BusinessEntityID
Join Person.Address as C
On B.AddressID = C.AddressID
Join Person.StateProvince as D
On C.StateProvinceID = D.StateProvinceID
Join Person.CountryRegion as E
On D.CountryRegionCode = E.CountryRegionCode

Where PersonType = 'SP' 
OR 
(Left(PostalCode, 1) = '9' -------PostalCode like '9%', same thing
AND LEN(PostalCode) = 5 
AND E.Name = 'United States')


------Chal 4-------------------------------------------


Select A.BusinessEntityID, A.PersonType, 
	Case
		When MiddleName is not null then CONCAT(FirstName, ' ', MiddleName, ' ', LastName)
		Else CONCAT(FirstName, ' ', LastName)
		End as [Full Name],
--ISNULL(F.JobTitle, 'N/A') as JobTitle,
	Case
		When F.JobTitle like '%Manager%' Then 'Management'
		When F.JobTitle like '%President%' Then 'Management'
		When F.JobTitle like '%Executive%' Then 'Management'
		When F.JobTitle like '%Engineer%' Then 'Engineering'
		When F.JobTitle like '%Production%' Then 'Production'
		When F.JobTitle like '%Marketing%' Then 'Marketing'
		When F.JobTitle IN( 'Recruiter', 'Benefits Specialist', 'Human Resources Administrative Assistant') Then 'Human Resources'
		When F.JobTitle is null then 'N/A'
		Else 'Other'
		End as JobCategory,
C.AddressLine1 as Address, C.City, C.PostalCode,
D.Name as State, 
E.Name as Country

From Person.Person as A
Join Person.BusinessEntityAddress as B
On A.BusinessEntityID = B.BusinessEntityID
Join Person.Address as C
On B.AddressID = C.AddressID
Join Person.StateProvince as D
On C.StateProvinceID = D.StateProvinceID
Join Person.CountryRegion as E
On D.CountryRegionCode = E.CountryRegionCode
Left Join HumanResources.Employee as F
On A.BusinessEntityID = F.BusinessEntityID

Where PersonType = 'SP' 
OR 
(Left(PostalCode, 1) = '9' -------PostalCode like '9%', same thing
AND LEN(PostalCode) = 5 
AND E.Name = 'United States')

Order by JobCategory


--------------------------------------------------------
---Aggregate functions



Select Count(*)
From Sales.SalesOrderHeader
Where TotalDue > 10000

Select Sum(TotalDue)    --Min(TotalDue)
From Sales.SalesOrderHeader
Where OnlineOrderFlag = 1

Select Avg(TotalDue)  
From Sales.SalesOrderHeader
Where OnlineOrderFlag = 1




Select Distinct JobTitle, Count(*) as NumOfEmployees   --Or even Sum(VacationHours) to see the vacation hours for each job title
From HumanResources.Employee
Group by JobTitle
Order by NumOfEmployees desc

Select JobTitle, Gender, Sum(VacationHours) as VacationTime
From HumanResources.Employee
Group by JobTitle, Gender
Order by VacationTime desc                  --So, Male Production Technician-WC40s have the most collective vacation over everyone else


Select LastName, Count(*)
From Person.Person
Group by LastName
Having Count(*) > 1               --'Having' is like 'Where' but when used with aggregates like Count in this case when they are grouped




----------------------------------------------------------------
----------------------------------------------------------------
--More advanced queries

--Over()------ (a window function)


Select a.BusinessEntityID, a.TerritoryID, a.SalesQuota, a.Bonus, a.CommissionPct, a.SalesYTD, 
Sum(cast(a.SalesYTD as int)) Over() as TotalYearSales,
b.JobTitle, b.Gender
From Sales.SalesPerson as a
Join HumanResources.Employee as b
on a.BusinessEntityID = b.BusinessEntityID
Order by b.Gender


Select BusinessEntityID, TerritoryID, SalesQuota, Bonus, CommissionPct, SalesYTD, 
Sum(cast(SalesYTD as int)) Over() as TotalYearSales, Max(Cast(SalesYTD as int)) Over() as YTDMax,
SalesYTD/Max(SalesYTD) Over() as PercentBestSales
From Sales.SalesPerson


Select --a.FirstName, a.LastName,          --I ended up just using this to calculate the Rate average and max for each job title
b.Jobtitle,
--c.Rate,
Avg(Rate) as AverageRate,
Max(Rate) as HighestRate
From Person.Person as a
Join HumanResources.Employee as b
on a.BusinessEntityID = b.BusinessEntityID
Join HumanResources.EmployeePayHistory as c
on b.BusinessEntityID = c.BusinessEntityID
Group by 
b.Jobtitle
Order by AverageRate


Select a.FirstName, a.LastName,       
b.Jobtitle,
c.Rate,
Avg(c.Rate) Over() as AverageRate,
Max(c.Rate) Over() as HighestRate,
c.Rate-Avg(c.Rate) Over() as DiffFromAvgRate,
c.Rate/Max(c.Rate) Over()*100  as PercentOfHighestRate
From Person.Person as a
Join HumanResources.Employee as b
on a.BusinessEntityID = b.BusinessEntityID
Join HumanResources.EmployeePayHistory as c
on b.BusinessEntityID = c.BusinessEntityID


--------Partition by


Select ProductID, OrderQty,
Sum(LineTotal) as Linetotal
From Sales.SalesOrderDetail
Group by ProductID, OrderQty
order by 1, 2 desc

-- PARTITION BY is used to group the rows by two columns - ProductID and OrderQty

Select ProductID, SalesOrderID, SalesOrderDetailID, OrderQty, UnitPrice, UnitPriceDiscount, LineTotal,
Sum(LineTotal) Over(Partition by ProductID, OrderQTY) as ProductIDLineTotal
From Sales.SalesOrderDetail
order by 1, 4 desc


Select
a.Name as ProductName, a.ListPrice,
b.Name as ProductSubcategory,
c.Name as ProductCategory, Avg(a.ListPrice) Over(Partition by c.Name) as AvgPriceByCategory,
Avg(a.ListPrice) Over(Partition by b.Name, c.Name) as AvgPriceByCategoryAndSubcategory,
a.ListPrice-AVG(a.ListPrice) Over(Partition by c.Name) as ProductVsCategoryDelta
From 
Production.Product as a
Join Production.ProductSubcategory as b
on a.ProductSubcategoryID = b.ProductSubcategoryID
Join Production.ProductCategory as c
on b.ProductCategoryID = c.ProductCategoryID

--------------------------------------------Ranking with Partition by


Select SalesOrderID, SalesOrderDetailID, LineTotal,
Sum(LineTotal) Over(Partition by SalesOrderID) as ProductIDLineTotal,
ROW_NUMBER() Over(Partition by SalesOrderID Order by LineTotal desc) as Ranking
From [Sales].[SalesOrderDetail]


Select
a.Name as ProductName, a.ListPrice,
b.Name as ProductSubcategory,
c.Name as ProductCategory,
ROW_NUMBER() Over(Order by a.ListPrice desc) as PriceRank,  ---Putting rank by listprice and ordering by that too
ROW_NUMBER() Over(Partition by c.Name Order by a.ListPrice desc) as CategoryPriceRank,  --Ranking by listprice in that category
Case	
	When ROW_NUMBER() Over(Partition by c.Name Order by a.ListPrice desc) <= 5 Then 'Yes'
	Else 'No'
	End as Top5PriceInCategory
From 
Production.Product as a
Join Production.ProductSubcategory as b
on a.ProductSubcategoryID = b.ProductSubcategoryID
Join Production.ProductCategory as c
on b.ProductCategoryID = c.ProductCategoryID



--------Rank and Dense Rank---------

Select SalesOrderID, SalesOrderDetailID, LineTotal,
ROW_NUMBER() Over(Partition by SalesOrderID Order by LineTotal desc) as Ranking
--RANK() Over(Partition by SalesOrderID Order by LineTotal desc) as RankingWRank
From [Sales].[SalesOrderDetail]

Select SalesOrderID, SalesOrderDetailID, LineTotal,
ROW_NUMBER() Over(Partition by SalesOrderID Order by LineTotal desc) as Ranking,
RANK() Over(Partition by SalesOrderID Order by LineTotal desc) as RankingWRank,           -- 3 rank systems that are a bit different. Dense allows ties in rank.
DENSE_RANK() Over(Partition by SalesOrderID Order by LineTotal desc) as RankingWDenseRank
From [Sales].[SalesOrderDetail]


Select
a.Name as ProductName, a.ListPrice,
b.Name as ProductSubcategory,
c.Name as ProductCategory,
ROW_NUMBER() Over(Order by a.ListPrice desc) as PriceRank,  ---Putting rank by listprice and ordering by that too
ROW_NUMBER() Over(Partition by c.Name Order by a.ListPrice desc) as CategoryPriceRank,  --Ranking by listprice in that category
RANK() Over(Partition by c.Name Order by a.ListPrice desc) as CategoryPriceRankWRank,
DENSE_RANK() Over(Partition by c.Name Order by a.ListPrice desc) as CategoryPriceRankWDenseRank,
Case	
	When ROW_NUMBER() Over(Partition by c.Name Order by a.ListPrice desc) <= 5 Then 'Yes'
	When DENSE_RANK() Over(Partition by C.Name Order by a.ListPrice desc) <= 5 Then 'Yes'
	Else 'No'
	End as Top5PriceInCategory
From 
Production.Product as a
Join Production.ProductSubcategory as b
on a.ProductSubcategoryID = b.ProductSubcategoryID
Join Production.ProductCategory as c
on b.ProductCategoryID = c.ProductCategoryID


--------------Lead and Lag

Select 
SalesOrderID, OrderDate, CustomerID, TotalDue,       
Lead(TotalDue, 1) Over(Order by SalesOrderID)         --Lead is selecting the NEXT item in totaldue, by 1 record
From [Sales].[SalesOrderHeader]
Order by SalesOrderID

Select 
SalesOrderID, OrderDate, CustomerID, TotalDue,       
Lag(TotalDue, 1) Over(Order by SalesOrderID)  as LastOrderDue       --LAG is selecting the NEXT item in totaldue, by 1 record
From [Sales].[SalesOrderHeader]
Order by SalesOrderID


Select 
SalesOrderID, OrderDate, CustomerID, TotalDue,
Lead(TotalDue, 1) Over(Partition by CustomerID Order by SalesOrderID) as NextOrderDue,
Lag(TotalDue, 1) Over(Partition by CustomerID Order by SalesOrderID) as LastOrderDue       --Shows next/last due for each customerID
From [Sales].[SalesOrderHeader]
Order by  CustomerID, SalesOrderID



Select 
a.PurchaseOrderID, a.OrderDate, a.TotalDue,
b.Name as VendorName,
Lag(a.TotalDue, 1) Over(Partition by a.VendorID Order by a.OrderDate) as PrevOrderFromVendorAmt
From 
Purchasing.PurchaseOrderHeader as a
Join Purchasing.Vendor as b
on a.VendorID = b.BusinessEntityID
Where 
a.OrderDate >= 2013
and a.TotalDue > 500
Order by
A.VendorID, a.OrderDate

Select 
a.PurchaseOrderID, Cast(a.OrderDate as date) as OrderDate, a.TotalDue,
b.Name as VendorName,
Lag(a.TotalDue, 1) Over(Partition by b.Name Order by a.OrderDate) as PrevOrderFromVendorAmt,
Lead(b.Name, 1) Over(Partition by a.EmployeeID Order by a.OrderDate) as NextOrderByEmployeeVendor,
Lead(b.Name, 2) Over(Partition by a.EmployeeID Order by a.OrderDate) as Next2OrderByEmployeeVendor
From 
Purchasing.PurchaseOrderHeader as a
Join Purchasing.Vendor as b
on a.VendorID = b.BusinessEntityID
Where 
a.OrderDate >= 2013
and a.TotalDue > 500
Order by
A.VendorID, a.OrderDate


-----------------------Subqueries-------

Select *
From
(
Select SalesOrderID, SalesOrderDetailID, LineTotal,
ROW_NUMBER() Over(Partition by SalesOrderID Order by LineTotal desc) as Ranking
From [Sales].[SalesOrderDetail]
) as A
Where Ranking = 1



Select
PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue, OrderTotalbyVendor, DenseRank

From
(
Select PurchaseOrderID, VendorID, OrderDate, TaxAmt, Freight, TotalDue,
ROW_NUMBER() Over(Partition by VendorID Order by TotalDue desc) as OrderTotalbyVendor
,Rank() Over(Order by TotalDue desc) as DenseRank
From Purchasing.PurchaseOrderHeader
) as a

Where DenseRank <= 3



Select *
From
(
Select PurchaseOrderID, VendorID, Cast(OrderDate as Date) as OrderDate, TaxAmt, Freight, TotalDue,
Dense_Rank() Over(Partition by VendorID Order by TotalDue desc) as RankOrderTotalbyVendor
From Purchasing.PurchaseOrderHeader
) as a
Where RankOrderTotalbyVendor <= 3




------------------------Other ways to subquery

--Difference from average listprice, showing only results that are greater than the average listprice

Select 
ProductID, Name, StandardCost, ListPrice, (Select(Avg(ListPrice)) From Production.Product) as AveragePrice,
ListPrice-((Select(Avg(ListPrice)) From Production.Product)) as DiffFromAvg
From 
Production.Product
Where
ListPrice >= (Select(Avg(ListPrice)) From Production.Product)
Order by ListPrice desc


Select 
BusinessEntityID, JobTitle, VacationHours,
(Select Max(VacationHours) From HumanResources.Employee) as MostVacationHrs,
(VacationHours * 1.0)/(Select Max(VacationHours) From HumanResources.Employee) as PercOfMaxHrs
From 
HumanResources.Employee
Where
(VacationHours * 1.0)/(Select Max(VacationHours) From HumanResources.Employee) >= 0.8
Order by
PercOfMaxHrs desc


-------------Correlated Subqueries

Select 
SalesOrderID, OrderDate, SubTotal, TaxAmt, Freight, TotalDue, 
	(Select Count(*)
	From Sales.SalesOrderDetail as b
	Where b.SalesOrderID = a.SalesOrderID
	and b.OrderQty > 1) as MultiOrderCount
From 
Sales.SalesOrderHeader as a


Select 
PurchaseOrderID, VendorID, OrderDate, TotalDue,
	(Select Count(*) 
	From Purchasing.PurchaseOrderDetail as b
	Where a.PurchaseOrderID = b.PurchaseOrderID) as  NonRejectedItems,

	(Select Max(b.UnitPrice)
	From Purchasing.PurchaseOrderDetail as b
	Where a.PurchaseOrderID = b.PurchaseOrderID) as MostExpensiveItem
From 
Purchasing.PurchaseOrderHeader as a 


----------------Using EXIST to pick only records we want

--If you need to see all matches from the many side of the relationship, you should probably stick with a joint. 
--If, on the other hand, you only want one record and your output per each match from the one side of the relationship stick with exists.

Select                                     --Use exists only when you want to apply criteria  to field from a second table, but dont need them shown
a.SalesOrderID, a.OrderDate, a.TotalDue        
From 
Sales.SalesOrderHeader as a
Where
	Exists(
	Select 1 
	From Sales.SalesOrderDetail as b
	Where b.LineTotal > 10000
	And a.SalesOrderID = b.SalesOrderID)
Order by 1


Select 
*	
From 
Purchasing.PurchaseOrderHeader as a                             
Where 
	Exists 
	(
	Select 1
	From Purchasing.PurchaseOrderDetail as b
	Where b.OrderQty > 500
	And b.UnitPrice > 50.00
	And b.RejectedQty < 1
	And a.PurchaseOrderID = b.PurchaseOrderID
	)
Order by 1


Select *
From Purchasing.PurchaseOrderDetail
Where RejectedQty < 1



---------------------------------------------FOR XML PATH

Select
STUFF(

	(Select ',', Cast(Cast(LineTotal as money)as varchar)          --XML PATH puts results into a single cell and then it was separated by commas
	From Sales.SalesOrderDetail A
	Where A.SalesOrderID = 43659
	FOR XML PATH ('')
	),
	1,1,'')


Select
SalesOrderID, OrderDate, SubTotal, TaxAmt, Freight, TotalDue,
Linetotals = 
	STUFF(
	(
	Select ', ', Cast(Cast(LineTotal as money)as varchar)         
	From Sales.SalesOrderDetail as B
	Where A.SalesOrderID = B.SalesOrderID
	FOR XML PATH ('')
	),
	1,1,'')
From Sales.SalesOrderHeader as A



Select *, 
SubcategoryName = a.Name, Products =              --This query displays an xml line as Products that lists all products under the subcategory, or subcatID
	STUFF(
	(
	Select ': ', Cast(b.Name as varchar)
	From Production.Product as b
	Where a.ProductSubcategoryID = b.ProductSubcategoryID
	FOR XML PATH ('')
	),
	1,1,'')
From Production.ProductSubcategory as a



Select *, 
SubcategoryName = a.Name, Products =              --Similarly, shows same products in the list, but only if they're $50+
	STUFF(
	(
	Select ': ', Cast(b.Name as varchar)
	From Production.Product as b
	Where a.ProductSubcategoryID = b.ProductSubcategoryID
	and b.ListPrice > 50
	FOR XML PATH ('')
	),
	1,1,'')
From Production.ProductSubcategory as a

-----------------------------------------------------PIVOT
Select 
*     ---The * takes from the pivot IN(...)
From
	(
	Select
	ProductCatName = D.Name,
	A.LineTotal,
	A.OrderQty
	From
	Sales.SalesOrderDetail as A
	JOIN Production.Product as B
	On A.ProductID = B.ProductID
	JOIN Production.ProductSubcategory as C
	On B.ProductSubcategoryID = C.ProductSubcategoryID
	JOIN Production.ProductCategory as D
	On C.ProductCategoryID = D.ProductCategoryID
	) as A
PIVOT     
(
SUM(LineTotal)
FOR ProductCatName IN(Accessories, Bikes, Clothing, Components)
) as B
Order by OrderQty



Select
EmployeeGender = Gender, [Sales Representative],Buyer,Janitor
From
	(Select JobTitle, Gender, VacationHours               
	From HumanResources.Employee) as a
PIVOT                                                   ----This Pivot table will show the average vaca hours for sales rep, buyer, janitor by gender
(
avg(VacationHours)
For JobTitle IN([Sales Representative],Buyer,Janitor)
) as PivotData


-------------------------------------CTE, Common Table Expressions

WITH Sales AS
	(
		Select 
		OrderDate, TotalDue, OrderMonth = DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1),
		OrderRank = ROW_NUMBER() Over(Partition by DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1) Order by TotalDue DESC)
		From
		Sales.SalesOrderHeader
	), 
Top10 As 
	(
		Select
		OrderMonth, Top10Total = Sum(TotalDue)
		From
		Sales
		Where OrderRank <= 10
		Group By OrderMonth
	)                                                 ----This CTE replaces the jumbled mess below
Select A.OrderMonth, A.Top10Total,
PrevTop10Total = B.Top10Total
From Top10 as a
	Left Join Top10 as B
	On A.OrderMonth = Dateadd(Month,1,B.OrderMonth) 
Order by 1
	

/*

Select A.OrderMonth, A.Top10Total,
PrevTop10Total = B.Top10Total
From
	(
	Select
	OrderMonth, Top10Total = Sum(TotalDue)
	From
	(
		Select 
		OrderDate, TotalDue, OrderMonth = DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1),
		OrderRank = ROW_NUMBER() Over(Partition by DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1) Order by TotalDue DESC)
		From
		Sales.SalesOrderHeader
	) as X
	Where OrderRank <= 10
	Group By OrderMonth
	) as A
Left JOIN
	(
	Select
	OrderMonth, Top10Total = Sum(TotalDue)
	From
	(
		Select 
		OrderDate, TotalDue, OrderMonth = DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1),
		OrderRank = ROW_NUMBER() Over(Partition by DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1) Order by TotalDue DESC)
		From
		Sales.SalesOrderHeader
	) as B
Where OrderRank <= 10
Group By OrderMonth
) as B On A.OrderMonth = Dateadd(Month,1,B.OrderMonth) 
Order by OrderMonth
*/

--------------------------------------------Another example of CTE below

/* SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases

FROM (
	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) S
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) A

JOIN (
	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) P
	WHERE OrderRank > 10
	GROUP BY OrderMonth
) B	ON A.OrderMonth = B.OrderMonth

ORDER BY 1
*/
----------------------------Instead of all of this, use this below. CTE--------



With TotalSalesByMonth as
	(
	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	FROM (
		SELECT 
		   Cast(OrderDate as Date) as OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) as Sales
	WHERE OrderRank > 10
	GROUP BY OrderMonth
	),
TotalPurchByMonth as
	(
	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) as Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth
	)
SELECT
A.OrderMonth,
A.TotalSales,
B.TotalPurchases
From
TotalSalesByMonth as A
Inner Join TotalPurchByMonth as B
On A.OrderMonth = B.OrderMonth
Order by 1

 -----------------------------------Recursion    
                
With DateSeries As
(
Select Cast('01-01-2021' as Date) as MyDate    --<-- anchor member and then a Union all. Then the recursive member that calls the anchor 

Union all

Select Dateadd(Day,1,MyDate)
From DateSeries
Where MyDate < Cast('12-31-2021' as Date) 
)
Select MyDate
From DateSeries
Option(maxrecursion 365)



With OddNumbers as                    --------Generates a list of odd numbers up to 99
(
Select 1 as OddNum

Union all

Select OddNum + 2
From OddNumbers
Where OddNum < 99
)
Select OddNum
From OddNumbers


With MonthList as                    
(
Select Cast('01-01-2023' as Date) as Dates               ------This recursion lists the months until end of year, 2023

Union all

Select DateAdd(Month,1,Dates)
From MonthList
Where Dates < Cast('12-01-2023' as Date)
)
Select Dates
From MonthList


-----------------------------------------Temp Tables

Select 
OrderDate, TotalDue, OrderMonth = DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1),
OrderRank = ROW_NUMBER() Over(Partition by DATEFROMPARTS(Year(OrderDate),Month(OrderDate),1) Order by TotalDue DESC)

INTO #Sales                --<-- the #Sales is what the temp tables is called, ignore the 'From' below it. Thats just for the select above it 
From
Sales.SalesOrderHeader	


--Another temp table made below--

Select
OrderMonth, Top10Total = Sum(TotalDue)
INTO #Top10Sales
From
#Sales
Where OrderRank <= 10
Group By OrderMonth

Select * From #Top10Sales


Select A.OrderMonth, A.Top10Total,
PrevTop10Total = B.Top10Total
From #Top10Sales as a
	Left Join #Top10Sales as B
	On A.OrderMonth = Dateadd(Month,1,B.OrderMonth) 
Order by 1

Select * 
From #Sales
Where OrderRank <= 5

Drop Table #Sales
Drop Table #Top10Sales                  --May often want to drop temp tables at the end, they take up memory



------Temp table excercise ---


	SELECT
	OrderMonth,
	TotalSales = SUM(TotalDue)
	Into #TotalSalesByMonth          -----Making #TotalSalesByMonth
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Sales.SalesOrderHeader
		) as Sales
	WHERE OrderRank > 10
	GROUP BY OrderMonth


	SELECT
	OrderMonth,
	TotalPurchases = SUM(TotalDue)
	Into #TotalPurchByMonth          -----Making #TotalPurchByMonth
	FROM (
		SELECT 
		   OrderDate
		  ,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
		  ,TotalDue
		  ,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
		FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader
		) as Purchases
	WHERE OrderRank > 10
	GROUP BY OrderMonth

SELECT                            -----Calling the temp tables in final query
A.OrderMonth,
A.TotalSales,
B.TotalPurchases
From
#TotalSalesByMonth as A
Inner Join #TotalPurchByMonth as B
On A.OrderMonth = B.OrderMonth
Order by 1

Drop table #TotalSalesByMonth
Drop table #TotalPurchByMonth

-------------------------------------------------Create and Insert

Create table #Sales
(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
)

INSERT INTO #Sales
(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank 
)
SELECT
 OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader

Select *
From #Sales

Drop table #Sales

----------------------------next example below

Create table #Top10Sales
(
	OrderMonth Date,
	Top10total Money
)

Insert into #Top10Sales
(
	OrderMonth, Top10total
)
Select
OrderMonth, Top10Total = Sum(TotalDue)
From
#Sales
Where OrderRank <= 10
Group By OrderMonth


Select A.OrderMonth, A.Top10Total,
PrevTop10Total = B.Top10Total             
From #Top10Sales as a
	Left Join #Top10Sales as B
	On A.OrderMonth = Dateadd(Month,1,B.OrderMonth) 
Order by 1

Select * 
From #Sales
Where OrderRank <= 5


------------------------------------Truncate
								-------------Truncate deletes data from a table, but not the table itself.
Create table #Orders
(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
)


Insert into #Orders
(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank 
)
Select 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader

Select * 
FROM #Orders

Create Table #Top10Orders
(
OrderMonth Date,
OrderType varchar(32),
Top10Total Money
)

Insert Into #Top10Orders
(
OrderMonth,
OrderType,
Top10Total
)
Select
OrderMonth,
OrderType = 'Sales',
Top10Total = Sum(TotalDue)
From #Orders
Where OrderRank <= 10
Group by OrderMonth

Select * 
From #Top10Orders

Truncate Table #Orders


 Insert into #Orders
(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank
)
SELECT 
	OrderDate
	,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
	,TotalDue
	,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
	FROM AdventureWorks2019.Purchasing.PurchaseOrderHeader

Select *
From #Orders

-------------------------Another example of truncate

Create table #Sales
(
	OrderDate Date,
	OrderMonth Date,
	TotalDue Money,
	OrderRank int
)
INSERT INTO #Sales
(
	OrderDate,
	OrderMonth,
	TotalDue,
	OrderRank 
)
SELECT
 OrderDate
,OrderMonth = DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1)
,TotalDue
,OrderRank = ROW_NUMBER() OVER(PARTITION BY DATEFROMPARTS(YEAR(OrderDate),MONTH(OrderDate),1) ORDER BY TotalDue DESC)
FROM AdventureWorks2019.Sales.SalesOrderHeader

Select *
From #Sales

Truncate table #Sales


--

Create table #Top10Sales
(
	OrderMonth Date,
	Top10total Money
)

Insert into #Top10Sales
(
	OrderMonth, Top10total
)
Select
OrderMonth, Top10Total = Sum(TotalDue)
From
#Sales
Where OrderRank <= 10
Group By OrderMonth


Select A.OrderMonth, A.Top10Total,
PrevTop10Total = B.Top10Total             
From #Top10Sales as a
	Left Join #Top10Sales as B
	On A.OrderMonth = Dateadd(Month,1,B.OrderMonth) 
Order by 1

Select * 
From #Sales
Where OrderRank <= 5


---------------------------------Update function

Create Table #SalesOrders
(
SalesOrderID int,
OrderDate Date,
TaxAmt Money,
Freight Money,
TotalDue Money,
TaxFreightPercent Float,
TaxFreightBucket Varchar(32),
OrderAmtBucket Varchar(32),
OrderCategory Varchar(32),
OrderSubcategory Varchar(32)
)

Insert into #SalesOrders
(
SalesOrderID,
OrderDate,
TaxAmt,
Freight,
TotalDue,
OrderCategory
)
Select
SalesOrderID,
OrderDate,
TaxAmt,
Freight,
TotalDue,
OrderCategory = 'Non-Holiday Order'
From
Sales.SalesOrderHeader
Where Year(OrderDate) = 2013

Select TaxFreightPercent = (TaxAmt + Freight) / TotalDue
From #SalesOrders
--------------------------------We figured out the freight tax % but how do we get it into the table?

Update #SalesOrders
Set TaxFreightPercent = (TaxAmt + Freight) / TotalDue,
OrderAmtBucket =
	Case	
		When TotalDue > 100 Then 'Small'
		When TotalDue < 1000 Then 'Medium'
		Else 'Large'
	End

Select *
From #SalesOrders    ---TaxFreightPercent is now filled out as well as orderamtbucket

Update #SalesOrders
Set TaxFreightBucket =
	Case
		When TaxFreightPercent < 0.1 Then 'Small'
		When TaxFreightPercent < 0.2 Then 'Medium'
		Else 'Large'
	End

Select *
From #SalesOrders  -------Now the tax freightbucket shows

Update #SalesOrders
Set OrderCategory = 'Holiday'
Where DATEPART(Quarter, OrderDate) = 4  --Quater is a useful way to determine if holiday, which is quarter 4

Select *
From #SalesOrders

----Then adding the OrderSubcat

Update #SalesOrders
Set OrderSubcategory = Concat(OrderCategory, ' ', '-', ' ', OrderAmtBucket)

Select *
From #SalesOrders
Order by OrderSubcategory desc

---------------------------------------------------- More uses for Update

CREATE TABLE #PersonContactInfo
(
	   BusinessEntityID INT
      ,Title VARCHAR(8)
      ,FirstName VARCHAR(50)
      ,MiddleName VARCHAR(50)
      ,LastName VARCHAR(50)
	  ,PhoneNumber VARCHAR(25)
	  ,PhoneNumberTypeID VARCHAR(25)
	  ,PhoneNumberType VARCHAR(25)
	  ,EmailAddress VARCHAR(50)
)

INSERT INTO #PersonContactInfo
(
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName
)

SELECT
	   BusinessEntityID
      ,Title
      ,FirstName
      ,MiddleName
      ,LastName

FROM AdventureWorks2019.Person.Person


UPDATE A
SET
	PhoneNumber = B.PhoneNumber,
	PhoneNumberTypeID = B.PhoneNumberTypeID

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PersonPhone B
		ON A.BusinessEntityID = B.BusinessEntityID


UPDATE A
SET	PhoneNumberType = B.Name

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.PhoneNumberType B
		ON A.PhoneNumberTypeID = B.PhoneNumberTypeID


UPDATE A
SET	EmailAddress = B.EmailAddress

FROM #PersonContactInfo A
	JOIN AdventureWorks2019.Person.EmailAddress B
		ON A.BusinessEntityID = B.BusinessEntityID

SELECT * FROM #PersonContactInfo

---------------------------------------Exists and Update examples--------------

Create Table #ProductsSold2012
(
SalesOrderID int,
OrderDate date,
LineTotal money,
ProductID int
)

Insert into #ProductsSold2012    -- a basic temp table and then inserting the data on these two rows from Sales.SalesOrderHeader
(
SalesOrderID,
OrderDate
)
Select
SalesOrderID,
OrderDate
From
Sales.SalesOrderHeader

Select *
From #ProductsSold2012  --We can see that the two columns are filled from the data on Sales.SalesOrderHeader
Where Year(OrderDate) = 2012


Update #ProductsSold2012  ----Here is where we fill in the other two columns. 
Set Linetotal = B.LineTotal,                             --Just update and set the column equal to the SalesOrderDetail columns to pull from
ProductID = B.ProductID
From
#ProductsSold2012 as a
	Join Sales.SalesOrderDetail as B
	On A.SalesOrderID = B.SalesOrderID

Select *
From #ProductsSold2012		--The problem is that OrderDetail has many duplicate SalesOrderIDs, and it's only showing distinct ones in this query



Select
A.SalesOrderID,         --Now this shows all SalesOrderIDs from SalesOrderDetail. **It's up to me to decide which output I want**
A.OrderDate,
B.LineTotal,
B.ProductID
From #ProductsSold2012 as a
	Join Sales.SalesOrderDetail as b
	On A.SalesOrderID = B.SalesOrderID







/* When to use what techniques? Join, Exist, When.

If you need to see all matches on the many side of the relationship, use JOIN --
If you dont want to see all matches from the many side, AND don't care to see any info about those matches (other than their existence), 
	then use EXISTS
If you dont't want to see all matches from the many side, BUT would like to see info about the returned match, then use UPDATE

*/


--Another Update example with temp tables 
Create table #PurchaseInfo
(
PurchaseOrderID int,
OrderDate date,
TotalDue money,
RejectedQty int
)

Insert into #PurchaseInfo
(
PurchaseOrderID,
OrderDate,
TotalDue 
)
Select 
PurchaseOrderID,
OrderDate,
TotalDue
From Purchasing.PurchaseOrderHeader

Select * 
From #PurchaseInfo


Update #PurchaseInfo
Set RejectedQty = B.RejectedQty
From #PurchaseInfo as A
	Join Purchasing.PurchaseOrderDetail as B
	On A.PurchaseOrderID = B.PurchaseOrderID

Select * 
From #PurchaseInfo


 --------------------------------Lookup Tables----------

 Create Table AdventureWorks2019.dbo.Calendar
(
 DateValue Date,
 DayOfWeekNumber int,
 DayOfWeekName varchar(32),
 DayOfMonthNumber int,
 MonthNumber int,
 YearNumber int,
 WeekendFlag tinyint,           --Tinyint is basically a '1' or '0'. Yes or no
 HolidayFlag tinyint
)

Insert into AdventureWorks2019.dbo.Calendar
(
DateValue,
DayOfWeekNumber,
DayOfWeekName,
DayOfMonthNumber,
MonthNumber,
YearNumber,
WeekendFlag,
HolidayFlag
)
													--In the VALUES field, we just go in order of what to put in the first row of each column from above...
VALUES										 
(Cast('01-01-2011' as Date),7,'Saturday',1,1,2011,1,1),
(Cast('01-02-2011' as Date),1,'Sunday',2,1,2011,0,0)    --You can keep adding rows of csv values if you want

Select *
From Calendar

Truncate table Calendar

-------- Inserts and recursion / lookup table----------

With Dates as
(
Select
	Cast('01-01-2011' as Date) as MyDate

Union all

Select
	Dateadd(Day,1,Mydate)
From Dates
Where MyDate < Cast('12-31-2030' as Date)
)

Insert Into Adventureworks2019.dbo.Calendar
(
DateValue
)
Select MyDate
From Dates
Option (Maxrecursion 10000)


Select * 
From Adventureworks2019.dbo.Calendar


Update Adventureworks2019.dbo.Calendar
Set
DayOfWeekNumber = Datepart(WEEKDAY, DateValue),
DayOfWeekName = FORMAT(DateValue, 'dddd'),
DayOfMonthNumber = Day(DateValue),
MonthNumber = Month(DateValue),
YearNumber = Year(DateValue)

Update Adventureworks2019.dbo.Calendar
Set WeekendFlag = 
	Case
	When DayOfWeekNumber IN(7,1) Then 1
	Else 0
	End

Update Adventureworks2019.dbo.Calendar           --Adding xmas and NYD to the holiday flag
Set HolidayFlag = 
	Case
	When MonthNumber = 12 and DAY(DateValue) = 25 Then 1
	When MonthNumber = 1 and DAY(DateValue) = 1 Then 1
	Else 0
	End

Select *
From Calendar
Where Month(DateValue) = 12                  -----We can now see what days are christmas through 2030
AND
DAY(DateValue) = 25



Select A.*, B.WeekendFlag
From Sales.SalesOrderHeader as A    ----We can now see orders made on a weekend, thanks to the weekend flag above ^
	Join Calendar as B
	On A.OrderDate = B.DateValue
Where B.WeekendFlag = 1


Select A.*, 
B.HolidayFlag,
B.WeekendFlag
From Sales.SalesOrderHeader as A            --Orders made on a Holiday
	Join Calendar as B
	On A.OrderDate = B.DateValue
Where HolidayFlag = 1
AND
WeekendFlag = 1


------------------------------Variables--------

Declare @AvgPrice money 

Select @AvgPrice = (Select Avg(Listprice) From Production.Product)            --Just set the @AvgPrice to the calculation and to shorten queries

Select 
ProductID,
Name,
StandardCost,
ListPrice,
AvgListPrice = @AvgPrice,
AvgListPriceDiff = ListPrice - @AvgPrice
From Production.Product
Where ListPrice > @AvgPrice

Order by 4 asc



-----------------Variables with Dates----

Declare @Today Date

Set @Today = Cast(GETDATE() as Date)

Declare @BOM Date  

Set @BOM = DATEFROMPARTS(Year(@Today), Month(@Today), 1)

Select @BOM


------------------------Storing Procedures-------

Create procedure dbo.OrderNames

As

Begin
	Select *
	From Production.Product
	Order by 1
End


Exec dbo.OrderNames

--------You can even alter it---

--Go to programability in the object explorer. Then alter to new query



----------------------------------------------------------------------------IF statements, similar to case statement

Declare @MyInput int
Set @MyInput = 5

If @MyInput > 1
	Begin
		Select 'Hello world'
	End

Else
	Begin
		Select 'Farewell'
	End



-----------------Dynamic SQL example----

Create Procedure dbo.DynamicTopN(@TopN INT , @AggFunction varchar(50))

As

Begin

	Declare @DynamicSQL varchar(MAX) 

	Set @DynamicSQL = 'Select *
		From
			(
			Select 
			ProductName = B.Name,
			LineSumTotal = '
	Set @DynamicSQL = @DynamicSQL + @AggFunction

	Set @DynamicSQL = @DynamicSQL +  '(A.LineTotal),
		LineTotalSumRank = DENSE_RANK() Over(Order by '

	Set @DynamicSQL = @DynamicSQL + @AggFunction

	Set @DynamicSQL = @DynamicSQL + '(A.LineTotal) Desc)
		From 
		Sales.SalesOrderDetail as A
		Join Production.Product as B
		On A.ProductID = B.ProductID

		Group by 
		B.Name
		) X
	Where LineTotalSumRank <= '

	Set @DynamicSQL = @DynamicSQL + Cast(@TopN as varchar)

	Exec(@DynamicSQL)

End




Exec dbo.DynamicTopN 15, 'Max'    --This executes the above stored procedure. You can change out the '15' (aka top 15), 
							      --and the 'Max' for 'min', 'avg', etc