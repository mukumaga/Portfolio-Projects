---looking at total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint, dea.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as  CumulativeVaccinations
--, (CumulativeVaccinations/population)*100
from .CovidDeaths dea
join .CovidVaccinations vac
	on dea.location = vac.location
	and vac.date = vac.date
	where dea.continent is not null
order by 2,3

---CTE
WITH PopulationvsVaccination (Continent, Location, Date, Population,new_vaccinations, CumulativeVaccinations)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint, dea.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as  CumulativeVaccinations
--, (CumulativeVaccinations/population)*100
from .CovidDeaths dea
join .CovidVaccinations vac
	on dea.location = vac.location
	and vac.date = vac.date
	where dea.continent is not null
--order by 2,3
) 
select *, (CumulativeVaccinations/Population)*100 
from PopulationvsVaccination


---Temp Table

CREATE TABLE #PercentPopVac
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 CumulativeVaccinations NUMERIC,
 )
insert into #PercentPopVac
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint, dea.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as  CumulativeVaccinations
--, (CumulativeVaccinations/population)*100
from .CovidDeaths dea
join .CovidVaccinations vac
	on dea.location = vac.location
	and vac.date = vac.date
	where dea.continent is not null
--order by 2,3

select *, (CumulativeVaccinations/Population)*100 
from #PercentPopVac


------VIEW

CREATE VIEW PercentPopVac AS 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(CONVERT(bigint, dea.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date)
as  CumulativeVaccinations
--, (CumulativeVaccinations/population)*100
from .CovidDeaths dea
join .CovidVaccinations vac
	on dea.location = vac.location
	and vac.date = vac.date
	where dea.continent is not null
--order by 2,3


SELECT * FROM .PercentPopVac