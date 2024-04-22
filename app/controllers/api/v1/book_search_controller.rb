class Api::V1::BookSearchController < ApplicationController
  def book_search
    forecast = WeatherFacade.new(params[:location]).get_forecast_data[:current_weather]
    books = BookFacade.new(params[:location],params[:quantity]).get_books

    response_data = {
      data: {
        id: nil,
        type: 'books',
        attributes: {
          destination: params[:location],
          forecast: {
            summary: forecast[:condition],
            temperature: "#{forecast[:temperature]} F"
          },
          total_books_found: books[:num_found],
          books: books[:books].map do |book|
            {
              isbn: book[:isbn],
              title: book[:title],
              publisher: book[:publisher]
            }
          end}}}
    render json: response_data
  end
end
