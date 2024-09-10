SELECT 
    f.flight_id,
    f.flight_no,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.departure_airport,
    a1.airport_name AS departure_airport_name,
    a1.city AS departure_city,
    f.arrival_airport,
    a2.airport_name AS arrival_airport_name,
    a2.city AS arrival_city,
    f.status,
    f.aircraft_code,
    f.actual_departure,
    f.actual_arrival,
    r.duration AS planned_duration
FROM 
    flights_bronze f
JOIN 
    airports_bronze a1 ON f.departure_airport = a1.airport_code
JOIN 
    airports_bronze a2 ON f.arrival_airport = a2.airport_code
JOIN 
    routes_bronze r ON f.flight_no = r.flight_no
                    AND f.departure_airport = r.departure_airport
                    AND f.arrival_airport = r.arrival_airport
