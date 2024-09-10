SELECT
    f.flight_id,
    f.flight_no,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.departure_airport,
    get_json_object(CAST(a1.airport_name AS STRING), '$.en') AS departure_airport_name,
    get_json_object(CAST(a1.city AS STRING), '$.en') AS departure_city,
    f.arrival_airport,
    get_json_object(CAST(a2.airport_name AS STRING), '$.en') AS arrival_airport_name,
    get_json_object(CAST(a2.city AS STRING), '$.en') AS arrival_city,
    f.status,
    f.aircraft_code,
    f.actual_departure,
    f.actual_arrival,
    (f.scheduled_arrival - f.scheduled_departure) AS scheduled_duration,
    CASE
        WHEN f.actual_departure IS NOT NULL AND f.actual_arrival IS NOT NULL THEN
            (f.actual_arrival - f.actual_departure)
        ELSE NULL
    END AS actual_duration
FROM
    flights_bronze f
LEFT JOIN
    airports_bronze a1 ON f.departure_airport = a1.airport_code
LEFT JOIN
    airports_bronze a2 ON f.arrival_airport = a2.airport_code