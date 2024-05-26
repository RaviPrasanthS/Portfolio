SELECT *
FROM Age_Table

SELECT *
FROM Population_Final

SELECT *
FROM Country_Table

SELECT *
FROM Population_Data_Table

-- Total Population by Year
SELECT Year,Country,sum(Population) as Total_Population
FROM Country_Table as CT
JOIN Population_Data_Table AS PT
on CT.Country_ID = PT.Country_ID
group by Year,Country
order by year,Country

--Population Trends Over Time	
SELECT Country,Year,Gender,sum(Population) as Total_Population
FROM Country_Table as CT
JOIN Population_Data_Table AS PT
on CT.Country_ID = PT.Country_ID
group by Country,Year,Gender
order by Country,year

--Population Distribution by Age Group & Age Category:
SELECT Year,PT.Age_Group, Age_Category, SUM(Population) AS Total_Population
FROM Population_Data_Table AS PT
JOIN Age_Table AS AT
ON PT.Age_Group = AT.Age_Group
GROUP BY Year,PT.Age_Group, Age_Category
ORDER BY Year,PT.Age_Group, Age_Category;

--Gender Distribution Across Age Groups & Gender
SELECT Year, PT.Age_Group, Gender, SUM(Population) AS Total_Population
FROM Population_Data_Table AS PT
JOIN Age_Table AS AT
ON PT.Age_Group = AT.Age_Group
GROUP BY Year, PT.Age_Group, Gender
ORDER BY Year, PT.Age_Group, Gender;

--Location with Highest Population:
WITH PopulationTotals AS (
	SELECT Year, Country, SUM(Population) AS Total_Population
    FROM  Population_Data_Table as PT
	join Country_Table as CT
	on PT.Country_ID =CT.Country_ID
    GROUP BY Year, Country )
SELECT Year, Country, Total_Population AS Max_Population
FROM PopulationTotals
WHERE Total_Population = (
    SELECT MAX(Total_Population) 
    FROM PopulationTotals);

--Location with Lowest Population:
WITH PopulationTotals AS (
    SELECT Year, Country, SUM(Population) AS Total_Population
    FROM  Population_Data_Table as PT
	join Country_Table as CT
	on PT.Country_ID =CT.Country_ID
    GROUP BY Year, Country)
SELECT Year, Country, Total_Population AS Min_Population
FROM PopulationTotals
WHERE Total_Population = (
    SELECT MIN(Total_Population) 
    FROM PopulationTotals);

--Ranking Locations by Population
SELECT 
    Year, 
    Country, 
    Total_Population,
    RANK() OVER (PARTITION BY Year ORDER BY Total_Population DESC) AS Population_Rank
FROM (
    SELECT Year, Country, SUM(Population) AS Total_Population
    FROM  Population_Data_Table as PT
	join Country_Table as CT
	on PT.Country_ID =CT.Country_ID
    GROUP BY Year, Country
	) AS PopulationTotals;


--Calculating Cumulative Population:
SELECT 
    Year, 
    Country, 
    Total_Population,
    SUM(Total_Population) OVER (PARTITION BY Country ORDER BY Year) AS Cumulative_Population
FROM (
    SELECT Year, Country, SUM(Population) AS Total_Population
    FROM  Population_Data_Table as PT
	join Country_Table as CT
	on PT.Country_ID =CT.Country_ID
    GROUP BY Year, Country
	) AS PopulationTotals;

-- Calculate the annual growth rate of the population for each country over time
WITH TotalPopulation AS (
    SELECT 
        CT.Country_ID,
		CT.Country,
        PT.Year,
        SUM(PT.Population) AS T_Population
    FROM Country_Table AS CT
    JOIN Population_Data_Table AS PT ON CT.Country_ID = PT.Country_ID
    GROUP BY PT.Year, CT.Country_ID,CT.Country)

SELECT 
    Country_ID,
    Country,
    Year,
    T_Population AS Current_Population,
    Previous_Population,
    ROUND(((T_Population - Previous_Population) / NULLIF(Previous_Population, 0)) * 100, 2) AS Growth_Rate_Percentage
FROM (
    SELECT	
        Country_ID,
        Country,
        Year,
        T_Population,
        LAG(T_Population) OVER (PARTITION BY Country_ID ORDER BY Year) AS Previous_Population
    FROM TotalPopulation
) AS Subquery;

--Gender Ratio Trends
WITH PopulationCounts AS (
    SELECT 
        CT.Region_Name,
        PT.Year,
        PT.Age_Group,
        SUM(CASE WHEN PT.Gender = 'Male' THEN PT.Population ELSE 0 END) AS Male_Population,
        SUM(CASE WHEN PT.Gender = 'Female' THEN PT.Population ELSE 0 END) AS Female_Population
    FROM Country_Table AS CT
    JOIN Population_Data_Table AS PT ON CT.Country_ID = PT.Country_ID
    GROUP BY CT.Region_Name, PT.Year, PT.Age_Group
),
GenderRatio AS (
    SELECT
        Region_Name,
        Year,
        Age_Group,
        Male_Population,
        Female_Population,
        CASE 
            WHEN Female_Population <> 0 THEN Male_Population / Female_Population
            ELSE NULL
        END AS Gender_Ratio
    FROM PopulationCounts
)

SELECT
    Region_Name,
    Year,
    Age_Group,
    Male_Population,
    Female_Population,
    Gender_Ratio
FROM GenderRatio
ORDER BY Region_Name,Year,Age_Group;
