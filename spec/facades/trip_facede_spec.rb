require 'rails_helper'

RSpec.describe TripFacade do
  let(:origin) { "New York" }
  let(:destination) { "Los Angeles" }
  let(:trip_facade) { TripFacade.new(origin, destination) }

  describe "#get_trip_data" do
    let(:route_service_double) { instance_double("RouteService") }
    let(:location_service_double) { instance_double("LocationService") }
    let(:forecast_service_double) { instance_double("ForecastService") }

    context "when arrival time is impossible" do
      before do
        allow(route_service_double).to receive(:get_route).and_return({ route: { formattedTime: nil } })
        allow(location_service_double).to receive(:get_coordinates).and_return({ latitude: 34.052235, longitude: -118.243683 })
        allow(forecast_service_double).to receive(:get_forecast).and_return({ current: { last_updated_epoch: 1642934400 }, location: { localtime: 1642930800 }, forecast: { forecastday: [{ hour: [] }] } })
      end

      it "returns trip data with impossible travel time" do
        allow(RouteService).to receive(:new).and_return(route_service_double)
        allow(LocationService).to receive(:new).and_return(location_service_double)
        allow(ForecastService).to receive(:new).and_return(forecast_service_double)

        trip_data = trip_facade.get_trip_data

        expect(trip_data).to eq(
          start_city: origin,
          end_city: destination,
          travel_time: "Impossible",
          weather_at_eta: {}
        )
      end
    end

    context "when arrival time is possible" do
      let(:eta_weather) do
        {
          time_epoch: 1642934000,
          temp_f: 70,
          condition: { text: "Sunny" }
        }
      end

      before do
        allow(route_service_double).to receive(:get_route).and_return({ route: { formattedTime: "10:00:00", time: 36000 } })
        allow(location_service_double).to receive(:get_coordinates).and_return({ latitude: 34.052235, longitude: -118.243683 })
        allow(forecast_service_double).to receive(:get_forecast).and_return({
          current: { last_updated_epoch: 1642930000 },
          location: { localtime: "09:02:00" },
          forecast: {
            forecastday: [
              {
                hour: [
                  { time_epoch: 1642927000, temp_f: 65, condition: { text: "Cloudy" } },
                  eta_weather,
                  { time_epoch: 16429431000, temp_f: 75, condition: { text: "Rainy" } }
                ]
              }
            ]
          }
        })
      end

      it "returns trip data with arrival time and weather at ETA" do
        allow(RouteService).to receive(:new).and_return(route_service_double)
        allow(LocationService).to receive(:new).and_return(location_service_double)
        allow(ForecastService).to receive(:new).and_return(forecast_service_double)
        trip_data = trip_facade.get_trip_data

        expect(trip_data).to eq(
          start_city: origin,
          end_city: destination,
          travel_time: "10:00:00",
          weather_at_eta: {
            datetime: eta_weather[:time],
            temperature: eta_weather[:temp_f], 
            condition: eta_weather[:condition][:text]
          }
        )
      end
    end
  end
end
