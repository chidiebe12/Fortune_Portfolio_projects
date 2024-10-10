SELECT * 
FROM layoffs;
CREATE TABLE layoffs_staging
LIKE layoffs;
SELECT * from layoffs_staging;
INSERT layoffs_staging
SELECT * FROM layoffs;
SELECT * FROM layoffs_staging;
ALTER TABLE layoffs_staging
ADD COLUMN company_id INT PRIMARY KEY AUTO_INCREMENT;
WITH layoffs_stage_cte AS (
SELECT *,ROW_NUMBER() OVER(PARTITION BY company_id ,company,location,industry,total_laid_off,
percentage_laid_off,`date`,stage,country,funds_raised_millions) AS row_num
FROM layoffs_staging)
SELECT * FROM layoffs_staging 
WHERE company_id IN( SELECT company_id FROM layoffs_stage_cte WHERE row_num > 1);
SELECT DISTINCT industry, TRIM(industry)
FROM layoffs_staging
ORDER BY 1;
SELECT DISTINCT industry, TRIM(industry)
FROM layoffs_staging
WHERE industry LIKE 'Crypto%';
UPDATE layoffs_staging
SET industry ="Crypto" WHERE industry LIKE 'Crypto%';
SELECT DISTINCT country, TRIM(TRAILING "." FROM country)
FROM layoffs_staging
WHERE country LIKE 'United States%';
UPDATE layoffs_staging
SET country =TRIM(TRAILING "." FROM country) WHERE country LIKE 'United States%'; 
SELECT `date`, 
STR_TO_DATE(`date`,'%m/%d/%Y')
FROM layoffs_staging;
UPDATE layoffs_staging
SET `date` =STR_TO_DATE(`date`,'%m/%d/%Y');
ALTER TABLE layoffs_staging
MODIFY COLUMN `date` DATE;
SELECT *
FROM layoffs_staging t1
JOIN layoffs_staging t2
    ON t1.company = t2.company
WHERE t2.industry IS NULL or t2.industry = "";
UPDATE layoffs_staging 
SET industry = NULL WHERE industry = ""; 
UPDATE layoffs_staging t1
	JOIN layoffs_staging t2
    ON t1.company = t2.company
    SET t1.industry = t2.industry
    WHERE (t1.industry IS NULL) AND t2.industry IS NOT NULL;
    SELECT * FROM layoffs_staging 
    WHERE company LIKE "Airbnb%";
    