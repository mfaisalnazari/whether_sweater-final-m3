require 'rails_helper'

RSpec.describe BookService do
  describe '#get_book_details' do
    let(:location) { 'Denver, CO' }
    let(:quantity) { 5 }
    let(:service) { BookService.new }

    context 'when making a request to the API' do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(
          instance_double(Faraday::Response, body: '[{"title": "Book 1", "isbn": "1234567890", "publisher": "Publisher 1"}, {"title": "Book 2", "isbn": "0987654321", "publisher": "Publisher 2"}]')
        )
      end

      it 'returns book details' do
        expect(service.get_book_details(location, quantity)).to eq([
          { title: 'Book 1', isbn: '1234567890', publisher: 'Publisher 1' },
          { title: 'Book 2', isbn: '0987654321', publisher: 'Publisher 2' }
        ])
      end

      it 'makes a request to the correct API endpoint' do
        expect_any_instance_of(Faraday::Connection).to receive(:get).with('/search.json?q=Denver, CO&mode=books&limit=5')
        service.get_book_details(location, quantity)
      end
    end
  end
end
