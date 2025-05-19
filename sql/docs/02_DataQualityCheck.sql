--Now, It's time to perform data quality checks on the final table

-- Count all and null values
--SELECT
--  COUNT(*) AS TotalRecords,
--  SUM(CASE WHEN EntidadNacimiento        IS NULL THEN 1 ELSE 0 END) AS Null_EntidadNacimiento,
--  SUM(CASE WHEN MunicipioNacimiento      IS NULL THEN 1 ELSE 0 END) AS Null_MunicipioNacimiento,
--  SUM(CASE WHEN EdadMadre                IS NULL THEN 1 ELSE 0 END) AS Null_EdadMadre,
--  SUM(CASE WHEN SeConsideraIndigena      IS NULL THEN 1 ELSE 0 END) AS Null_IndigenaFlag,
--  SUM(CASE WHEN HoraNacimiento  IS NULL THEN 1 ELSE 0 END) AS Null_FechaHoraBebe
--FROM Nacimientos_Final;


-- Edad madre outliers
--SELECT * FROM Nacimientos_Final
-- WHERE EdadMadre  NOT BETWEEN 18 AND 50
-- ORDER BY EdadMadre DESC;


 --Baby's weight
--SELECT * FROM Nacimientos_Final
-- WHERE Peso NOT BETWEEN 1000 AND 6000;

-- Unexpected values
-- Sexo distinto de H/M
--SELECT DISTINCT Sexo FROM Nacimientos_Final;

-- Indígena different to 1/2
--SELECT DISTINCT SeConsideraIndigena FROM dbo.Nacimientos_Final;

-- Mexico has 32 Entidades Federativas (states) each one of them has a number alphabetically related, we need to ensure if we have 32 values here, if we do not have them, we should called the others at No especificado (Not specified)
--SELECT DISTINCT EntidadNacimiento FROM Nacimientos_Final ORDER BY EntidadNacimiento;
--SELECT DISTINCT EntidadResidencia FROM Nacimientos_Final ORDER BY EntidadResidencia;