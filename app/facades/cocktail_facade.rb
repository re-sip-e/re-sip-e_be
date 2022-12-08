class CocktailFacade
  def self.by_name(query)
    cocktails = CocktailService.get_search_results(query)[:drinks]
    cocktails.map do |cocktail|
      create_drink(cocktail)
    end
  end

  def self.three_random
    cocktails = CocktailService.get_three_random
    cocktails.map do |cocktail|
      cocktail = cocktail[:drinks][0]
      create_drink(cocktail)
    end
  end

  def self.cocktail_by_id(id)
    cocktail = CocktailService.get_cocktail_by_id(id)[:drinks]
    raise ActiveRecord::RecordNotFound, "Couldn't find Cocktail with 'id'=#{id}" unless cocktail

    cocktail = cocktail.first
    create_drink(cocktail)
  end

  def self.create_drink(cocktail)
    ingredients = create_ingredients(cocktail)
    Drink.new(id: cocktail[:idDrink],
              name: cocktail[:strDrink],
              img_url: cocktail[:strDrinkThumb],
              steps: cocktail[:strInstructions],
              ingredients: ingredients)
  end

  def self.create_ingredients(cocktail)
    ingredients = find_ingredients(cocktail)
    ingredients.map! do |ingredient|
      Ingredient.new(description: "#{ingredient[:measurement]} #{ingredient[:name]}")
    end
  end

  def self.find_ingredients(cocktail)
    ingredients = []
    15.times do |i|
      next unless cocktail["strIngredient#{i + 1}".to_sym]

      name = cocktail["strIngredient#{i + 1}".to_sym]
      measurement = cocktail["strMeasure#{i + 1}".to_sym]
      ingredients << { name: name, measurement: measurement }
    end
    ingredients
  end
end
