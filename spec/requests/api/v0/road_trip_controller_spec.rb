require 'rails_helper'

RSpec.describe "Api::V0::RoadTripController", type: :request do
  describe 'POST #create' do
  let!(:user) do
    User.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
  end
  
    context 'with valid parameters and API key' do
      before do
        user = User.all.first
        json_response_1 = File.read("spec/fixtures/forecast_sample.json")
         stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=6&key=#{Rails.application.credentials.weather_api[:api_key]}&q=39.10713,-84.50413").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response_1, headers: {})
         json_response1 = File.read("spec/fixtures/coordinates_sample.json")
         stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest[:api_key]}&location=Los%20Angeles").
            with(
              headers: {
             'Accept'=>'*/*',
             'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
             'User-Agent'=>'Faraday v2.9.0'
              }).
            to_return(status: 200, body: json_response1, headers: {})
        
        json_response = File.read("spec/fixtures/route_fixture.json")
         stub_request(:get, "https://www.mapquestapi.com/directions/v2/route?from=New%20York&key=TdBfKzgszEtwFrgxdsvEtsDUVZeyAJow&to=Los%20Angeles").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response, headers: {})
        post '/api/v0/road_trip', params: { origin: 'New York', destination: 'Los Angeles', api_key: user.api_key }
      end

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the road trip data' do
        expect(response_body['data']['type']).to eq('road_trip')
        expect(response_body['data']['attributes']).to include(
          'start_city',
          'end_city',
          'travel_time',
          'weather_at_eta'
        )
        expect(response_body['data']['attributes']['weather_at_eta']).to include(
          'datetime',
          'temperature',
          'condition'
        )
      end
      
    end

    context 'with invalid API key' do
      before do
        post '/api/v0/road_trip', params: { origin: 'New York', destination: 'Los Angeles', api_key: 'invalid_api_key' }
      end


      it 'returns unauthorized status' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns an error message' do
        expect(response_body['error']).to eq('Invalid API key')
      end
    end
  end

  def response_body
    JSON.parse(response.body)
  end
end
