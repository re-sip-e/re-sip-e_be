class CocktailFacade 
  def self.three_random 
    cocktails = CocktailService.get_three_random[:drinks]
    cocktails.map do |cocktail|
      require 'pry' ; binding.pry
    end
  end
end