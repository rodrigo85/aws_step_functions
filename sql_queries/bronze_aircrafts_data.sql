SELECT
    aircraft_code,
    get_json_object(CAST(model AS STRING), '$.en') AS model,
    "range"
FROM
    aircrafts_raw
