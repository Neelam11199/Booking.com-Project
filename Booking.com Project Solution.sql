-- 1. Dealing With Nulls

UPDATE bookings
SET
    children = COALESCE(children, 0),
    agent = COALESCE(agent, 0),
    country = COALESCE(country, 'Unknown'),
    stays_in_weekend_nights = COALESCE(stays_in_weekend_nights, 0),
    price = COALESCE(
        price,
        (
            SELECT ROUND(AVG(price), 2)
            FROM booking_view
        )
    );



-- 2. Dealing With Duplicates

DROP VIEW IF EXISTS booking_view;

CREATE VIEW booking_view AS
SELECT *
FROM (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY booking_id ORDER BY booking_id) AS rn
    FROM bookings
) AS subquery
WHERE rn = 1;




-- Key data insights

-- What is the overall cancellation rate for hotel bookings?

WITH Totalbookings AS (
    SELECT COUNT(*) AS total_bookings
    FROM booking_view
),
CancelledBookings AS (
    SELECT COUNT(*) AS total_cancellations
    FROM booking_view
    WHERE is_canceled > 0
)
SELECT 
    ROUND((CancelledBookings.total_cancellations * 100.0) / Totalbookings.total_bookings, 2) AS cancellation_rate
FROM 
    CancelledBookings, 
    Totalbookings;

	
-- Which Countries are the top contributors to hotel bookings?

SELECT 
    country,
    ROUND(SUM(price), 2) AS total_contribution
FROM booking_view
GROUP BY country
ORDER BY total_contribution DESC
LIMIT 5;


-- What are the main market segments booking the hotels, such as leisure or corporate?

SELECT 
    market_segment,
    ROUND(SUM(price), 2) AS total_contribution
FROM 
    booking_view
WHERE 
    market_segment != 'Undefined'
GROUP BY 
    market_segment;


-- Is there a relationship between deposit type (e.g., non-refundable, refundable) and the likelihood of cancellation?

WITH total_cancellations AS (
    SELECT COUNT(*) AS total
    FROM booking_view
    WHERE is_canceled > 0
),
cancellations_by_deposit_type AS (
    SELECT 
        deposit_type, 
        SUM(is_canceled) AS by_deposit
    FROM booking_view
    WHERE is_canceled > 0
    GROUP BY deposit_type
)
SELECT 
    cbd.deposit_type,
    ROUND((cbd.by_deposit * 100.0) / tc.total, 2) AS cancellation_rate
FROM 
    cancellations_by_deposit_type cbd,
    total_cancellations tc;



-- What meal options are most preferred by guests?

SELECT 
meal,
COUNT(*) Total_meals
FROM booking_view
GROUP BY meal
ORDER BY Total_meals DESC
LIMIT 3;

-- How do prices vary across different hotels ? Are there any seasonal pricing trends?
SELECT 
    hotel,
    DATE_FORMAT(booking_date, '%b') AS booking_month,
    ROUND(AVG(price), 2) AS average_price
FROM 
    booking_view
GROUP BY 
    hotel, 
    booking_month,
    MONTH(booking_date)
ORDER BY
    hotel,
    MONTH(booking_date);




-- What percentage of bookings require car parking spaces, and does this vary by hotel location or other factors?

SELECT 
    hotel,
    country,
    ROUND(SUM(required_car_parking_spaces) * 100.0 / 
          (SELECT SUM(required_car_parking_spaces) FROM booking_view), 2) AS parking_spaces_percentage
FROM 
    booking_view
WHERE 
    required_car_parking_spaces > 0
GROUP BY 
    hotel, country
ORDER BY 
    parking_spaces_percentage DESC;


-- What are the main reservation statuses and what are there percentage? 

SELECT 
    reservation_status,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM booking_view), 2) AS count_of_reservation_status_percentage
FROM 
    booking_view
GROUP BY 
    reservation_status
ORDER BY 
    count_of_reservation_status_percentage DESC;



-- How do reservation_status change over time? 

SELECT 
    reservation_status,
    COUNT(*) AS count_of_reservation_status,
    YEAR(booking_date) AS reservation_year
FROM 
    booking_view
GROUP BY 
    reservation_status, reservation_year
ORDER BY 
    reservation_year DESC;



-- What is the distribution of guests based on the number of adults, children, and stays in weekend nights?

SELECT 
adults,
children, 
stays_in_weekend_nights,
COUNT(*) AS bookings
FROM booking_view
GROUP BY adults, children, stays_in_weekend_nights
ORDER BY bookings DESC;


-- Which email domains are most commonly used for making hotel bookings? 

SELECT 
    SUBSTRING(email, LOCATE('@', email) + 1) AS email_domain
FROM 
    booking_view
GROUP BY 
    email_domain;



-- Are there any frequently occurring names in hotel bookings, and do they exhibit any specific booking patterns? 

SELECT 
    name, 
    COUNT(*) AS total_bookings
FROM 
    booking_view
GROUP BY 
    name
ORDER BY 
    total_bookings DESC;

		
-- Which market segments contribute the most revenue to the hotels?

SELECT 
    market_segment,
    ROUND((SUM(price) * 100.0 / (SELECT SUM(price) FROM booking_view)), 2) AS total_revenue_percentage
FROM 
    booking_view
GROUP BY 
    market_segment
ORDER BY 
    total_rev_


-- How do booking patterns vary across different seasons or months of the year?

SELECT 
    QUARTER(booking_date) AS booking_year_quarter,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM booking_view), 2) AS total_booking_percentage
FROM 
    booking_view
GROUP BY 
    QUARTER(booking_date)
ORDER BY 
    total_booking_percentage DESC;

