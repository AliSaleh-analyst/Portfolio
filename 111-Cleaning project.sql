-- Data Cleaning 
-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or Blank Values 
-- 4. Remove Any Columns or Rows

-- Removing Duplicates

Select *
from world_layoffs.layoffs;

Create table layoffs_staging
like layoffs;

Insert into layoffs_staging
Select *
from layoffs;

Select *
from layoffs_staging;


With duplicate_cte as ( Select *,
Row_number() over 
( Partition by company, location, industry, total_laid_off, percentage_laid_off, date , stage, country, funds_raised_millions) As row_num 
from layoffs_staging )
select *
from duplicate_cte 
where row_num > 1;


Select *
from layoffs_staging
where company = "Casper";


CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


Select *
from layoffs_staging2;

insert into layoffs_staging2 ( Select *,
Row_number() over 
( Partition by company, location, industry, total_laid_off, percentage_laid_off, date , stage, country, funds_raised_millions) As row_num 
from layoffs_staging );

delete
from layoffs_staging2
where row_num > 1;

Select *
from layoffs_staging2
where row_num > 1;

-- Standardizing Data

Select company, trim(company)
from layoffs_staging2 ;

Update layoffs_staging2
Set company = trim(company);

select distinct industry 
from layoffs_staging2 
order by 1 ;

Select * 
from layoffs_staging2 
where industry like "Crypto%";

Update layoffs_staging2 
Set industry = "Crypto"
where industry Like "Crypto%";

select distinct location  # Check this step for each column
from layoffs_staging2 
Order by 1;

Update layoffs_staging2
Set location = CONVERT(BINARY CONVERT(location USING latin1) USING utf8mb4)   # Use Cast instead of binary convert next time
where location like "%Ã%";

select distinct country 
from layoffs_staging2 
Order by 1;

Select distinct country, trim(trailing '.' from country)
from layoffs_staging2
order by 1;

Update layoffs_staging2
Set country = trim(trailing '.' from country)
where country like "United States%";

Select date,
str_to_date(date,"%m/%d/%Y")  # m, d should be small not capital (except the Y)
from layoffs_staging2;

Update layoffs_staging2
Set date = str_to_date(date,"%m/%d/%Y") ;

Alter table layoffs_staging2
Modify Column date date;

Select *
from layoffs_staging2;

-- Removing Nulls and Blanks 


Select *
from layoffs_staging2
where industry is null 
or industry = "" ;

Select *
from layoffs_staging2                # Now I will try to find the null value in other rows related to these companys
where company = "Airbnb";

Select t1.industry, t2.industry
from layoffs_staging2 t1
Join layoffs_staging2 t2
	On t1.company = t2.company
    And t1.location = t2.location
Where t1.industry is null Or t1.industry = "" 
And t2.industry is not null And t2.industry != "";


Update layoffs_staging2 t1
Join layoffs_staging2 t2
	on t1.company = t2.company
    And t1.location = t2.location
Set t1.industry = t2.industry
where t1.industry is null Or t1.industry = "" 
And t2.industry is not null And t2.industry != "";



Select *                                  # Where we can't predict values related to these columns I will delete them 
from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null ;

Delete 
from layoffs_staging2
where total_laid_off is null 
And percentage_laid_off is null;


-- Removing any columns and Rows

Alter Table layoffs_staging2
drop column row_num ;


select *
from layoffs_staging2 ; 
