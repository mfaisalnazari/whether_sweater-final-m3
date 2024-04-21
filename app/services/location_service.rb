class LocationService
  def get_coordinates(location)
    response = get_url("geocoding/v1/address?location=#{location}")
    lat = response[:results][0][:locations][0][:latLng][:lat]
    lng = response[:results][0][:locations][0][:latLng][:lng]
    coordinatess = "#{lat},#{lng}"
  end

  def get_url(url)
    response = conn.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    conn = Faraday.new(url: "https://www.mapquestapi.com") do |faraday|
    faraday.params["key"] = Rails.application.credentials.map_quest[:api_key]
    end
  end
end