Select *
from [portfolioproject].[dbo].[['covid-deaths']]]
where continent is not null
order by 3,4
Select *
from [portfolioproject].[dbo].[covid vaccinations]
order by 3,4

--Select the data that we are going to use 
Select Location, date, total_cases, new_cases, total_deaths, population
from [portfolioproject].[dbo].[['covid-deaths']]]
where continent is not null
order by 1,2

--Looking at total_cases vs total_deaths
--Showing liklihood of dying if you contract covid in your country
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from [portfolioproject].[dbo].[['covid-deaths']]]
where location Like '%states%'
and continent is not null
order by 1,2

--Looking at Population vs total_cases
--Shows what percentage of population got covid
Select Location, date,population, total_cases,(total_cases/population)*100 as DeathPercentage
from [portfolioproject].[dbo].[['covid-deaths']]]
--where location Like '%states%'
where continent is not null
order by 1,2



--Looking at countries with highest infection rate as compared to population
Select Location,population, MAX(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from [portfolioproject].[dbo].[['covid-deaths']]]
--where location Like '%states%'
where continent is not null
group by Location,population
order by PercentPopulationInfected desc

--Showing Countries with highest Death counts per population
Select Location, Max(cast(total_deaths as int)) as TotalDeathcounts 
from [portfolioproject].[dbo].[['covid-deaths']]]
--where location Like '%states%'
where continent is not null
group by Location 
order by TotalDeathcounts  desc


--Lets break things down by continent
--Showing continents with the highest death counts per population

Select continent, Max(cast(total_deaths as int)) as TotalDeathcounts 
from [portfolioproject].[dbo].[['covid-deaths']]]
--where location Like '%states%'
where continent is not null
group by continent 
order by TotalDeathcounts  desc

--Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [portfolioproject].[dbo].[['covid-deaths']]]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2



--Looking at Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    [portfolioproject].[dbo].[['covid-deaths']]] dea
JOIN
    [portfolioproject].[dbo].[covid vaccinations] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL;


--Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    [portfolioproject].[dbo].[['covid-deaths']]] dea
JOIN
    [portfolioproject].[dbo].[covid vaccinations] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE
    dea.continent IS NOT NULL
)
Select *,(RollingPeopleVaccinated/Population)*100
from PopvsVac


--Temp table

Create table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date Datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    [portfolioproject].[dbo].[['covid-deaths']]] dea
JOIN
    [portfolioproject].[dbo].[covid vaccinations] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Creating View to store data for later visualizations

CREATE VIEW PercentPopulationVaccinated as
SELECT
    dea.continent,
    dea.location,
    dea.date,
    dea.population,
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (PARTITION BY dea.Location ORDER BY dea.location, dea.Date) as RollingPeopleVaccinated
FROM
    [portfolioproject].[dbo].[['covid-deaths']]] dea
JOIN
    [portfolioproject].[dbo].[covid vaccinations] vac
    ON dea.location = vac.location
    AND dea.date = vac.date
WHERE dea.continent IS NOT NULL


--Query for the Tableau Project

--1
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [portfolioproject].[dbo].[['covid-deaths']]]
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

--2
--We take these out as they are not included in the above queries and want to stay consistent
--European union is a part of Europe
Select Location,Sum(Cast(new_deaths as int)) as TotalDeathCount
from [portfolioproject].[dbo].[['covid-deaths']]]
--Where Location LIKE %states%
Where continent is null
and location not in ('World','European Union','International')
Group by location
order by TotalDeathCount desc;

--3
Select Location, Population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from [portfolioproject].[dbo].[['covid-deaths']]]
--Where Location like '%states%
Group by Location,population
order by PercentPopulationInfected desc;

--4
Select Location,date ,Population, Max(total_cases) as HighestInfectionCount,Max((total_cases/population))*100 as PercentPopulationInfected
from [portfolioproject].[dbo].[['covid-deaths']]]
--Where Location like '%states%
Group by Location,population,date
order by PercentPopulationInfected desc;
