
SELECT
    r.origin_city,
    r.origin_state,
    r.destination_city,
    r.destination_state,
    COUNT(t.trip_id) AS total_trips,
    ROUND(AVG(t.actual_distance_miles), 1) AS avg_distance,
    ROUND(SUM(l.revenue + l.fuel_surcharge + l.accessorial_charges), 2) AS gross_revenue
FROM read_csv_auto('trips.csv') t
JOIN read_csv_auto('loads.csv') l ON t.load_id = l.load_id
JOIN read_csv_auto('routes.csv') r ON l.route_id = r.route_id
GROUP BY
    r.origin_city, r.origin_state, r.destination_city, r.destination_state
ORDER BY gross_revenue DESC
LIMIT 5;
