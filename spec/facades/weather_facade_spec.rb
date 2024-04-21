require 'rails_helper'
RSpec.describe WeatherFacade do
  describe '#get_forecast_data' do
    let(:location) { 'Newport' }
    let(:forecast_data) do
      {
        "location": {
          "name": "Newport",
          "region": "Kentucky",
          "country": "United States of America",
          "lat": 39.11,
          "lon": -84.5,
          "tz_id": "America/New_York",
          "localtime_epoch": 1713722072,
          "localtime": "2024-04-21 13:54"
        },
        "current": {
          "last_updated_epoch": 1713721500,
          "last_updated": "2024-04-21 13:45",
          "temp_c": 8.9,
          "temp_f": 48.0,
          "is_day": 1,
          "condition": {
            "text": "Overcast",
            "icon": "//cdn.weatherapi.com/weather/64x64/day/122.png",
            "code": 1009
          },
          "wind_mph": 2.2,
          "wind_kph": 3.6,
          "wind_degree": 330,
          "wind_dir": "NNW",
          "pressure_mb": 1022.0,
          "pressure_in": 30.17,
          "precip_mm": 0.01,
          "precip_in": 0.0,
          "humidity": 49,
          "cloud": 100,
          "feelslike_c": 7.1,
          "feelslike_f": 44.8,
          "vis_km": 16.0,
          "vis_miles": 9.0,
          "uv": 2.0,
          "gust_mph": 8.0,
          "gust_kph": 12.9
        },
        "forecast": {
          "forecastday": [
            {
              "date": "2024-04-21",
              "date_epoch": 1713657600,
              "day": {
                "maxtemp_c": 11.8,
                "maxtemp_f": 53.3,
                "mintemp_c": 1.9,
                "mintemp_f": 35.4,
                "avgtemp_c": 6.4,
                "avgtemp_f": 43.6,
                "maxwind_mph": 9.4,
                "maxwind_kph": 15.1,
                "totalprecip_mm": 0.0,
                "totalprecip_in": 0.0,
                "totalsnow_cm": 0.0,
                "avgvis_km": 10.0,
                "avgvis_miles": 6.0,
                "avghumidity": 57,
                "daily_will_it_rain": 0,
                "daily_chance_of_rain": 0,
                "daily_will_it_snow": 0,
                "daily_chance_of_snow": 0,
                "condition": {
                  "text": "Partly Cloudy ",
                  "icon": "//cdn.weatherapi.com/weather/64x64/day/116.png",
                  "code": 1003
                },
                "uv": 6.0
              },
              "astro": {
                "sunrise": "06:52 AM",
                "sunset": "08:21 PM",
                "moonrise": "06:23 PM",
                "moonset": "05:50 AM",
                "moon_phase": "Waxing Gibbous",
                "moon_illumination": 92,
                "is_moon_up": 1,
                "is_sun_up": 1
              },
              "hour": [
                {
                  "time_epoch": 1713672000,
                  "time": "2024-04-21 00:00",
                  "temp_c": 4.8,
                  "temp_f": 40.7,
                  "is_day": 0,
                  "condition": {
                    "text": "Clear ",
                    "icon": "//cdn.weatherapi.com/weather/64x64/night/113.png",
                    "code": 1000
                  },
                  "wind_mph": 5.1,
                  "wind_kph": 8.3,
                  "wind_degree": 328,
                  "wind_dir": "NNW",
                  "pressure_mb": 1022.0,
                  "pressure_in": 30.17,
                  "precip_mm": 0.0,
                  "precip_in": 0.0,
                  "snow_cm": 0.0,
                  "humidity": 66,
                  "cloud": 6,
                  "feelslike_c": 2.9,
                  "feelslike_f": 37.3,
                  "windchill_c": 2.9,
                  "windchill_f": 37.3,
                  "heatindex_c": 4.8,
                  "heatindex_f": 40.7,
                  "dewpoint_c": -1.1
                }
              ]
            }
          ]
        }
      }
    end

    it 'returns the forecast data' do
      allow_any_instance_of(LocationService).to receive(:get_coordinates).with(location).and_return("#{forecast_data[:location][:lat]},#{forecast_data[:location][:lon]}")
      allow_any_instance_of(ForecastService).to receive(:get_forecast).and_return(forecast_data)

      facade = WeatherFacade.new(location)
      forecast_data = facade.get_forecast_data

      expect(forecast_data).to include({
        current_weather: {
          last_updated: '2024-04-21 13:45',
          temperature: 48.0,
          feels_like: 44.8,
          humidity: 49,
          uvi: 2.0,
          visibility: 9.0,
          condition: 'Overcast',
          icon: '//cdn.weatherapi.com/weather/64x64/day/122.png'
        },
        daily_weather: [
          {
            date: '2024-04-21',
            sunrise: '06:52 AM',
            sunset: '08:21 PM',
            max_temp: 53.3,
            min_temp: 35.4,
            condition: 'Partly Cloudy ',
            icon: '//cdn.weatherapi.com/weather/64x64/day/116.png'
          }
        ],
        hourly_weather: [
          {
            time: '2024-04-21 00:00',
            temperature: 40.7,
            condition: 'Clear ',
            icon: '//cdn.weatherapi.com/weather/64x64/night/113.png'
          }
        ]
      })

    end
  end
end
