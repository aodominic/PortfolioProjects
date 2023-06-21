
SELECT *
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null 
ORDER BY 3,4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3,4

--Select Data that we are going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null 
ORDER BY 1,2


--Looking at the total cases vs total deaths
--Shows likelihood of dying if you contract covid in your country
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
ORDER BY 1,2



--Looking at total cases vs popultion
--Shows what percentage of population got covid
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
Where location like '%states%'
ORDER BY 1,2


--Looking at countried with highest infection rate compared to population

SELECT Location, MAX(total_cases) as HighestInfectionCount, Population, MAX((total_cases/Population))*100 as PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Group by Location, Population
ORDER BY PercentPopulationInfected desc


--Showing countries with highest death count per population

SELECT Location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null 
Group by Location
order by TotalDeathCount desc


--Breaking it down by continent
--Shows continents with highest death counts per population

SELECT continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
Where continent is not null 
Group by continent
order by TotalDeathCount desc




--GLOBAL--

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--Where location like '%states%'
Where continent is not null
--Group by date
Order by 1,2


--Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as CountryRunningTotal
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
Order by 2,3


--Using a CTE

With PopvsVac (Continent, Location, Date, Population, new_vaccinations, CountryRunningTotal)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as CountryRunningTotal
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (CountryRunningTotal/Population)*100
From PopvsVac


--Temp Table

DROP Table if exists #PercentPopVaccinated
Create Table #PercentPopVaccincated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric, 
CountryRunningTotal numeric 
)

Insert into #PercentPopVaccincated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as CountryRunningTotal
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
--Where dea.continent is not null
Order by 2,3

Select *, (CountryRunningTotal/Population)*100
From #PercentPopVaccincated


--Creating view to store data for later visualizations 


Create View PercentPopVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as int)) OVER (Partition by dea.location Order by dea.location, dea.date) as CountryRunningTotal
From PortfolioProject.dbo.CovidDeaths dea
Join PortfolioProject.dbo.CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null



Select *
From PercentPopVaccinated