class CocktailFacade
  def self.by_name(query)
    cocktails = CocktailService.get_search_results(query)[:drinks]
    cocktails.map do |cocktail|
      ingredients = []
      15.times do |i|
        if cocktail["strIngredient#{i+1}".to_sym]
          name = cocktail["strIngredient#{i+1}".to_sym]
          measurement = cocktail["strMeasure#{i+1}".to_sym]
          ingredients << { name: name, measurement: measurement }
        end
      end
      ingredients.map! do |ingredient|
        Ingredient.new(name: ingredient[:name], quantity: ingredient[:measurement])
      end
      Drink.new(id: cocktail[:idDrink], name: cocktail[:strDrink], img_url: cocktail[:strDrinkThumb], steps: cocktail[:strInstructions], ingredients: ingredients)
    end
  end

  def self.cocktail_by_id(id)
    
  end
end