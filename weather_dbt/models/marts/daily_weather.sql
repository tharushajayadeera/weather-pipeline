{{ config(materialized='table') }}

select
    date_trunc('day', captured_at) as day,
    location_name,
    count(*) as samples,
    avg(temperature_c) as avg_temp_c,
    min(temperature_c) as min_temp_c,
    max(temperature_c) as max_temp_c,
    avg(humidity) as avg_humidity
from {{ ref('stg_weather') }}
group by 1,2
order by 1 desc
