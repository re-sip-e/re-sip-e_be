class CocktailService

  def self.get_three_random
    3.times.collect do
      response = conn.get("/api/json/v1/1/random.php")
      JSON.parse(response.body, symbolize_names: true)
    end
  end


  private

  def self.conn
    Faraday.new(url: 'https://www.thecocktaildb.com')
  end
end