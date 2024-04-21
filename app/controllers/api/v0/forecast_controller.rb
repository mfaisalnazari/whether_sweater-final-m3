class Api::V0::ForecastController < ApplicationController
  def show
    forecast = WeatherFacade.new(params[:location]).get_forecast_data
    # render json: ForecastSerializer.new(forecast)
    response_data = {
      data: {
        id: nil,
        type: 'forecast',
        attributes: {
          current_weather: forecast[:current_weather],
          daily_weather: forecast[:daily_weather],
          hourly_weather: forecast[:hourly_weather]
        }
      }
    }

    render json: response_data
  end
end
