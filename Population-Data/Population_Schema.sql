
SELECT  *
FROM Population_New

-- Update Age_Group values to standardize format
UPDATE Population_New
SET Age_Group = 
    CASE 
        WHEN Age_Group = '05-Sep' THEN '5-9'
        WHEN Age_Group = 'Oct-14' THEN '10-14'
        ELSE Age_Group
    END;

-- Update Age_Group values to broader categories
UPDATE Population_New
SET Age_Group =
    CASE 
        WHEN Age_Group IN('0-4') THEN '0-4'
        WHEN Age_Group IN ('5-9', '10-14') THEN '5-14'
        WHEN Age_Group IN ('15-19', '20-24') THEN '15-24'
        WHEN Age_Group IN('25-29','30-34') THEN '25-34'		
		WHEN Age_Group IN ('35-39','40-44','45-49','50-54','55-59') THEN '35-59'
        WHEN Age_Group IN( '60-64','65-69','70-74','75-79','80-84','85-89','90-94','95-99','100-100') THEN '60-100'
		else Age_Group
    END;
-- Update Age_Min values to broader categories

UPDATE Population_New
SET Age_Min =
    CASE 
        WHEN Age_Min IN ('0')  THEN '0'
        WHEN Age_Min IN ('10') THEN '5'
        WHEN Age_Min IN ('20') THEN '15'
        WHEN Age_Min IN('30') THEN '25'		
		WHEN Age_Min IN ('40','45','50','55') THEN '35'
        WHEN Age_Min IN( '65','70','75','80','85','90','95','100') THEN '60'
        ELSE Age_Min
    END;
-- Update Age_Max values to broader categories

UPDATE Population_New
SET Age_Max =
    CASE 
		When Age_Max IN ('4') THEN '4'
        WHEN Age_Max IN ('9') THEN '14'
        WHEN Age_Max IN ('19') THEN '24'
        WHEN Age_Max IN('29') THEN '34'		
		WHEN Age_Max IN ('39','44','49','54') THEN '59'
        WHEN Age_Max IN( '64','69','74','79','84','89','94','99','100') THEN '100'
		else Age_Max
    END;

-- Add Age_Category column and populate it based on Age_Group

ALTER TABLE Population_New ADD Age_Category VARCHAR(20);

UPDATE Population_New
SET Age_Category =
    CASE 
        WHEN Age_Group IN ('0-4') THEN 'Baby'
        WHEN Age_Group IN ('5-14') THEN 'Child'
        WHEN Age_Group IN ('15-24') THEN 'Teenager'
        WHEN Age_Group IN('25-34')THEN 'Young Adult'
		WHEN Age_Group IN ('35-59') THEN 'Adult'
        WHEN Age_Group IN ('60-100') THEN 'Senior Citizen'
        ELSE Age_Group
    END;


/*
SELECT *
FROM Countries_Added
SELECT *
FROM Country_Codes
SELECT *
FROM Region_Names

SELECT CC.Location_ID, RN.Region_ID, RN.Custom AS Region_Name
FROM Country_Codes AS CC
JOIN Region_Names AS RN
ON CC.Country_Code = RN.Region_ID;*/


-- Create the new table
CREATE TABLE Region (
    Location_ID Varchar(255),
    Region_ID VARCHAR(255),
    Region_Name VARCHAR(255)
);

-- Insert data into the new table from the query
INSERT INTO Region (Location_ID, Region_ID, Region_Name)
SELECT CC.Location_ID, RN.Region_ID, RN.Custom AS Region_Name
FROM Country_Codes AS CC
JOIN Region_Names AS RN
ON CC.Country_Code = RN.Region_ID;


INSERT INTO Region (Location_ID, Region_ID, Region_Name)
SELECT Country_ID, Region_ID, Region_Names
FROM Countries_Added;

SELECT*
FROM Region

SELECT  *
FROM Population_New AS PN
JOIN Region AS R
ON PN.Location_ID = R.Location_ID

-- Step 1: Create a new table
CREATE TABLE Population_Final(
    Country_ID INT,
    Country VARCHAR(255),
	Region_ID VARCHAR(255),
	Region_Name VARCHAR(255),
    Year  INT,
	Age_Group VARCHAR(255),
	Age_Min INT,
	Age_Max INT,
	Age_Category VARCHAR(255),
	Gender VARCHAR(255),
	Population INT
);

INSERT INTO Population_Final (Country_ID, Country,Region_ID,Region_Name,Year,Age_Group,Age_Min,Age_Max,Age_Category,Gender,Population)
SELECT PN.Location_ID,PN.Location,R.Region_ID,R.Region_Name,PN.Year,PN.Age_Group,PN.Age_Min,PN.Age_Max,PN.Age_Category,PN.Gender,PN.Population
FROM Population_New AS PN
JOIN Region AS R
ON PN.Location_ID = R.Location_ID;


SELECT  *
FROM Population_New

SELECT *
FROM Population_Final

SELECT *
FROM Country_Table

SELECT *
FROM Population_Data_Table

SELECT *
FROM Age_Table


--Country Table:

CREATE TABLE Country_Table (
    Country_ID INT,
    Country VARCHAR(255),
    Region_Name VARCHAR(255));

INSERT INTO Country_Table (Country_ID, Country, Region_Name)
SELECT Distinct Country_ID, Country, Region_Name
FROM Population_Final;


--Population_Data_Table
CREATE TABLE Population_Data_Table (
    Country_ID INT,
    Year INT,
	Age_Group VARCHAR(255),
	Gender VARCHAR(255),
    Population INT);

INSERT INTO Population_Data_Table (Country_ID,  Year, Age_Group,Gender, Population)
SELECT Country_ID, Year, Age_Group,Gender, Population
FROM Population_Final;


--Age_Table
CREATE TABLE Age_Table (
    Age_Group VARCHAR(255),
    Age_Min INT,
    Age_Max INT,
    Age_Category VARCHAR(255));

INSERT INTO Age_Table (Age_Group, Age_Min, Age_Max, Age_Category)
SELECT DISTINCT Age_Group, Age_Min, Age_Max, Age_Category
FROM Population_Final;




