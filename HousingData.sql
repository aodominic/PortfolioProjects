Select * 
From dbo.HousingData

--Standardizing the date format------------------

Select SaleDateConverted, CONVERT(Date, SaleDate)
From dbo.HousingData

--Update HousingData
--SET SaleDate = CONVERT(Date, SaleDate)

--Select SaleDate
--From dbo.HousingData

	--^ Not updating the column for some reason--

Alter Table HousingData
Add SaleDateConverted Date

Update HousingData
SET SaleDateConverted = CONVERT(Date, SaleDate)

Select SaleDateConverted
From dbo.HousingData


--Populating property address data-----------------

Select * --PropertyAddress
From dbo.HousingData
--Where PropertyAddress is null
order by ParcelID


--Here we will fill in the blank property addresses by using the ParcelID and filling in the missing addresses in------------

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.HousingData a
JOIN dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From dbo.HousingData a
JOIN dbo.HousingData b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID


--Breaking the address into multiple columns (address, city, state)--------------

Select 
	Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1) as Address
	, Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
From dbo.HousingData


Alter Table HousingData
Add PropertySplitAddress Nvarchar(255);

Update HousingData
SET PropertySplitAddress = Substring(PropertyAddress, 1, Charindex(',', PropertyAddress) -1)

--Select PropertySplitAddress
--From dbo.HousingData

Alter Table HousingData
Add PropertySplitCity Nvarchar(255);

Update HousingData
SET PropertySplitCity = Substring(PropertyAddress, Charindex(',', PropertyAddress) +1, LEN(PropertyAddress))

Select *
From dbo.HousingData


Select OwnerAddress
From dbo.HousingData

Select 
PARSENAME(Replace(OwnerAddress, ',', '.'),3)
, PARSENAME(Replace(OwnerAddress, ',', '.'),2)
, PARSENAME(Replace(OwnerAddress, ',', '.'),1)
From dbo.HousingData


Alter Table HousingData
Add OwnerSplitAddress Nvarchar(255);

Update HousingData
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Alter Table HousingData
Add OwnerSplitCity Nvarchar(255);

Update HousingData
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter Table HousingData
Add OwnerSplitState Nvarchar(255);

Update HousingData
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select OwnerSplitAddress, OwnerSplitCity, OwnerSplitState 
From dbo.HousingData


--Change Y/N to Yes/No in SoldAsVacant-----------

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From dbo.HousingData
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From dbo.HousingData

Update HousingData
SET SoldAsVacant = Case When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END

Select SoldAsVacant
From dbo.HousingData


--Removing duplicates------------

With RowNumCTE AS(
Select *,
ROW_NUMBER() OVER (
Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY UniqueID
				) row_num

From dbo.HousingData
)

--Delete 
Select *
From RowNumCTE
Where row_num > 1   --Duplicates deleted!




--Delete unused columns--------------------

Select *
From dbo.HousingData

Alter Table HousingData
Drop column OwnerAddress, TaxDistrict,
PropertyAddress

Alter Table HousingData
Drop column SaleDate