SELECT TOP (1000) [Date]
      ,[Machine_ID]
      ,[Assembly_Line_No]
      ,[Hydraulic_Pressure(bar)]
      ,[Coolant_Pressure(bar)]
      ,[Air_System_Pressure(bar)]
      ,[Coolant_Temperature]
      ,[Hydraulic_Oil_Temperature(Â°C)]
      ,[Spindle_Bearing_Temperature(Â°C)]
      ,[Spindle_Vibration(Âµm)]
      ,[Tool_Vibration(Âµm)]
      ,[Spindle_Speed(RPM)]
      ,[Voltage(volts)]
      ,[Torque(Nm)]
      ,[Cutting(kN)]
      ,[Downtime]
      ,[Machine Failure]
  FROM [Machine Downtime].[dbo].['Machine Downtime']

  /*Mean of Machine Downtime*/

  Select 
     AVG([Hydraulic_Pressure(bar)]) as mean_hydraulic_pressure,
	 AVG([Coolant_Pressure(bar)]) as mean_coolant_pressure,
	 AVG([Air_System_Pressure(bar)]) as mean_air_system_pressur,
	 AVG([Coolant_Temperature]) as mean_coolent_temp,
	 AVG([Hydraulic_Oil_Temperature(Â°C)]) as mean_hydraulic_oil_temp,
	 AVG([Spindle_Bearing_Temperature(Â°C)]) as mean_Spindle_bearing_temp,
	 AVG([Spindle_Vibration(Âµm)]) as mean_Spindle_Vibration,
	 AVG([Tool_Vibration(Âµm)]) as mean_tool_vibration,
	 AVG([Spindle_Speed(RPM)]) as mean_spindle_speed,
	 AVG([Voltage(volts)]) as mean_voltage,
	 AVG([Torque(Nm)]) as mean_torque,
	 AVG([Cutting(kN)]) as mean_cutting
  from [Machine Downtime].[dbo].['Machine Downtime']


  /*Mode of Downtime & Machine Failure  */
  WITH RankedValues AS (
    SELECT
        [Downtime],
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS RowNum
    FROM
        [Machine Downtime].[dbo].['Machine Downtime']
    GROUP BY
        [Downtime]
)
SELECT TOP 1
    [Downtime] AS Mode,
    COUNT(*) AS Frequency
FROM
    RankedValues
GROUP BY
    [Downtime]
ORDER BY
    Frequency DESC;

/*machine failure*/

WITH RankedValues AS (
    SELECT
        [Machine Failure],
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS RowNum
    FROM
        [Machine Downtime].[dbo].['Machine Downtime']
    GROUP BY
        [Machine Failure]
)
SELECT TOP 1
    [Machine Failure] AS Mode,
    COUNT(*) AS Frequency
FROM
    RankedValues
GROUP BY
    [Machine Failure]
ORDER BY
    Frequency DESC;



/* Median of Machine downtime*/
SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Hydraulic_Pressure(bar)]) over() AS Median_HydraulicPressure
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Hydraulic_Pressure(bar)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Coolant_Pressure(bar)]) over() AS Median_Coolant_Pressure
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Coolant_Pressure(bar)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Air_System_Pressure(bar)]) over() AS Median_Air_System_Pressure
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Air_System_Pressure(bar)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Coolant_Temperature]) over() AS Median_Coolant_Temperature
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Coolant_Temperature] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Hydraulic_Oil_Temperature(Â°C)]) over() AS Median_Hydraulic_Oil_Temperature
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Hydraulic_Oil_Temperature(Â°C)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Spindle_Bearing_Temperature(Â°C)]) over() AS Median_Spindle_Bearing_Temperature
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Spindle_Bearing_Temperature(Â°C)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Spindle_Vibration(Âµm)]) over() AS Median_Spindle_Vibration
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Spindle_Vibration(Âµm)] < 5002;


SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Tool_Vibration(Âµm)]) over() AS Median_Tool_Vibration
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Tool_Vibration(Âµm)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Spindle_Speed(RPM)]) over() AS Median_Spindle_Speed_RPM
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Spindle_Speed(RPM)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Voltage(volts)]) over() AS Median_Voltage_volts
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Voltage(volts)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Torque(Nm)]) over() AS Median_Torque
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Torque(Nm)] < 5002;

SELECT
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY [Cutting(kN)]) over() AS Median_Cutting
FROM [Machine Downtime].[dbo].['Machine Downtime']
where [Cutting(kN)] < 5002;



/*Variance of Machine Downtime*/
SELECT
	VAR([Hydraulic_Pressure(bar)]) AS Variance_Hydraulic_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime']

SELECT
	VAR([Coolant_Pressure(bar)]) AS Variance_Coolant_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	VAR([Air_System_Pressure(bar)]) AS Variance_Air_System_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	VAR([Coolant_Temperature]) AS Variance_Coolant_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	VAR([Hydraulic_Oil_Temperature(Â°C)]) AS Variance_Hydraulic_Oil_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	VAR([Spindle_Bearing_Temperature(Â°C)]) AS Variance_Spindle_Bearing_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	VAR([Spindle_Vibration(Âµm)]) AS Variance_Spindle_Vibration
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	VAR([Tool_Vibration(Âµm)]) AS Variance_Tool_Vibration
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	VAR([Spindle_Speed(RPM)]) AS Variance_Spindle_Speed_RPM
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	VAR([Voltage(volts)]) AS Variance_Voltage
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	VAR([Torque(Nm)]) AS Variance_Torque
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
    VAR([Cutting(kN)]) AS Variance_Cutting
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

/*Standard_deviation of Machine Downtime*/
SELECT
	STDEV([Hydraulic_Pressure(bar)]) AS Stdv_Hydraulic_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime']

SELECT
	STDEV([Coolant_Pressure(bar)]) AS Stdv_Coolant_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	STDEV([Air_System_Pressure(bar)]) AS Stdv_Air_System_Pressure
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	STDEV([Coolant_Temperature]) AS Stdv_Coolant_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	STDEV([Hydraulic_Oil_Temperature(Â°C)]) AS Stdv_Hydraulic_Oil_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	STDEV([Spindle_Bearing_Temperature(Â°C)]) AS Stdv_Spindle_Bearing_Temperature
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	STDEV([Spindle_Vibration(Âµm)]) AS Stdv_Spindle_Vibration
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	STDEV([Tool_Vibration(Âµm)]) AS Stdv_Tool_Vibration
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	STDEV([Spindle_Speed(RPM)]) AS Stdv_Spindle_Speed_RPM
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	STDEV([Voltage(volts)]) AS Stdv_Voltage
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	STDEV([Torque(Nm)]) AS Stdv_Torque
FROM
   [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
    STDEV([Cutting(kN)]) AS Stdv_Cutting
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];


/*Range of Machine downtime*/
SELECT
	MAX([Hydraulic_Pressure(bar)]) - MIN([Hydraulic_Pressure(bar)]) AS Range_Hydraulic_Pressure
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Coolant_Pressure(bar)]) - MIN([Coolant_Pressure(bar)]) AS Range_Coolant_Pressure
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Air_System_Pressure(bar)]) - MIN([Air_System_Pressure(bar)]) AS Range_Air_System_Pressure
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Coolant_Temperature]) - MIN([Coolant_Temperature]) AS Range_Coolant_Temp
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Hydraulic_Oil_Temperature(Â°C)]) - MIN([Hydraulic_Oil_Temperature(Â°C)]) AS Range_Hydraulic_Oil_Temp
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Spindle_Bearing_Temperature(Â°C)]) - MIN([Spindle_Bearing_Temperature(Â°C)]) AS Range_Spindle_bearing_temp
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Spindle_Vibration(Âµm)]) - MIN([Spindle_Vibration(Âµm)]) AS Range_Spindle_Vibration
FROM
    [Machine Downtime].[dbo].['Machine Downtime']

SELECT
	MAX([Tool_Vibration(Âµm)]) - MIN([Tool_Vibration(Âµm)]) AS Range_Tool_vibration
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
	MAX([Spindle_Speed(RPM)]) - MIN([Spindle_Speed(RPM)]) AS Range_Spindle_speed
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	MAX([Voltage(volts)]) - MIN([Voltage(volts)]) AS Range_Voltage
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
	MAX([Torque(Nm)]) - MIN([Torque(Nm)]) AS Range_Torque
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];


SELECT
    MAX([Cutting(kN)]) - MIN([Cutting(kN)]) AS Range_Cutting
FROM
    [Machine Downtime].[dbo].['Machine Downtime'];

SELECT
    (
        SUM(POWER(salary - (SELECT AVG(salary) FROM employment_info), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(salary) FROM employment_info), 3))
    ) AS skewness,
    (
        (SUM(POWER(salary - (SELECT AVG(salary) FROM employment_info), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(salary) FROM employment_info), 4))) - 3
    ) AS kurtosis
FROM employment_info;

SELECT SKEW(salary) FROM employment_info;




