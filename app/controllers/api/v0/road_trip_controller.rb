class Api::V0::RoadTripController < ApplicationController
  def create
    
    user = User.find_by(api_key: road_trip_params[:api_key])
    # binding.pry
    if user
      road_trip = TripFacade.new(road_trip_params[:origin],road_trip_params[:destination]).get_trip_data
      response_data = {
      data: {
        id: nil,
        type: 'road_trip',
        attributes: 
          road_trip
      }
    }
    render json: response_data

    else
      render json: { error: 'Invalid API key' }, status: :unauthorized
    end
  end

  private

  def road_trip_params
    params.permit(:origin, :destination, :api_key)
  end
end
