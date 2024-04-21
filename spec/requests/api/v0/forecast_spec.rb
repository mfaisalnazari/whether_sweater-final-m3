require 'rails_helper'

RSpec.describe "Forecast API", type: :request do
  describe "GET /api/v0/forecast" do
    it "returns forecast data with exact attributes" do
      json_response = File.read("spec/fixtures/coordinates_sample.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest[:api_key]}&location=cincinatti,oh").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response, headers: {})
        json_response_1 = File.read("spec/fixtures/forecast_sample.json")
         stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=6&key=#{Rails.application.credentials.weather_api[:api_key]}&q=39.10713,-84.50413").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response_1, headers: {})

      get "/api/v0/forecast", params: { location: "cincinatti,oh" }

      expect(response).to have_http_status(200)

      json_response = JSON.parse(response.body)

      expect(json_response["data"]["attributes"]["current_weather"]).to be_present
      current_weather = json_response["data"]["attributes"]["current_weather"]
      expect(current_weather.keys).to match_array(["last_updated", "temperature", "feels_like", "humidity", "uvi", "visibility", "condition", "icon"])

      expect(json_response["data"]["attributes"]["daily_weather"]).to be_present
      json_response["data"]["attributes"]["daily_weather"].each do |daily|
        expect(daily.keys).to match_array(["date", "sunrise", "sunset", "max_temp", "min_temp", "condition", "icon"])
      end

      expect(json_response["data"]["attributes"]["hourly_weather"]).to be_present
      json_response["data"]["attributes"]["hourly_weather"].each do |hourly|
        expect(hourly.keys).to match_array(["time", "temperature", "condition", "icon"])
      end

      expect(json_response["data"]["id"]).to be_nil
      
    end
  end
end
