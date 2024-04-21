require 'rails_helper'

RSpec.describe LocationService do
  describe '#get_coordinates' do
    let(:location) { 'Denver,co' }
    let(:lat) { 40.7128 }
    let(:lng) { -74.0060 }
    let(:response_body) do
      {
        results: [
          {
            locations: [
              {
                latLng: { lat: lat, lng: lng }
              }
            ]
          }
        ]
      }.to_json
    end
    let(:fake_conn) { instance_double(Faraday::Connection) }
    let(:fake_response) { instance_double(Faraday::Response, body: response_body) }

    before do
      allow_any_instance_of(LocationService).to receive(:conn).and_return(fake_conn)
      allow(fake_conn).to receive(:get).and_return(fake_response)
    end

    it 'returns coordinates for a given location' do
      coordinates = LocationService.new.get_coordinates(location)
      expect(coordinates).to eq("#{lat},#{lng}")
    end
  end
end
