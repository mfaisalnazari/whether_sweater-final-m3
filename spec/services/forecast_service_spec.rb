require 'rails_helper'

RSpec.describe ForecastService do
  describe '#get_forecast' do
    let(:latitude) { 0 }
    let(:longitude) { 0 }
    let(:response_body) do
      {
        current: {
          last_updated: '2024-04-21 12:00',
          temp_f: 70,
          feelslike_f: 72,
          humidity: 60,
          uv: 5,
          vis_miles: 10,
          condition: { text: 'Sunny', icon: 'sun.png' }
        },
        forecast: {
          forecastday: [
            {
              date: '2024-04-21',
              astro: { sunrise: '06:00', sunset: '18:00' },
              day: { maxtemp_f: 75, mintemp_f: 65, condition: { text: 'Partly cloudy', icon: 'cloud.png' } },
              hour: [
                { time: '12:00', temp_f: 70, condition: { text: 'Sunny', icon: 'sun.png' } },
                { time: '15:00', temp_f: 72, condition: { text: 'Partly cloudy', icon: 'cloud.png' } }
              ]
            }
          ]
        }
      }.to_json
    end
    let(:fake_conn) { instance_double(Faraday::Connection) }
    let(:fake_response) { instance_double(Faraday::Response, body: response_body) }

    before do
      allow_any_instance_of(ForecastService).to receive(:conn).and_return(fake_conn)
      allow(fake_conn).to receive(:get).and_return(fake_response)
    end

    it 'returns forecast data' do
      forecast_service = ForecastService.new
      forecast_data = forecast_service.get_forecast({ latitude: latitude, longitude: longitude })

      expect(forecast_data[:current]).to eq({
        last_updated: '2024-04-21 12:00',
        temp_f: 70,
        feelslike_f: 72,
        humidity: 60,
        uv: 5,
        vis_miles: 10,
        condition: { text: 'Sunny', icon: 'sun.png' }
      })

      expect(forecast_data[:forecast][:forecastday]).to eq([
        {
          date: '2024-04-21',
          astro: { sunrise: '06:00', sunset: '18:00' },
          day: { maxtemp_f: 75, mintemp_f: 65, condition: { text: 'Partly cloudy', icon: 'cloud.png' } },
          hour: [
            { time: '12:00', temp_f: 70, condition: { text: 'Sunny', icon: 'sun.png' } },
            { time: '15:00', temp_f: 72, condition: { text: 'Partly cloudy', icon: 'cloud.png' } }
          ]
        }
      ])
    end
  end
end
