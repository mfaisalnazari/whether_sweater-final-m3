require 'rails_helper'
RSpec.describe BookFacade do
  let(:location) { 'Denver, CO' }
  let(:quantity) { 2 }
  let(:book_service) { instance_double(BookService) }
  
  describe '#get_books' do
    subject { BookFacade.new(location, quantity).get_books }
    
    context 'when BookService returns valid data' do
      let(:result) do
        {
          numFound: 2,
          docs: [
            {
              title: 'Denver, Co',
              isbn: ['0762507845', '9780762507849'],
              publisher: ['Universal Map Enterprises'],
              author_name: ['some'], # Corrected author_name value
              publish_date: ['January 2001'],
              language: ['eng']
            },
            {
              title: 'Photovoltaic safety, Denver, CO, 1988',
              isbn: ['9780883183663', '0883183668'],
              publisher: ['American Institute of Physics'],
              author_name: ['Some Author'],
              publish_date: ['1988'],
              language: ['eng']
            }
          ]
        }
      end
      
      before do
        allow(BookService).to receive(:new).and_return(book_service)
        allow(book_service).to receive(:get_book_details).with(location, quantity).and_return(result)
      end
      
      it 'returns books with filtered data' do
        expect(subject[:num_found]).to eq(2)
        expect(subject[:books].size).to eq(2)
        # binding.pry
        expect(subject[:books][0][:title]).to eq('Denver, Co')
        expect(subject[:books][0][:isbn]).to eq(['0762507845', '9780762507849'])
        expect(subject[:books][0][:publisher]).to eq(['Universal Map Enterprises'])
        
        expect(subject[:books][1][:title]).to eq('Photovoltaic safety, Denver, CO, 1988')
        expect(subject[:books][1][:isbn]).to eq(['9780883183663', '0883183668'])
        expect(subject[:books][1][:publisher]).to eq(['American Institute of Physics'])
      end
    end
  end
end
