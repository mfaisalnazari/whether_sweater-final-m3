class BookService

  def get_book_details(location,quantity)
    response = get_url("/search.json?q=#{location}&mode=books&limit=#{quantity}")
    
  end

  def get_url(url)
    response = conn.get(url)
    data = JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    conn = Faraday.new(url: "https://openlibrary.org")
  end
end