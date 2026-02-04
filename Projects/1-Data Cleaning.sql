-- Data Cleaning


select *
from layoffs;

/*
The Steps To Clean Data
1- Copy Data To Staging Table (if we do someting wrong the raw data doesn't effect)
2- Remove Duplicates
3- Standardize The Data
3- Null Values Or Blank Values
4- Remove Any Columns or rows
*/

-- copy data to new table 
create table layoffs_staging
like layoffs;

insert layoffs_staging
select * 
from layoffs;

select * 
from layoffs_staging;


-- Remove Duplicates
-- we need to add specific column to can know the duplicates values from it

select *,
row_number() over( partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging;


-- use CTE to see duplicate values
with duplicate_cte as
(
select *,
row_number() over( partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

-- to delete duplicate values will create another table with row numbers to can delete it

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
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- insert data to it
insert into layoffs_staging2
select *,
row_number() over( partition by company, location, industry, 
total_laid_off, percentage_laid_off, `date`,
stage, country, funds_raised_millions) as row_num
from layoffs_staging;

-- delete duplicate values
delete
from layoffs_staging2
where num_row > 1;

select * 
from layoffs_staging2;
-- Standardizing data

-- remove spaces from company column

update layoffs_staging2
set company = trim(company);


-- in industry column the value 'Crypto' it's typed by different ways
update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%';


-- in country United States has '.' in some raws
update layoffs_staging2
set country = trim(trailing '.' from country) -- trailing select specific thing to trim it
where country like 'United States%';

select distinct country
from layoffs_staging2
order by 1;


-- change date format to data not text
update layoffs_staging2
set `date` = str_to_date(`date`, '%m/%d/%Y') -- this the format to convert it 
;

-- if we see date definition it still text to change it to date
alter table layoffs_staging2
modify column `date` date;


-- null or blank values
-- there are null and blank values in industry column
select *
from layoffs_staging2
where industry is null
or industry = '';

-- for example in Airbnb company has industry blank and anthor with value
-- we will add this value to the blank one
-- first update blank values to null
update layoffs_staging2
set industry = null
where industry = '';


-- now change it
update layoffs_staging2 t1
join layoffs_staging2 t2
	on t1.company = t2.company
set t1.industry = t2.industry
where t1.industry is null
and t2.industry is not null;


-- remove columns and rows
-- there is a lot of data has null values in total_laid_off and percentage_laid_off
SELECT *
FROM layoffs_staging2
WHERE total_laid_off is null
and percentage_laid_off is null;


-- Delete Useless data we can't really use
DELETE FROM world_layoffs.layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- to remove row_num the we create
alter table layoffs_staging2
drop column row_num;
