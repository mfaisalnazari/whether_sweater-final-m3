class ForecastService
  
  def get_forecast(coordinates)
    response = get_url("/v1/forecast.json?q=#{coordinates}&days=6")
  end

  def get_url(url)
    response = conn.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    conn = Faraday.new(url: "https://api.weatherapi.com") do |faraday|
    faraday.params["key"] = Rails.application.credentials.weather_api[:api_key]
    end
  end
end