--Select Data we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM master..covidDeaths
order by 1,2;

--Looking at Total Cases vs. Total Deaths
--Shows the likelihood of dying from contraction COVID in your Country

SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases)*100 AS 'Death %'
FROM master..covidDeaths
WHERE location like '%states%'
order by 1,2;

--Looking at Total Cases vs. Population 
--Shows what % of Population contracted COVID

SELECT location, date, population, total_cases, (total_cases / population)*100 AS 'PercentPopulationInfected'
FROM master..covidDeaths
WHERE location like '%states%'
order by 1,2;

--Looking at Countries with Highest Infection Rate compared to Population

SELECT location, population, MAX(total_cases) As 'Highest Infection Count', MAX((total_cases / population))*100 AS 'PercentPopulationInfected'
FROM master..covidDeaths
GROUP BY location, population
ORDER by PercentPopulationInfected desc;

--Looking at Countries with Highest Death Count per Population 

SELECT location, MAX(Total_deaths) AS 'TotalDeathCount' 
FROM master..covidDeaths
WHERE continent is not null
GROUP BY location
ORDER by TotalDeathCount desc;

-- LETS BREAK THINGS DOWN BY CONTINENT

--Looking at Continents with the Highest Death Count per Population

SELECT continent, MAX(Total_deaths) AS 'TotalDeathCount' 
FROM master..covidDeaths
WHERE continent is not null
GROUP BY continent
ORDER by TotalDeathCount desc;

--GLOBAL NUMBERS 

SELECT date, SUM(new_cases) AS 'TotalCases', SUM(new_deaths) As 'TotalDeaths', 
SUM(new_deaths)/SUM(new_cases)*100 AS 'DeathPercentage'
FROM master..covidDeaths
WHERE continent is not null
GROUP By date 
order by 1,2;


--Looking at Total Population vs. Vaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS 
'RollingPeopleVaccinated'
FROM master..covidDeaths dea
Join master..covidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3;

--USE CTE

With PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as (
    SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(new_vaccinations) OVER (Partition by dea.location ORDER BY dea.location, dea.date) AS 
'RollingPeopleVaccinated'
FROM master..covidDeaths dea
Join master..covidVaccinations vac 
    ON dea.location = vac.location 
    AND dea.date = vac.date
WHERE dea.continent is not null
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac;

--Creating View to Store Data for Later Visualizations 

Create View DeathByCountry as 
SELECT location, MAX(Total_deaths) AS 'TotalDeathCount' 
FROM master..covidDeaths
WHERE continent is not null
GROUP BY location
--ORDER by TotalDeathCount desc;