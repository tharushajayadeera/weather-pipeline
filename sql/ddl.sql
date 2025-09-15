CREATE DATABASE weatherdb;

CREATE SCHEMA raw;

CREATE TABLE raw.weather_raw (
    id SERIAL PRIMARY KEY,
    captured_at TIMESTAMP DEFAULT now(),
    location_name TEXT,
    raw_json JSONB
);

SELECT * FROM raw.weather_raw;

CREATE SCHEMA analytics;

SELECT * FROM analytics.daily_weather;