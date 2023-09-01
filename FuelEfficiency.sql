 Select 
 * 
 From 
 FuelEfficiency
 
 Select 
 Distinct STANDARD_TYPE,        --What different types of cars are there that were being tracked?
 Count(STANDARD_TYPE) as Count_of_Veh      
 From 
 FuelEfficiency
 Group by STANDARD_TYPE

 Select 
 Distinct Count(Make) as MakeCounts
 From 
 FuelEfficiency

 Select 
 Year, Make, Model
 From 
 FuelEfficiency
 Order by 2

  --Ranking the act. fuel efficieny by fuel type
  
 Select EPA_RATING_CITY,ACTUAL_FUEL_ECONOMY_Geotab ,Concat(year, ' ',make, ' ',model) as CarName, Hybrid_Non_Hybrid,   
 ROW_NUMBER() Over(Partition by Hybrid_Non_hybrid Order by Actual_Fuel_Economy_Geotab desc) as RankByFuelEconomy
 From FuelEfficiency


 --Ranking the different veh types with the best fuel economy-------

 Select STANDARD_TYPE, Concat(year, ' ',make, ' ',model) as CarName, ACTUAL_FUEL_ECONOMY_Geotab,
 ROW_NUMBER() Over(Partition by Standard_Type Order by ACTUAL_FUEL_ECONOMY_Geotab desc) as RankbyVehType
 From FuelEfficiency
 Where ACTUAL_FUEL_ECONOMY_Geotab > 10
 and
 STANDARD_TYPE = 'SUV'

 Select STANDARD_TYPE, Concat(year, ' ',make, ' ',model) as CarName, ACTUAL_FUEL_ECONOMY_Geotab,
 ROW_NUMBER() Over(Partition by Standard_Type Order by ACTUAL_FUEL_ECONOMY_Geotab desc) as RankbyVehType
 From FuelEfficiency
 Where ACTUAL_FUEL_ECONOMY_Geotab > 10
 and
 STANDARD_TYPE = 'Sedan'

 Select STANDARD_TYPE, Concat(year, ' ',make, ' ',model) as CarName, ACTUAL_FUEL_ECONOMY_Geotab,
 ROW_NUMBER() Over(Partition by Standard_Type Order by ACTUAL_FUEL_ECONOMY_Geotab desc) as RankbyVehType
 From FuelEfficiency
 Where ACTUAL_FUEL_ECONOMY_Geotab > 10
 and
 STANDARD_TYPE = 'Pickup'

 Select STANDARD_TYPE, Concat(year, ' ',make, ' ',model) as CarName, ACTUAL_FUEL_ECONOMY_Geotab,
 ROW_NUMBER() Over(Partition by Standard_Type Order by ACTUAL_FUEL_ECONOMY_Geotab desc) as RankbyVehType
 From FuelEfficiency
 Where ACTUAL_FUEL_ECONOMY_Geotab > 10
 and
 STANDARD_TYPE = 'Van'

 -------------------------

 --How much better did the MPG in hybrids do vs. just ICE?

Select 
Sum(ACTUAL_FUEL_ECONOMY_Geotab) as CollectiveActualMPG, Hybrid_Non_Hybrid, Sum(Vehicle_Count) as VehCountbyType,
(Sum(ACTUAL_FUEL_ECONOMY_Geotab) - Lead(Sum(ACTUAL_FUEL_ECONOMY_Geotab), 1) Over(Order by Sum(ACTUAL_FUEL_ECONOMY_Geotab))) as DifferenceInMPG,
Case
	When (Sum(ACTUAL_FUEL_ECONOMY_Geotab) - Lead(Sum(ACTUAL_FUEL_ECONOMY_Geotab), 1) Over(Order by Sum(ACTUAL_FUEL_ECONOMY_Geotab))) Is Null Then 'More Efficient'
	Else 'Less Efficient'
	End as Outcome
From 
FuelEfficiency
Group by 
Hybrid_Non_Hybrid
Order by 1 desc

--What is are the different countries of brands that were surveyed? 

Select 
Distinct Make
From 
FuelEfficiency

Select 
	Concat(year, ' ',make, ' ',model) as CarName, EPA_RATING_CITY,
	Case
		When Make = 'FORD' Then 'US'
		When Make = 'CHEVROLET' Then 'US'
		When Make = 'DODGE' Then 'US'
		When Make = 'GMC' Then 'US'
		When Make = 'FREIGHTLINER' Then 'US'
		Else 'JP'
		End as CountryBrand
	From FuelEfficiency 

--Which country brands state the better estimated city MPG?

WITH CountriesCars AS
	(
	Select 
	Concat(year, ' ',make, ' ',model) as CarName, EPA_RATING_CITY,
	Case
		When Make = 'FORD' Then 'US'
		When Make = 'CHEVROLET' Then 'US'
		When Make = 'DODGE' Then 'US'
		When Make = 'GMC' Then 'US'
		When Make = 'FREIGHTLINER' Then 'US'
		Else 'JP'
		End as CountryBrand
	From FuelEfficiency 
	)
Select 
SUM(EPA_RATING_CITY)TotalEPA_RatingCity, CountryBrand
From 
CountriesCars
Group by 
CountryBrand


--Which country brands actually delivered the best MPG, top 15?


With ActualMPG_Country as
	(
		Select 
		Concat(year, ' ',make, ' ',model) as CarName, ACTUAL_FUEL_ECONOMY_Geotab,
		Case
			When Make = 'FORD' Then 'US'
			When Make = 'CHEVROLET' Then 'US'
			When Make = 'DODGE' Then 'US'
			When Make = 'GMC' Then 'US'
			When Make = 'FREIGHTLINER' Then 'US'
			Else 'JP'
			End as CountryBrand
	From 
	FuelEfficiency
	)
Select 
Top 15 *,
ROW_NUMBER() Over(Order by ACTUAL_FUEL_ECONOMY_Geotab desc) as Ranking  --left out partition by to get an overall rank of all veh
From 
ActualMPG_Country



--Avg fuel costs per mile differences by Hybrid vs non-Hybrid

Select 
Hybrid_Non_Hybrid, 
Avg(Cast(Trim('$ ' from FUEL_COSTS_PER_MILE) as float)) as Fuel_Cost_by_Mile,
Avg(Cast(Trim('$,   ' from Replace(ESTIMATED_FUEL_COSTS_PER_GALLON, ',', '' ))as float)) as Estimated_Cost_Per_Gal_Fleet,
Count(Hybrid_Non_Hybrid) as Num_of_veh
From 
FuelEfficiency
Group by 
Hybrid_Non_Hybrid


