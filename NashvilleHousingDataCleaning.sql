/*

Cleaning Data in SQL Queries 

*/

Select *
From master..NashvilleHousing

-- Populate Property Address Data For When Property Address is Null

Select *
From master..NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From master..NashvilleHousing a
Join master..NashvilleHousing b
    On a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From master..NashvilleHousing a
Join master..NashvilleHousing b
    On a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID


-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From master..NashvilleHousing

Select 
SUBSTRING(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, (CHARINDEX(',' , PropertyAddress) + 1), LEN(PropertyAddress)) as City
From master..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',' , PropertyAddress) - 1);

ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, (CHARINDEX(',' , PropertyAddress) + 1), LEN(PropertyAddress));

SELECT *
FROM master..NashvilleHousing

-- 

SELECT OwnerAddress
FROM master..NashvilleHousing

SELECT
PARSENAME(REPLACE(OwnerAddress,',','.') ,3),
PARSENAME(REPLACE(OwnerAddress,',','.') ,2),
PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
FROM master..NashvilleHousing

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3);

ALTER TABLE NashvilleHousing
ADD OwnerSplitCity NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2);

ALTER TABLE NashvilleHousing
ADD OwnerSplitState NVARCHAR(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.') ,1);

SELECT *
FROM master..NashvilleHousing

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

FROM master..NashvilleHousing
--order by ParcelID
)
DELETE
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
--Order by PropertyAddress


-- Delete Unused Columns

SELECT *
FROM master..NashvilleHousing

ALTER TABLE master..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE master..NashvilleHousing
DROP Column SaleDate