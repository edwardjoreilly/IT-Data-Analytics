/*
IT Data Analytics Covid 19 data  SQL practice/examples lab
*/

Select *
From PortfolioProject..CovidDeaths
where continent is not null
order by 3,4


--Starting data selection
Select location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
order by 1,2


--Total Cases vs. Total Deaths
-- Shows likelihood of dying if you contract Covid in the US
Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
Where location like '%states%'
order by 1,2


-- Total cases vs. Population
-- shows what percentage of population got Covid
Select location, date, total_cases, Population, (total_cases/Population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Countries with highest infection rate compared to population
Select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/Population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
group by location, population
order by PercentPopulationInfected desc

-- The continents with the highest death count per population
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is not null
group by continent
order by TotalDeathCount desc


-- Countries with highest death rate per population
Select location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
-- Where location like '%states%'
where continent is null
group by location
order by TotalDeathCount desc


-- GLOBAL NUMBERS
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null
--group by date
order by 1,2


-- Using CTE to perform Calculation on Partition By in previous query
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


--TEMP TABLE
Drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


--Create view for data visualization
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null