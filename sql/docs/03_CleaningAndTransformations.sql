-- We (made in purpose) have two digits for number from 1 to 9 (01) in column EntidadResidencia but column EntidadNacimiento does not have, We'll  normalize the table
--ALTER TABLE Nacimientos_Final
--ADD EntidadNacNor AS RIGHT('00' + CAST (EntidadNacimiento AS VARCHAR(2)),2) PERSISTED;

--Now let's create the Dimentional for Entidades
-- We beging creating and populating with the 32 federative entities
--CREATE TABLE Dim_Entidad (
--  EntidadID     TINYINT      NOT NULL  PRIMARY KEY,   -- 1–32
--  EntidadCode   CHAR(2)      NOT NULL, -- zero-padded code: '01' … '32'
--  EntidadNombre VARCHAR(100) NOT NULL  -- full name
--);
--GO

--Populate table

-- Cheking outliers
--SELECT SeConsideraIndigena, COUNT(SeConsideraIndigena) FROM Nacimientos_Final
--GROUP BY SeConsideraIndigena

-- We have 0 and 9 values that should not be listed, let's explore them checking which entities belong or months(to ensure if there is a data error by capture)
--SELECT B.EntidadNombre AS NombreEntidadNacimiento,A.SeConsideraIndigena,COUNT(*) AS Registros
--FROM Nacimientos_Final AS A
--INNER JOIN Dim_Entidad AS B
--  ON A.EntidadNacimiento = B.EntidadID
--WHERE A.SeConsideraIndigena IN ('0','9')
--GROUP BY
--  B.EntidadNombre, A.SeConsideraIndigena
--ORDER BY
--  Registros DESC,B.EntidadNombre ;

--The most native (indigenas) populated states (entidades federativas) in mexico are Oaxaca, Chiapas Yucatan and Guerrero, that does not fit with data but we need now to ensure when these mistakes have been done analyzing  
--At this moment we noticed that  we need to have FechaNacimiento (date of birth), and it's values from Nacimientos_2023Stg.FECHANACIMIENTO but we will face one little problem: FECHANACIMIENTO is missing the last '3'  because format is in DD/MM/YYY 
--Let's work on it 
--Add column to the table 
--ALTER TABLE Nacimientos_Final
--ADD FechaNacimiento DATE;

--Now let's populate the new column using the data from FECHANACIMIENTO
--UPDATE A
--SET A.FechaNacimiento =TRY_CONVERT(
--	DATE,
--	CONCAT(
--		LEFT(STUFF(B.FECHANACIMIENTO,1,1,''),2), --Day
--		'/',
--		SUBSTRING(STUFF(B.FECHANACIMIENTO,1,1,''),4,2), --Month
--	'/2023'
--	),
--	103 --DD/MM/YYYY style
--)
--FROM Nacimientos_Final 
--INNER JOIN Nacimientos_2023Stg B ON A.ID=A.ID;

--As you may see we do not have 
--UPDATE f
--SET f.FechaNacimiento = TRY_CONVERT(
--    DATE, 
--    CONCAT(
--        LEFT(STUFF(n23.FECHANACIMIENTO, 1, 1, ''), 2),  -- Day
--        '/',
--        SUBSTRING(STUFF(n23.FECHANACIMIENTO, 1, 1, ''), 4, 2),  -- Month
--        '/2023'  -- Year
--    ),
--    103  -- Format DD/MM/YYYY
--)
--FROM Nacimientos_Final f
--INNER JOIN Nacimientos_2023Stg n23
--    ON f.ID = n23.ID; -- Ensure Join is correct

--Good now it's time to ensure if mistakes regarding SeConsideraIndigena are related to date
--SELECT FechaNacimiento AS Fecha,SeConsideraIndigena, COUNT(*) AS Registros
--FROM Nacimientos_Final
--WHERE SeConsideraIndigena IN ('0','9')
--GROUP BY SeConsideraIndigena, 
--ORDER BY Fecha;

-- Data distribution is uniform for FechaNacimiento as well EntidadNombre, this confirms is not a BIAS case, it's just a unknown value not showed. 
--We have two way to consider here: Keep values for quality control purposes or convert to NULL for Analysis.
-- A best practice is to add aditional columns keep 0's and 9's to keep data trnasparency and data capture monitoring
--NULL conversion for more clean models  and use of two simple categories
--Let's create the columns:
--ALTER TABLE Nacimientos_Final
--ADD 
--	SeConsideraIndigenaQ VARCHAR(15) NULL, 
--	SeConsideraIndigenaA VARCHAR(15) NULL;

--UPDATE Nacimientos_Final
--SET SeConsideraIndigenaQ=
--	CASE
--		WHEN SeConsideraIndigena IN ('1','2') THEN 'Bueno' --Good data
--		WHEN SeConsideraIndigena IN ('0','9') THEN 'Sospechoso' --Suspicious
--		ELSE NULL 
--	END,

--SeConsideraIndigenaA=
--	CASE 
--		WHEN SeConsideraIndigena =1 THEN 'Si'
--		WHEN SeConsideraIndigena =2 THEN 'No'
--		WHEN SeConsideraIndigena IN ('0','9') THEN 'No definido'
--		ELSE NULL
--	END;


-- If we evaluate now HablaLenguaIndigena
--SELECT COUNT(*), HablaLenguaIndigena
--FROM Nacimientos_Final GROUP BY HablaLenguaIndigena;

--We see as well we have values 0 and 9 thaty we will need to create two new columns
--ALTER TABLE Nacimientos_Final
--ADD
--HablaLenguaIndigenaQ VARCHAR(15) NULL, --For data quality
--HablaLenguaIndigenaA VARCHAR(15) NULL; --For analysis

--Let's populate the columns
--UPDATE Nacimientos_Final
--SET HablaLenguaIndigenaQ=
--	CASE
--		WHEN HablaLenguaIndigena IN ('1','2') THEN 'Bueno' --Good data
--		WHEN HablaLenguaIndigena IN ('0','9') THEN 'Sospechoso' --Suspicious
--		ELSE NULL 
--	END,

--HablaLenguaIndigenaA=
--	CASE 
--		WHEN HablaLenguaIndigena =1 THEN 'Si'
--		WHEN HablaLenguaIndigena =2 THEN 'No'
--		WHEN HablaLenguaIndigena IN ('0','9') THEN 'No definido'
--		ELSE NULL
--	END;

--Let's check how many values has SobrevivioParto
--SELECT COUNT(*) AS Registros, SobrevivioParto FROM Nacimientos_Final GROUP BY SobrevivioParto;

-- As we see there are three values, considering table logic, 1 means 'Si', 2 means 'No' and '0' and is are not identified.
-- Let's proceed as the same way like HablaLenguaIndigena

--ALTER TABLE Nacimientos_Final
--ADD
--SobrevivioPartoQ VARCHAR(15) NULL, --For data quality
--SobrevivioPartoA VARCHAR(15) NULL; --For analysis

--UPDATE Nacimientos_Final
--SET SobrevivioPartoQ=
--	CASE
--		WHEN SobrevivioParto IN ('1','2') THEN 'Bueno' --Good data
--		WHEN SobrevivioParto ='0' THEN 'Sospechoso' --Suspicious
--		ELSE NULL 
--	END,

--SobrevivioPartoA=
--	CASE 
--		WHEN SobrevivioParto =1 THEN 'Si'
--		WHEN SobrevivioParto =2 THEN 'No'
--		WHEN SobrevivioParto IN ('0','8','9') THEN 'No definido'
--		ELSE NULL
--	END;

--It's time to check InterrumpioEstudios
--SELECT COUNT(*) AS Registros, InterrumpioEstudios FROM Nacimientos_Final GROUP BY InterrumpioEstudios;

-- As we see there are five values values, considering table logic, 1 means 'Si', 2 means 'No' and '0','9','8',' are not identified.
-- Let's proceed as the same way like before

--ALTER TABLE Nacimientos_Final
--ADD
--InterrumpioEstudiosQ VARCHAR(15) NULL, --For data quality
--InterrumpioEstudiosA VARCHAR(15) NULL; --For analysis

--UPDATE Nacimientos_Final
--SET SobrevivioPartoQ=
--	CASE
--		WHEN InterrumpioEstudios IN ('1','2') THEN 'Bueno' --Good data
--		WHEN InterrumpioEstudios IN('0','8','9') THEN 'Sospechoso' --Suspicious
--		ELSE NULL 
--	END,

--InterrumpioEstudiosA=
--	CASE 
--		WHEN InterrumpioEstudios =1 THEN 'Si'
--		WHEN InterrumpioEstudios =2 THEN 'No'
--		WHEN InterrumpioEstudios IN('0','8','9') THEN 'No definido'
--		ELSE NULL
--	END;

-- Let's ensure data quality with TrabajaActualmente 
--SELECT COUNT(*) AS Registros, TrabajaActualmente FROM Nacimientos_Final GROUP BY TrabajaActualmente;

-- As we see there are five values values, considering table logic, 1 means 'Si', 2 means 'No' and '0','9','8',' are not identified.
-- Let's proceed as the same way like before

--ALTER TABLE Nacimientos_Final
--ADD
--TrabajaActualmenteQ VARCHAR(15) NULL, --For data quality
--TrabajaActualmenteA VARCHAR(15) NULL; --For analysis

--UPDATE Nacimientos_Final
--SET TrabajaActualmenteQ=
--	CASE
--		WHEN TrabajaActualmente IN ('1','2') THEN 'Bueno' --Good data
--		WHEN TrabajaActualmente IN('0','8','9') THEN 'Sospechoso' --Suspicious
--		ELSE NULL 
--	END;

--UPDATE Nacimientos_Final
--SET TrabajaActualmenteA=
--	CASE
--		WHEN TrabajaActualmente ='1' THEN 'Si' 
--		WHEN TrabajaActualmente ='2' THEN 'No' 
--		WHEN TrabajaActualmente IN('0','8','9') THEN 'No especificado' 
--		ELSE NULL 
--	END;

--UPDATE Nacimientos_Final
--SET InterrumpioEstudiosA=
--	CASE 
--		WHEN InterrumpioEstudios =1 THEN 'Si'
--		WHEN InterrumpioEstudios =2 THEN 'No'
--		WHEN InterrumpioEstudios IN('0','8','9') THEN 'No definido'
--		ELSE NULL
--	END;

--UPDATE Nacimientos_Final
--SET InterrumpioEstudiosQ=
--	CASE 
--		WHEN InterrumpioEstudios IN ('1','2') THEN 'Bueno'
--		WHEN InterrumpioEstudios IN('0','8','9') THEN 'Sospechoso'
--		ELSE NULL
--	END;

-- Let's take a look with Sexo 
--SELECT AVG(CAST(Talla AS FLOAT)) AS AvgTalla, AVG(CAST(Peso AS FLOAT)) AS AvgPeso, MAX(Talla) AS MaxTalla, MAX(Peso) AS MaxPeso, MIN(Talla) AS MinTalla, MIN(Peso) As MinPeso, COUNT(*) AS Conteo, Sexo 
--FROM Nacimientos_Final 
--GROUP BY Sexo;
 
 --As we may see, results regarding MAX and MIN values may causing biases in our calculations. We need to determine which value of 1 or 2 should need to assign to Sex. So let's "clean" these outliers
 --First, How many "impossible" values are there? LEt's define plausible ranges for newborns.Height between 40 cm and 60 cm and Weight between 1500 g and 6000 g
-- SELECT Sexo,
--  SUM(CASE WHEN CAST(Talla AS INT)   NOT BETWEEN 40 AND 60   THEN 1 ELSE 0 END) AS Outliers_Talla,
--  SUM(CASE WHEN CAST(Peso  AS INT)   NOT BETWEEN 1500 AND 6000 THEN 1 ELSE 0 END) AS Outliers_Peso,
--  COUNT(*) AS Total
--FROM Nacimientos_Final
--GROUP BY Sexo;

--Now, Let's employ robust statistics as IQR (Interquartile range) to exclude values
--WITH CTE_stats AS (
--	SELECT DISTINCT
--		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CAST(Talla AS FLOAT)) OVER() AS Q1_Talla,
--		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CAST(Talla AS FLOAT)) OVER() AS Q3_Talla,
--		PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY CAST(Peso AS FLOAT)) OVER() AS Q1_Peso,
--		PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY CAST(Peso AS FLOAT)) OVER() AS Q3_Peso
--	FROM Nacimientos_Final
--)
--, CTE_filtered AS(
--	SELECT * FROM Nacimientos_Final
--	CROSS JOIN CTE_stats
--	WHERE
--		CAST(Talla AS FLOAT) BETWEEN (Q1_Talla - 1.5*(Q3_Talla - Q1_Talla))
--								AND (Q3_Talla + 1.5*(Q3_Talla - Q1_Talla))
--	AND CAST(Peso AS FLOAT) BETWEEN (Q1_Peso -1.5*(Q3_Peso - Q1_Peso))
--								AND (Q3_Peso+1.5*(Q3_Peso - Q1_Peso))
--)
--SELECT
--	Sexo,
--	AVG(CAST(Talla AS FLOAT)) AS AvgTalla,
--	AVG(CAST(Peso AS FLOAT)) AS AvgPeso,
--	MIN(CAST(Talla AS FLOAT)) AS MinTalla,
--	MAX(CAST(Talla AS FLOAT)) AS MaxTalla,
--	MIN(CAST(Peso AS FLOAT)) AS MinPeso,
--	MAX(CAST(Peso AS FLOAT)) AS MaxPeso,
--	COUNT(*) AS Recuento
--FROM CTE_filtered
--GROUP BY Sexo;

-- Now we will change data type for Sexo column in order to be able to handle values like 'H','M' or 'No especificado'
--ALTER TABLE Nacimientos_Final
--ALTER COLUMN Sexo VARCHAR(20);
--Let's populate the table
--UPDATE Nacimientos_Final
--SET Sexo =CASE
--	WHEN Sexo='1' THEN 'Hombre' --Male
--	WHEN Sexo='2' THEN 'Mujer' --Female
--	ELSE 'No especificado' -- Not specified
--END;

--And finally let's change HoraNacimiento and TiempoTraslado in order to get just HH:MM:SS
--ALTER TABLE Nacimientos_Final
--ALTER COLUMN HoraNacimiento TIME(0) NULL;

--ALTER TABLE Nacimientos_Final
--ALTER COLUMN TiempoTraslado TIME(0) NULL;