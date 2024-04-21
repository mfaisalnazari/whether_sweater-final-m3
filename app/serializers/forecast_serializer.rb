class ForecastSerializer 
  include JSONAPI::Serializer
  attributes :id, :type, :attributes

  def id
    nil
  end

  def type
    'forecast'
  end

  def attributes
    {
      current_weather: current_weather,
      daily_weather: daily_weather,
      hourly_weather: hourly_weather
    }
  end

  def current_weather
    {
      last_updated: object[:current_weather][:last_updated],
      temperature: object[:current_weather][:temperature],
      feels_like: object[:current_weather][:feels_like],
      humidity: object[:current_weather][:humidity],
      uvi: object[:current_weather][:uvi],
      visibility: object[:current_weather][:visibility],
      condition: object[:current_weather][:condition],
      icon: object[:current_weather][:icon]
    }
  end

  def daily_weather
    object[:daily_weather].map do |daily|
      {
        date: daily[:date],
        sunrise: daily[:sunrise],
        sunset: daily[:sunset],
        max_temp: daily[:max_temp],
        min_temp: daily[:min_temp],
        condition: daily[:condition],
        icon: daily[:icon]
      }
    end
  end

  def hourly_weather
    object[:hourly_weather].map do |hourly|
      {
        time: hourly[:time],
        temperature: hourly[:temperature],
        conditions: hourly[:condition],
        icon: hourly[:icon]
      }
    end
  end
end
