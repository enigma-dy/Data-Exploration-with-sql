--show first 50 rolls of all column
SELECT TOP(50)
    *
FROM Project.dbo.covid19

---show all data of covid19 table
SELECT *
FROM Project.dbo.covid19
ORDER BY [Date],Confirmed DESC

--create a cte table for covid19 cases in United Kindom
WITH UKconvid19data (Country_Region,Date,Confirmed,Recovered,Active,CA_ratio) as
(
    SELECT Country_Region, [Date], Confirmed, Recovered, Active, (Confirmed/NULLIF(Active,0))
    FROM Project.dbo.covid19
    WHERE Country_Region LIKE '%Kingdom%'
    
)
SELECT *
from UKconvid19data
ORDER BY Recovered DESC



--Looking at the totalcase vs total death ratio
SELECT location, date, total_cases, total_deaths, population, (total_deaths/total_cases)*100 as PercetangeDeath
FROM Project.dbo.covid19_death

-- create a temp table for death-population ratio
Drop TABLE if EXISTS DeathPercentageTable
CREATE TABLE DeathPercentageTable(
date NVARCHAR(255),
location NVARCHAR(255),
total_cases float,
total_deaths float,
population float,
PercetangeDeath float
)
INSERT INTO DeathPercentageTable
SELECT date,location,total_cases, total_deaths, population, (total_deaths/total_cases)*100 
FROM Project.dbo.covid19_death
WHERE location LIKE '%states%'

--SELECT location, Population, date, MAX(total_cases) as HigestInfection, total_deaths, MAX((total_cases/population))*100 as PercetangePopulationInfectected
--FROM Project.dbo.covid19_death
--GROUP BY location,population

--Locaiton with max total number of death
SELECT location, MAX(Total_deaths) as Total_deathsCount
FROM Project..covid19_death
WHERE continent is  NULL
GROUP BY location
ORDER by Total_deathsCount DESC

--TotalCases Count,TotalDeath Count, Group by location
SELECT location, SUM(total_cases) as total_cases, SUM(total_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as NewDeathPercentage
FROM Project..covid19_death
WHERE total_cases is Not NULL And total_deaths is Not Null
GROUP BY location

SELECT [date],[location],[population],total_cases,([total_deaths]/[population])*100 as DeathRatio
FROM Project..covid19_death
Where [location] LIKE '%State%'
ORDER BY 3,4 DESC

SELECT [location],[population],MAX(total_cases) as HighInfectionCount,MAX([total_deaths]/[population])*100 as DeathRatio
FROM Project..covid19_death
GROUP BY [location],population
ORDER BY [DeathRatio] DESC

--location with that Recorded the hight Death 
SELECT [location],MAX(total_deaths) as TotalDeathCount
FROM Project..covid19_death
WHERE continent is NULL
GROUP BY [location]
ORDER by TotalDeathCount DESC


--Total NewCase Count and DeathCount
SELECT SUM(new_cases) as totalNewCases,SUM(new_deaths) as totalDeath,SUM(new_deaths)/ SUM(new_cases)*100 as NewDeathPercentage
FROM Project..covid19_death
GROUP by new_cases
ORDER by NewDeathPercentage DESC

DROP TABLE if EXISTS vacinationCountTable
CREATE TABLE vacinationCountTable(
    [Location] NVARCHAR(225),
    Continent NVARCHAR(225),
    [population] float,
    TocalCases float,
    TotalDeath float,
    AverageTotalCase float,
    AverageTotalDeath float,
    NewVaccCount float,
    TotalVacination float,
)
INSERT into vacinationCountTable
    SELECT [location],continent,[population],SUM(total_cases) as total_cases,SUM(total_deaths) as TotalDeathCount,AVG(total_cases)
    as AverageTotalCase,AVG(total_deaths) as AverageTotalDeath,SUM(new_vaccinations) As TotalNewVaccCount,SUM(total_vaccinations) TotalVacination
    From Project..covid19_death
    GROUP By [location],continent,[population]
    ORDER BY TotalVacination DESC

SELECT top(50)*
from vacinationCountTable