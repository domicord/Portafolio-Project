--Cleaning Data in SQL Queries
Select *
From Project.dbo.NashvilleHousing


-- Standardize Date Format

Select SaleDate, CONVERT(Date,SaleDate)
From Project.dbo.NashvilleHousing

Update NashvilleHousing
Set SaleDate = Convert(Date,SaleDate)

-- Populate Property Address data

Select a.ParcelId, a.PropertyAddress, b.ParcelId, b.PropertyAddress
From Project.dbo.NashvilleHousing a
Join Project.dbo.NashvilleHousing b
	On a.ParcelId = b.ParcelId
	And a.[UniqueId] <> b.[UniqueId]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From Project.dbo.NashvilleHousing a
Join Project.dbo.NashvilleHousing b
	On a.ParcelId = b.ParcelId
	And a.[UniqueId] <> b.[UniqueId]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From Project.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address
From Project.dbo.NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From Project.dbo.NashvilleHousing


Select OwnerAddress
From Project.dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From Project.dbo.NashvilleHousing



ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From Project.dbo.NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Project.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From Project.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From Project.dbo.NashvilleHousing)


Select *
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From Project.dbo.NashvilleHousing

-- Delete Unused Columns

Select *
From Project.dbo.NashvilleHousing


ALTER TABLE Project.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

