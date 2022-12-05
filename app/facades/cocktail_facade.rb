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

  def self.three_random
      cocktails = CocktailService.get_three_random
      cocktails.map do |cocktail|
        ingredients = []
        15.times do |i|
          if cocktail[:drinks][0]["strIngredient#{i+1}".to_sym]
            name = cocktail[:drinks][0]["strIngredient#{i+1}".to_sym]
            measurement = cocktail[:drinks][0]["strMeasure#{i+1}".to_sym]
            ingredients << { name: name, measurement: measurement }
          end
        end
        ingredients.map! do |ingredient|
          Ingredient.new(name: ingredient[:name], quantity: ingredient[:measurement])
        end
        Drink.new(id: cocktail[:drinks][0][:idDrink], name: cocktail[:drinks][0][:strDrink], img_url: cocktail[:drinks][0][:strDrinkThumb], steps: cocktail[:drinks][0][:strInstructions], ingredients: ingredients)
      end
    end

  def self.cocktail_by_id(id)
    cocktail = CocktailService.get_cocktail_by_id(id)[:drinks].first
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
