
WITH CustomerRevenue AS (
    SELECT
        c.customer_name,
        SUM(l.revenue + l.fuel_surcharge + l.accessorial_charges) AS total_revenue
    FROM read_csv_auto('loads.csv') l
    JOIN read_csv_auto('customers.csv') c ON l.customer_id = c.customer_id
    GROUP BY c.customer_name
    HAVING SUM(l.revenue) > 0
),
RankedCustomers AS (
    SELECT
        customer_name,
        total_revenue,
        -- Calculate Running Cumulative Revenue
        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total_revenue,
        -- Calculate Grand Total Company Revenue
        SUM(total_revenue) OVER () AS grand_total_revenue
    FROM CustomerRevenue
)
SELECT
    customer_name,
    ROUND(total_revenue, 2) AS account_revenue,
    ROUND(running_total_revenue, 2) AS cumulative_revenue,
    ROUND((running_total_revenue / grand_total_revenue) * 100, 2) AS cumulative_pct_of_total
FROM RankedCustomers
ORDER BY total_revenue DESC
LIMIT 12;
