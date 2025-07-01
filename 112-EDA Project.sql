-- Exploratory Data Analysis

Select * 
from layoffs_staging2;


Select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2;

Select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off DESC;


select  industry,sum(total_laid_off), count(distinct company)
from layoffs_staging2
group by industry  
order by 2 desc;

select  company,sum(total_laid_off)
from layoffs_staging2
group by company  
order by 2 desc;

Select min(date), max(date)
from layoffs_staging2;	

select country, Sum(total_laid_off)
from layoffs_staging2
Group By country
order by 2 Desc ;

Select  Year(date), sum(total_laid_off)
from layoffs_staging2
Group by Year(date)
Order by 1 desc;

Select stage, Sum(total_laid_off)
from layoffs_staging2
Group by stage
Order by 2 Desc; 

Select Substring(date, 1,7) As "Month" , Sum(total_laid_off)
from layoffs_staging2
where Substring(date, 1,7) != "NULL"
Group by 1 
Order By 1 ASC ;

With Rolling_total As 
( Select Substring(date, 1,7) As "Month" , Sum(total_laid_off) As total_off
from layoffs_staging2
where Substring(date, 1,7) != "NULL"
Group by 1 
Order By 1 ASC )
Select Month , total_off, Sum(total_off)
over ( Order by Month ) As rolling_total
from Rolling_total 	;


Select company, Year(date), Sum(total_laid_off) As total_off
from layoffs_staging2
Group by company, Year(date)
Order by 3 Desc;
 
 
 With company_year( company, year, total_off) AS
 (Select company, Year(date), Sum(total_laid_off) 
from layoffs_staging2
Group by company, Year(date)), 
company_year_rank AS (select *, 
dense_rank () over (Partition by year Order by total_off Desc) AS ranking
from company_year
Where year Is Not Null 
Order by ranking)

Select *
from company_year_rank
Where ranking <= 5 ;