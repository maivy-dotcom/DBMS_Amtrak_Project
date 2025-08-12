USE BUDT703_Project_0507_11;

--What are the top ten cities with maximum ridership?
SELECT  OrderedCities.*
FROM (
    SELECT s.stationCity AS 'Station City', AVG(r.ridershipCount) AS 'Average Ridership',
    	RANK() OVER (ORDER BY AVG(r.ridershipCount) DESC) AS 'Rank'
    FROM [Amtrak.Ridership] r, [Amtrak.Station] s
    WHERE  r.stationCode = s.stationCode
    GROUP BY s.stationCity ) OrderedCities
WHERE OrderedCities.Rank <= 10
ORDER BY OrderedCities.Rank;

--Which are the top ten states with the largest year-over-year percentage increase (and the corresponding absolute increase) in guest reward enrollments?
SELECT RankedResults.*
FROM (
    SELECT RANK() OVER (ORDER BY (r2.rewardsMembers - r1.rewardsMembers)*1.0 / r1.rewardsMembers DESC) AS 'Rank', 
		s.stateName AS 'State Name', r1.stateCode AS 'State Code', r1.rewardsYear AS 'Base Year', r2.rewardsYear AS 'Comparison Year',
		FORMAT(CAST(((r2.rewardsMembers - r1.rewardsMembers) * 1.0 / r1.rewardsMembers) AS DECIMAL(10,4)), 'P') AS 'Percent Increase',
        CAST((r2.rewardsMembers-r1.rewardsMembers) AS DECIMAL) AS 'Absolute Increase'
    FROM [Amtrak.Rewards] r1
    INNER JOIN  [Amtrak.Rewards] r2 ON r1.stateCode = r2.stateCode AND r2.rewardsYear = (SELECT MAX(rewardsYear) FROM [Amtrak.Rewards])
        AND r1.rewardsYear = (SELECT MAX(rewardsYear) - 1 FROM [Amtrak.Rewards])
    INNER JOIN [Amtrak.State] s ON r1.stateCode = s.stateCode
    WHERE r1.rewardsMembers > 0  ) RankedResults
WHERE rank <= 10
ORDER BY 'Percent Increase' DESC;

--What are the top ten states with the highest operational efficiency score, based on normalized staffing ratio and on-time performance?
WITH StaffingRatio AS (
    SELECT stateRidership.stateCode, stateRidership.totalRidership, stateEmp.totalEmployees,
        CAST(stateRidership.totalRidership AS FLOAT) / CAST(stateEmp.totalEmployees AS FLOAT)staffingRatio
    FROM (SELECT s.stationStateCode AS stateCode, SUM(r.ridershipCount) AS totalRidership
          FROM[Amtrak.Station] s
          JOIN [Amtrak.Ridership] r ON s.stationCode = r.stationCode
          GROUP BY s.stationStateCode) stateRidership
    LEFT JOIN (SELECT e.stateCode AS stateCode, SUM(e.empCount) AS totalEmployees
						FROM [Amtrak.Employment] e
						GROUP BY e.stateCode) stateEmp ON stateRidership.stateCode = stateEmp.stateCode),
AvgOTP AS (
    SELECT st.stateCode, AVG(routeAvg.otpAvg) AS avgOTP 
    FROM [Amtrak.State] st
    LEFT JOIN
        (SELECT r.routeID,s.stationStateCode AS stateCode,
                AVG(o.OTP) AS otpAvg 
         FROM [Amtrak.Route] r
         JOIN [Amtrak.Consist] c ON r.routeID = c.routeID
         JOIN [Amtrak.Station] s ON c.stationCode = s.stationCode
         JOIN [Amtrak.OTP] o ON r.routeID = o.routeID
         GROUP BY r.routeID, s.stationStateCode) routeAvg
    ON st.stateCode = routeAvg.stateCode
    GROUP BY st.stateCode),
NormalizedMetrics AS (
    SELECT sr.stateCode, sr.staffingRatio, otp.avgOTP,
        (sr.staffingRatio - MIN(sr.staffingRatio) OVER ()) / 
           (MAX(sr.staffingRatio) OVER () - MIN(sr.staffingRatio) OVER ())
        AS normalizedStaffingRatio,
        (otp.avgOTP - MIN(otp.avgOTP) OVER ()) / 
                (MAX(otp.avgOTP) OVER () - MIN(otp.avgOTP) OVER ())
         AS normalizedOTP
    FROM StaffingRatio sr
    LEFT JOIN AvgOTP otp ON sr.stateCode = otp.stateCode)

SELECT RankedNM.[State Name], RankedNM.[Normalized Staffing Ratio], RankedNM.[Normalized OTP], RankedNM.[Operational Efficiency Score]
FROM (
SELECT NM.*, 
       RANK() OVER (ORDER BY NM.[Operational Efficiency Score] DESC) AS Ranking 
FROM (
    SELECT s.stateName AS 'State Name', 
           FORMAT(nm.normalizedStaffingRatio, 'N2') AS 'Normalized Staffing Ratio', 
           FORMAT(nm.normalizedOTP, 'N2') AS 'Normalized OTP',
           FORMAT(nm.normalizedStaffingRatio + nm.normalizedOTP, 'N2') AS 'Operational Efficiency Score'
    FROM NormalizedMetrics nm
	LEFT JOIN [Amtrak.State] s ON nm.stateCode = s.stateCode
) NM ) RankedNM
WHERE RankedNM.Ranking <= 10 
ORDER BY Ranking;   

--What are each route's categories (e.g. Low, Medium, High) based on their on-time performance?
SELECT r.routeName AS 'Route Name', FORMAT(AVG(o.OTP), 'P') AS 'Average OTP Percentage',
  CASE
       WHEN ROUND((AVG(o.OTP)*100),2) < 60 THEN 'Low'
       WHEN ROUND((AVG(o.OTP)*100),2) < 85 THEN 'Medium'
       ELSE 'High'					
   END AS 'Performance Category'
FROM [Amtrak.OTP] o
JOIN [Amtrak.Route] r ON o.routeID = r.routeID
GROUP BY r.routeName
ORDER BY 'Average OTP Percentage' DESC;








