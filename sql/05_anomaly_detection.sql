
WITH RouteStatistics AS (
    SELECT
        t.trip_id,
        l.route_id,
        r.origin_city || ' to ' || r.destination_city AS lane_name,
        t.actual_duration_hours,
        -- Calculate lane-specific mean and standard deviation dynamically
        AVG(t.actual_duration_hours) OVER (PARTITION BY l.route_id) AS lane_avg_duration,
        STDDEV_POP(t.actual_duration_hours) OVER (PARTITION BY l.route_id) AS lane_stddev_duration
    FROM read_csv_auto('trips.csv') t
    JOIN read_csv_auto('loads.csv') l ON t.load_id = l.load_id
    JOIN read_csv_auto('routes.csv') r ON l.route_id = r.route_id
    WHERE t.actual_duration_hours > 0
),
ZScoreCalculations AS (
    SELECT
        trip_id,
        lane_name,
        actual_duration_hours,
        ROUND(lane_avg_duration, 1) AS typical_lane_hours,
        -- Calculate Z-Score: (Value - Mean) / Standard Deviation
        ROUND((actual_duration_hours - lane_avg_duration) / NULLIF(lane_stddev_duration, 0), 2) AS z_score
    FROM RouteStatistics
    WHERE lane_stddev_duration > 0
)
SELECT
    trip_id,
    lane_name,
    actual_duration_hours,
    typical_lane_hours,
    z_score,
    CASE
        WHEN z_score > 2.5 THEN 'CRITICAL DETENTION OUTLIER (>2.5 SD)'
        WHEN z_score < -2.5 THEN 'SUSPICIOUSLY FAST OUTLIER (<-2.5 SD)'
        ELSE 'Normal Variance'
    END AS statistical_classification
FROM ZScoreCalculations
WHERE ABS(z_score) > 2.0
ORDER BY z_score DESC
LIMIT 10;
