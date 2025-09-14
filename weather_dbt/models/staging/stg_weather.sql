{{ config(materialized='view') }}

with source as (
    select *
    from {{ source('raw', 'weather_raw') }}
)

select
    id,
    captured_at,
    location_name,
    (raw_json -> 'location' ->> 'country') as country,
    (raw_json -> 'location' ->> 'lat')::float as latitude,
    (raw_json -> 'location' ->> 'lon')::float as longitude,
    (raw_json -> 'current' ->> 'temperature')::float as temperature_c,
    (raw_json -> 'current' ->> 'humidity')::int as humidity,
    (raw_json -> 'current' ->> 'wind_speed')::float as wind_speed,
    (raw_json -> 'current' ->> 'pressure')::float as pressure,
    raw_json
from source
