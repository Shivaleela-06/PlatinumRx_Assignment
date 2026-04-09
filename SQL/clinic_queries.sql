SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) lb
ON b.user_id = lb.user_id AND b.booking_date = lb.last_booking; 


SELECT sales_channel,
       SUM(amount) AS revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021
GROUP BY sales_channel; 


WITH revenue AS (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS total_revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expense AS (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT r.month,
       r.total_revenue,
       e.total_expense,
       (r.total_revenue - e.total_expense) AS profit,
       CASE 
           WHEN (r.total_revenue - e.total_expense) > 0 THEN 'profitable'
           ELSE 'not-profitable'
       END AS status
FROM revenue r
JOIN expense e ON r.month = e.month; 


FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
expense AS (
    SELECT MONTH(datetime) AS month,
           SUM(amount) AS total_expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT r.month,
       r.total_revenue,
       e.total_expense,
       (r.total_revenue - e.total_expense) AS profit,
       CASE 
           WHEN (r.total_revenue - e.total_expense) > 0 THEN 'profitable'
           ELSE 'not-profitable'
       END AS status
FROM revenue r
JOIN expense e ON r.month = e.month; 


WITH clinic_profit AS (
    SELECT c.city, cs.cid,
           SUM(cs.amount) - COALESCE(SUM(e.amount),0) AS profit
    FROM clinic_sales cs
    JOIN clinics c ON cs.cid = c.cid
    LEFT JOIN expenses e ON cs.cid = e.cid
    WHERE MONTH(cs.datetime) = 9 AND YEAR(cs.datetime) = 2021
    GROUP BY c.city, cs.cid
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT *
FROM ranked
WHERE rnk = 1;
