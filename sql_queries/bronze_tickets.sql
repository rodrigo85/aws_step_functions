SELECT
    ticket_no,
    book_ref,
    passenger_id,
    passenger_name,
    get_json_object(CAST(contact_data AS STRING), '$.email') AS email,
    get_json_object(CAST(contact_data AS STRING), '$.phone') AS phone
FROM
    tickets_raw