
class TripFacade
  def initialize(from, to)
    @origin = from
    @destination = to
  end

  def get_trip_data
    eta = RouteService.new.get_route(@origin, @destination)
    coordinates = LocationService.new.get_coordinates(@destination)
    result = ForecastService.new.get_forecast(coordinates)
    arrival_time = eta[:route][:formattedTime]
    current_time = result[:location][:localtime]
    current_time_epoch = result[:current][:last_updated_epoch]
    arrival_time_epoch = eta[:route][:time]
    # binding.pry
    if !arrival_time
      attributes = {
        "start_city": @origin,
        "end_city": @destination,
        "travel_time": "Impossible",
        "weather_at_eta": {
          
        }
      }
    else
      target_time_epoch = current_time_epoch + arrival_time_epoch
      eta_weather = find_closest_entry(result, target_time_epoch)
      attributes = {
        "start_city": @origin,
        "end_city": @destination,
        "travel_time": arrival_time,
        "weather_at_eta": {
          "datetime": eta_weather[:time],
          "temperature": eta_weather[:temp_f],
          "condition": eta_weather[:condition][:text]
        }
      }
    end
  end

  private

  def find_closest_entry(result, target_time_epoch)
    closest_entry = nil
    closest_difference = Float::INFINITY

    result[:forecast][:forecastday].each do |forecast_day|
      forecast_day[:hour].each do |entry|
        difference = (entry[:time_epoch] - target_time_epoch).abs
        if difference < closest_difference
          closest_difference = difference
          closest_entry = entry
        end
      end
    end

    closest_entry
  end
end