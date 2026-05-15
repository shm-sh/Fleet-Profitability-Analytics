
-- Step A: Define the CTE to aggregate base metrics per driver
WITH DriverAggregations AS (
    SELECT
        d.driver_id,
        d.first_name || ' ' || d.last_name AS driver_name,
        d.years_experience,
        COUNT(t.trip_id) AS total_trips,
        SUM(t.actual_distance_miles) AS total_miles,
        SUM(t.idle_time_hours) AS total_idle_hours,
        SUM(t.actual_duration_hours) AS total_duration_hours,
        AVG(t.average_mpg) AS avg_mpg
    FROM read_csv_auto('trips.csv') t
    JOIN read_csv_auto('drivers.csv') d ON t.driver_id = d.driver_id
    WHERE d.employment_status = 'Active'
    GROUP BY d.driver_id, d.first_name, d.last_name, d.years_experience
)
-- Step B: Query the CTE and apply business logic using CASE statements
SELECT
    driver_name,
    years_experience,
    total_trips,
    ROUND(avg_mpg, 2) AS avg_mpg,
    ROUND((total_idle_hours / NULLIF(total_duration_hours, 0)) * 100, 1) AS idle_percentage,
    CASE
        WHEN avg_mpg < 6.0 AND (total_idle_hours / NULLIF(total_duration_hours, 0)) > 0.25
            THEN 'High Risk - Retrain'
        WHEN (total_idle_hours / NULLIF(total_duration_hours, 0)) > 0.20
            THEN 'Monitor Idling'
        ELSE 'Excellent Driver'
    END AS efficiency_status
FROM DriverAggregations
WHERE total_miles > 500
ORDER BY idle_percentage DESC
LIMIT 10;
