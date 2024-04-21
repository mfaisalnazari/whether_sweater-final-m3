class WeatherFacade
  def initialize(location)
    @location = location
  end

  def get_forecast_data
    coordinates = LocationService.new.get_coordinates(@location)
    result = ForecastService.new.get_forecast(coordinates)

    current_weather_data = result[:current]
    current_weather = {
    last_updated: current_weather_data[:last_updated],
    temperature: current_weather_data[:temp_f],
    feels_like: current_weather_data[:feelslike_f],
    humidity: current_weather_data[:humidity],
    uvi: current_weather_data[:uv],
    visibility: current_weather_data[:vis_miles],
    condition: current_weather_data[:condition][:text],
    icon: current_weather_data[:condition][:icon]}
    
    daily_weather_forecast = result[:forecast][:forecastday].map do |day_forecast|
      {
        date: day_forecast[:date],
        sunrise: day_forecast[:astro][:sunrise],
        sunset: day_forecast[:astro][:sunset],
        max_temp: day_forecast[:day][:maxtemp_f],
        min_temp: day_forecast[:day][:mintemp_f],
        condition: day_forecast[:day][:condition][:text],
        icon: day_forecast[:day][:condition][:icon]
      }
    end
    
    hourly_weather_forecast = result[:forecast][:forecastday].first[:hour].map do |hour_forecast|
      {
        time: hour_forecast[:time],
        temperature: hour_forecast[:temp_f],
        condition: hour_forecast[:condition][:text],
        icon: hour_forecast[:condition][:icon]
      }
    end
   
    {
    current_weather: current_weather,
    daily_weather: daily_weather_forecast,
    hourly_weather: hourly_weather_forecast
  }
  end
end