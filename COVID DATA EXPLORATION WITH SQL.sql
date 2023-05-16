
--ANALYSIS OF COVID DATA FROM 1ST JANUARY, 2020 TO 3RD MAY, 2023

SELECT *
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4

SELECT *
FROM PortfolioProject..CovidVaccinations
ORDER BY 3,4

--SELECT DATA NEEDED FOR ANALYSIS

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--DIVE INTO TOTAL CASES VS TOTAL DEATHS
-- Change the data type of total_cases & total_deaths to float to perform division and calculate death percentage
-- This shows the likelihood of dying from contracting Covid in your country

ALTER TABLE CovidDeaths
ALTER COLUMN total_cases float;

ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths float;

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE location LIKE '%Nigeria%'
AND continent IS NOT NULL
ORDER BY 1,2

--DIVING INTO TOTAL CASES VS POPULATION
--Shows percentage of population that got covid

SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPercentage
FROM CovidDeaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL
ORDER BY 1,2

SELECT location, date, total_cases, population, (total_cases/population)*100 AS InfectedPercentage
FROM CovidDeaths
WHERE location LIKE '%Nigeria%'
AND continent IS NOT NULL
ORDER BY 1,2

--DETERMINING COUNTRIES WIIH HIGHEST INFECTION RATE COMPARED TO POPULATION

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS InfectedPercentage
FROM CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY InfectedPercentage DESC

--SHOWING COUNTRIES WITH HIGHEST DEATH COUNT PER POPULATION

SELECT location, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

--LET'S BREAK IT DOWN BY CONTINENT
--Note that these analysis are carried out with a view to visualization


--DETERMINING THE CONTINENT WITH THE HIGHEST DEATH COUNT PER POPULATION

SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM CovidDeaths
--WHERE location LIKE '%states%'
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--GLOBAL NUMBERS
--NB:I encountered an error when trying to directly divide the sum of new_deaths by the sum of new_cases because division by zero isn't possible, hence I introduced the nullif function

SELECT date, SUM(new_cases) as SumofNewCases, SUM(new_deaths) as SumofNewDeath,SUM(new_deaths)/NULLIF (SUM(new_cases),0)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

SELECT SUM(new_cases) as SumofNewCases, SUM(new_deaths) as SumofNewDeath,SUM(new_deaths)/NULLIF (SUM(new_cases),0)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1,2

--LET'S EXPLORE THE VACCINATION DATA

SELECT *
FROM CovidVaccinations

--JOINING THE TABLES

SELECT *
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date

--LOOKING AT TOTAL POPULATION VS VACCINATIONS
--This shows the number of people that have been vaccinated atleast once

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 1,2,3

--GETTING THE PERCENTAGE OF RollingPeopleVaccinated FOR EACH LOCATION

--Using CTE to perform calculation on PartitionBy in previous query
--NB: I used the bigint function because the result of the calculation seem to be outside the range of the ordinary int data type

WITH PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 AS RollingPeopleVaccinatedPercentage
FROM PopvsVac

--USING TEMP TABLE
--The drop table is very useful in order to make desired alterations to the temp table very easy

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/population)*100 AS RollingPeopleVaccinatedPercentage
FROM #PercentPopulationVaccinated

--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.Location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated 