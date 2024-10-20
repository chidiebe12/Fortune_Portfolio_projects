SELECT * FROM layoffs;
SELECT * FROM layoffs_staging;
SELECT MAX(total_laid_off), MAX(percentage_laid_off) FROM
layoffs_staging;
SELECT * FROM layoffs_staging WHERE 
percentage_laid_off = 1
ORDER BY funds_raised_millions;
SELECT company, SUM(total_laid_off) FROM 
layoffs_staging 
GROUP BY company 
ORDER BY 2 DESC;
SELECT MAX(`date`), MIN(`date`) FROM layoffs_staging;
SELECT country, SUM(total_laid_off)
FROM layoffs_staging 
GROUP BY country
ORDER BY 2 DESC;
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging 
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;
SELECT YEAR(`date`), SUM(total_laid_off) FROM layoffs_staging 
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;
#ROLLING SUM
SELECT company, SUM(total_laid_off) AS total_per
FROM layoffs_staging
GROUP BY company 
ORDER BY 2 DESC ;
WITH my_rolling_total_cte AS (
SELECT company, SUM(total_laid_off) AS total_per
FROM layoffs_staging
GROUP BY company 
ORDER BY 2 DESC 
)
SELECT company , SUM(total_per) AS rolling_total
FROM my_rolling_total_cte 
GROUP BY company
ORDER BY 2 DESC;
SELECT * FROM layoffs_staging;
SELECT SUBSTRING(`date`,1,7) AS `MONTH`
FROM layoffs_staging ;
SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off)
FROM layoffs_staging
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 DESC;
WITH YEAR_MONTHLY_ROLLING_CTE AS
(SELECT SUBSTRING(`date`,1,7) AS `MONTH` , SUM(total_laid_off) AS total_per_year
FROM layoffs_staging
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 DESC) 
SELECT `MONTH`, SUM(total_per_year) AS rolling_total_monthly
FROM YEAR_MONTHLY_ROLLING_CTE 
GROUP BY `MONTH`
ORDER BY `MONTH`;
WITH YEARLY_ROLLING_CTE AS (
SELECT company,YEAR(`date`) AS YEARS, SUM(total_laid_off) AS total ,
 DENSE_RANK() OVER(PARTITION BY YEAR(`date`) ORDER BY SUM(total_laid_off) DESC) AS ranking
 FROM layoffs_staging
 GROUP BY company,YEARS
)
SELECT company,YEARS,total,ranking FROM YEARLY_ROLLING_CTE
WHERE ranking IS NOT NULL AND ranking <= 5
GROUP BY company,YEARS;