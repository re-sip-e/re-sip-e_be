class CocktailService

  def self.get_search_results(query)
    response = conn.get("/api/json/v1/1/search.php?s=#{query}")
    JSON.parse(response.body, symbolize_names: true)
  end

  private

  def self.conn
    Faraday.new(url: 'https://www.thecocktaildb.com')
  end
end