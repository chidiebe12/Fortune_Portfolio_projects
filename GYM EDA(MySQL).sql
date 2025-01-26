SELECT * FROM gym_members_exercise_tracking;
CREATE TABLE gym_members_exercise_worksheet LIKE gym_members_exercise_tracking;
INSERT INTO gym_members_exercise_worksheet 
SELECT * FROM  gym_members_exercise_tracking;
SELECT * FROM gym_members_exercise_worksheet;
-- Age group/Average calories burned
SELECT 
CASE 
WHEN Age BETWEEN 18 AND 24 THEN "18-24"
WHEN Age BETWEEN 25 AND 34 THEN '25-34'
WHEN Age BETWEEN 35 AND 44 THEN '35-44'
WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
END AS Age_Bracket,
AVG(Calories_Burned) AS Average_Calories_burned
FROM gym_members_exercise_worksheet
GROUP BY Age_Bracket
;
ALTER TABLE gym_members_exercise_worksheet
ADD COLUMN Age_Bracket VARCHAR(10) AS (
CASE
WHEN Age BETWEEN 18 AND 24 THEN "18-24"
WHEN Age BETWEEN 25 AND 34 THEN '25-34'
WHEN Age BETWEEN 35 AND 44 THEN '35-44'
WHEN Age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
    END
)  ;
-- Workout_Type / Average Calories burned

SELECT * FROM gym_members_exercise_worksheet;
SELECT Workout_Type, AVG(Calories_Burned) AS Average_Calories_burned
FROM gym_members_exercise_worksheet
GROUP BY Workout_Type ;
SELECT * FROM gym_members_exercise_worksheet;
-- BMI Category Analysis
SELECT 
CASE 
WHEN BMI < 18.5 THEN 'Underweight'
WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'Normal Weight'
WHEN BMI BETWEEN 25 AND 29.9 THEN 'Overweight'
ELSE 'Obese'
END AS BMI_Category, 
COUNT(*) AS Num_members,
ROUND((COUNT(*)/(SELECT COUNT(*) FROM gym_members_exercise_worksheet))* 100,2) AS percentage 
FROM gym_members_exercise_worksheet
GROUP BY BMI_Category;
SELECT * FROM gym_members_exercise_worksheet;
-- Top 10 Members by Calories Burned
ALTER TABLE gym_members_exercise_worksheet
ADD COLUMN Member_ID INT PRIMARY KEY AUTO_INCREMENT ;
SELECT * FROM gym_members_exercise_worksheet;
SELECT Member_ID , Calories_Burned 
FROM gym_members_exercise_worksheet
ORDER BY Calories_Burned DESC
LIMIT 10;
SELECT * FROM gym_members_exercise_worksheet;
-- Avergae water intake by workout_frequency 
SELECT `Workout_Frequency (days/week)`, `Water_Intake (liters)`
FROM gym_members_exercise_worksheet
GROUP BY `Workout_Frequency (days/week)`;
SELECT * FROM gym_members_exercise_worksheet;
-- Member Distribution by Experience Level
SELECT Experience_level , COUNT(*),
ROUND((COUNT(*)/(SELECT COUNT(*) FROM gym_members_exercise_worksheet))*100 , 2)
AS Percentage_Experience_level 
FROM gym_members_exercise_worksheet
GROUP BY Experience_level;
SELECT * FROM gym_members_exercise_worksheet;
-- Calories Burned by Workout Type and Age Group
SELECT Workout_Type , Age_Bracket, AVG(Calories_Burned) AS Average_Calories_burned
FROM gym_members_exercise_worksheet
GROUP BY Workout_Type , Age_Bracket;
SELECT * FROM gym_members_exercise_worksheet;
-- Resting BPM Distribution
SELECT 
CASE 
WHEN Resting_BPM BETWEEN 60 AND 80 THEN '60-80'
    WHEN Resting_BPM BETWEEN 81 AND 100 THEN '81-100'
ELSE 'Above 100'
END AS Resting_BPM_bracket , COUNT(*),
ROUND((COUNT(*)/(SELECT COUNT(*) FROM gym_members_exercise_worksheet ))*100,2) AS 
Percentage_Resting_BPM 
FROM gym_members_exercise_worksheet 
GROUP BY Resting_BPM_bracket;
SELECT * FROM gym_members_exercise_worksheet;
-- Session Duration by Workout Type
SELECT Workout_Type , AVG(`Session_Duration (hours)`) AS AvgSessionDuration
FROM gym_members_exercise_worksheet
GROUP BY Workout_Type;