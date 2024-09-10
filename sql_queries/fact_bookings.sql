SELECT 
    b.book_ref,
    b.book_date,
    b.total_amount,
    t.ticket_no,
    t.passenger_id,
    t.passenger_name,
    tf.flight_id,
    tf.fare_conditions,
    tf.amount
FROM 
    bookings_bronze b
JOIN 
    tickets_bronze t ON b.book_ref = t.book_ref
JOIN 
    ticket_flights_bronze tf ON t.ticket_no = tf.ticket_no
