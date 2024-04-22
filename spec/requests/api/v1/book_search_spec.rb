require 'rails_helper'

RSpec.describe "Api::V1::BookSearches", type: :request do
  describe "book_search" do
    before do
      json_response = File.read("spec/fixtures/book_search/coordniates_sample.json")
      stub_request(:get, "https://www.mapquestapi.com/geocoding/v1/address?key=#{Rails.application.credentials.map_quest[:api_key]}&location=denver,co").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response, headers: {})
       
        json_response_1 = File.read("spec/fixtures/book_search/forecast_sample.json")
        stub_request(:get, "https://api.weatherapi.com/v1/forecast.json?days=6&key=bdc0d9a22f394ca39f6161734241904&q=39.74001,-104.99202").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response_1, headers: {})
        
        json_response_2 = File.read("spec/fixtures/book_search/book_sample.json")
        stub_request(:get, "https://openlibrary.org/search.json?limit=5&mode=books&q=denver,co").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v2.9.0'
           }).
         to_return(status: 200, body: json_response_2, headers: {})

      get "/api/v1/book-search?location=denver,co&quantity=5"
    end

    it 'returns the books data with forecast and total_books_found' do
      expect(response).to have_http_status(:ok)
      expect(response.content_type).to include('application/json')

      response_data = JSON.parse(response.body)
      # binding.pry

      expect(response_data['data']["type"]).to eq('books')
      expect(response_data["data"]["attributes"]["destination"]).to eq("denver,co")
      expect(response_data["data"]["attributes"]["forecast"]["summary"]).to eq("Partly cloudy")
      expect(response_data["data"]["attributes"]["forecast"]["temperature"]).to eq("69.4 F")
      expect(response_data["data"]["attributes"]["total_books_found"]).to eq(781)
      expect(response_data["data"]["attributes"]["books"].length).to eq(5)

      first_book = response_data["data"]["attributes"]["books"][0]
      expect(first_book["title"]).to eq("Denver, Co")
      expect(first_book["isbn"]).to eq(["0762507845", "9780762507849"])
      expect(first_book["publisher"]).to eq(["Universal Map Enterprises"])
    end
  end
end
