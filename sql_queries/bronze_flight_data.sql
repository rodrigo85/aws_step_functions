SELECT 
    f.flight_id,
    f.flight_no,
    f.scheduled_departure,
    f.scheduled_arrival,
    f.departure_airport,
    f.arrival_airport,
    f.aircraft_code,
    f.status,
    bp.seat_no
FROM flights_bronze f
LEFT JOIN boarding_passes_bronze bp ON f.flight_id = bp.flight_id;
