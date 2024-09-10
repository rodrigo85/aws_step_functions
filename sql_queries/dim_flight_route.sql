SELECT
    flight_no,
    departure_airport,
    arrival_airport,
    aircraft_code,
    COLLECT_LIST(day_of_week) AS days_of_week
FROM (
    SELECT
        flight_no,
        departure_airport,
        arrival_airport,
        aircraft_code,
        DAYOFWEEK(scheduled_departure) AS day_of_week
    FROM
        flights_bronze
    GROUP BY
        flight_no, 
        departure_airport, 
        arrival_airport, 
        aircraft_code,
        DAYOFWEEK(scheduled_departure)
) subquery
GROUP BY
    flight_no, 
    departure_airport, 
    arrival_airport, 
    aircraft_code;
