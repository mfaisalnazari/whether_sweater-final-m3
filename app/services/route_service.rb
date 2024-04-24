class RouteService
  def get_route(from,to)
    response = get_url("/directions/v2/route?from=#{from}&to=#{to}")
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