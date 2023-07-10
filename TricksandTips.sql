
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