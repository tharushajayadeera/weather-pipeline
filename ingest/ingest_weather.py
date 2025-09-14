import os
import json
import requests
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Load secrets from .env file
load_dotenv()

API_KEY = os.getenv("WEATHERSTACK_API_KEY")
DB_URL = os.getenv("DB_URL")

# Locations you want to fetch
LOCATIONS = ["Colombo", "London", "New York"]

# Setup database connection
engine = create_engine(DB_URL)

def fetch_weather(city):
    url = "http://api.weatherstack.com/current"
    params = {"access_key": API_KEY, "query": city, "units": "m"}
    resp = requests.get(url, params=params, timeout=10)
    resp.raise_for_status()
    return resp.json()

def insert_raw(city, payload):
    with engine.begin() as conn:
        conn.execute(
            text("INSERT INTO raw.weather_raw (location_name, raw_json) VALUES (:loc, CAST(:raw AS JSONB))"),
            {"loc": payload["location"]["name"], "raw": json.dumps(payload)}
        )

def main():
    for city in LOCATIONS:
        try:
            data = fetch_weather(city)
            insert_raw(city, data)
            print(f"✅ Inserted data for {city}")
        except Exception as e:
            print(f"❌ Error for {city}: {e}")

if __name__ == "__main__":
    main()