class BookFacade
  def initialize(location,quantity)
    @location = location
    @quantity = quantity
  end

  def get_books
    result = BookService.new.get_book_details(@location,@quantity)

    num_found = result[:numFound]
    final_result = result[:docs].map do |book|
      title = book[:title]
      isbn = book[:isbn].take(3)
      publisher = book[:publisher].take(3)

      {
        title: title,
        isbn: isbn,
        publisher: publisher
      }
    end
    final_result_with_num_found = { num_found: num_found, books: final_result }
    
    final_result_with_num_found
    
  end
end