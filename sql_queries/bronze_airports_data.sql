SELECT
    airport_code,
    get_json_object(CAST(airport_name AS STRING), '$.en') AS airport_name,
    get_json_object(CAST(city AS STRING), '$.en') AS city,
    coordinates,
    timezone
FROM
    airports_raw