require 'rails_helper'

RSpec.describe Types::DrinkType, type: :request do
  describe 'happy path' do
    it 'can find drinks by name from api', :vcr do
      query_drinks = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      expected = { 'data' => {
        'apiDrinks' => [{
          'id' => '11003',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg',
          'ingredients' => [{
            'description' => '1 oz  Gin'
          }, {
            'description' => '1 oz  Campari'
          }, {
            'description' => '1 oz  Sweet Vermouth'
          }],
          'name' => 'Negroni',
          'steps' => 'Stir into glass over ice, garnish and serve.'
        }, {
          'id' => '17248',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/x8lhp41513703167.jpg',
          'ingredients' => [{
            'description' => '1 oz Gin'
          }, {
            'description' => '1 oz Lillet'
          }, {
            'description' => '1 oz Sweet Vermouth'
          }, {
            'description' => '1 Orange Peel'
          }],
          'name' => 'French Negroni',
          'steps' => "Add ice to a shaker and pour in all ingredients.\nUsing a bar spoon, stir 40 to 45 revolutions or until thoroughly chilled.\nStrain into a martini glass or over ice into a rocks glass. Garnish with orange twist."
        }, {
          'id' => '178340',
          'imgUrl' => 'https://www.thecocktaildb.com/images/media/drink/kb4bjg1604179771.jpg',
          'ingredients' => [{
            'description' => '30 ml Gin'
          }, {
            'description' => '30 ml Campari'
          }, {
            'description' => '90 ml Orange Juice'
          }, {
            'description' => 'Garnish with Orange Peel'
          }],
          'name' => 'Garibaldi Negroni',
          'steps' => 'Mix together in a shaker and garnish with a simple orange slice. Fill your vitamin C and cocktail fix at the same time!'
        }]
      } }

      post '/graphql', params: { query: query_drinks }
      result = JSON.parse(response.body)
      expect(response).to be_successful
      expect(result).to eq(expected)
    end
  end

  describe 'Edge Case' do
    it 'If a search is done that provides no results an error message is recieved', :vcr do

      query_drinks_api_no_response = <<~GQL
        query {
          apiDrinks(query: "potato") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_no_response }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      
      expected = { data: { apiDrinks: [] } }
      expect(result).to eq(expected)
    end


    it 'If Cocktail DB API is not responsive an Error is returned in GraphQL' do
      stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=negroni').to_return(status: 500)

      query_drinks_api_down = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_down }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(result[:errors][0][:message]).to eq('the server responded with status 500')
    end

    it 'If an Invalid request is sent to the Cocktail DB API a server Error is returned in GraphQL' do
      stub_request(:get, 'https://www.thecocktaildb.com/api/json/v1/1/search.php?s=negroni').to_return(status: 400)

      query_drinks_api_down = <<~GQL
        query {
          apiDrinks(query: "negroni") {
            id
            name
            imgUrl
            steps
            ingredients {
              description
            }
          }
        }
      GQL

      post '/graphql', params: { query: query_drinks_api_down }
      result = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(result[:errors][0][:message]).to eq('the server responded with status 400')
    end

    describe 'get_search_results method in the cocktail service' do

      it 'provides a response if no results found in the API', :vcr do
        query_no_results = <<~GQL
          query {
            apiDrinks(query: "gdfjsipgbrqipgbr") {
              id
              name
              imgUrl
              steps
              ingredients {
                description
              }
            }
          }
        GQL

        expected = {:data=>{:apiDrinks=>[]}}

        post '/graphql', params: { query: query_no_results }
        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to eq(expected)
        expect(response).to be_successful
        expect(CocktailFacade.by_name('gdfjsipgbrqipgbr')).to eq([])
      end

      it 'can return a response if a partial name is searched', :vcr do
        query_partial_search = <<~GQL
          query {
            apiDrinks(query: "daqui") {
              id
              name
              imgUrl
              steps
              ingredients {
                description
              }
            }
          }
        GQL

        expected = {:data=>{:apiDrinks=>[]}}

        post '/graphql', params: { query: query_partial_search }
        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to eq(expected)
        expect(response).to be_successful
      end

      it 'can return a response if a drink name is searched with incorrect spelling', :vcr do
        query_incorrect_spelling = <<~GQL
          query {
            apiDrinks(query: "negrone") {
              id
              name
              imgUrl
              steps
              ingredients {
                description
              }
            }
          }
        GQL

        expected = {:data=>{:apiDrinks=>[]}}

        post '/graphql', params: { query: query_incorrect_spelling }
        result = JSON.parse(response.body, symbolize_names: true)

        expect(result).to eq(expected)
        expect(response).to be_successful
      end

      it 'can return a response if a multi word name is searched', :vcr do
          query_multi_word = <<~GQL
            query {
              apiDrinks(query: "black russian") {
                id
                name
                imgUrl
                steps
                ingredients {
                  description
                }
              }
            }
          GQL

          expected = {:data => {
                        :apiDrinks=>[{
                          :id=>"11102",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/8oxlqf1606772765.jpg",
                          :ingredients=>[{
                            :description=>"3/4 oz  Coffee liqueur"}, {
                            :description=>"1 1/2 oz  Vodka"}],
                          :name=>"Black Russian",
                          :steps=>"Pour the ingredients into an old fashioned glass filled with ice cubes. Stir gently."}, {:id=>"11243", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/yyvywx1472720879.jpg", :ingredients=>[{:description=>"1 oz  Kahlua"}, {:description=>"1/2 oz  Vodka"}, {:description=>"5 oz  Chocolate ice-cream"}], :name=>"Chocolate Black Russian", :steps=>"Combine all ingredients in an electric blender and blend at a low speed for a short length of time. Pour into a chilled champagne flute and serve."}]}}

          post '/graphql', params: { query: query_multi_word }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(result).to eq(expected)
          expect(response).to be_successful
      end

      it 'can return a response if a number is searched', :vcr do
          query_w_number = <<~GQL
            query {
              apiDrinks(query: "7") {
                id
                name
                imgUrl
                steps
                ingredients {
                  description
                }
              }
            }
          GQL

          expected = {:data => {
                        :apiDrinks=>[{
                          :id=>"14229",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/xxsxqy1472668106.jpg",
                          :ingredients=>[{
                            :description=>"1/3 part  Kahlua"}, {
                            :description=>"1/3 part  Baileys irish cream"}, {
                            :description=>"1/3 part  Frangelico"}],
                          :name=>"747",
                          :steps=>"pour kaluha, then Baileys, then Frangelico not chilled and not layered -- SERVE!!!"}, {
                          :id=>"178322",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/0108c41576797064.jpg",
                          :ingredients=>[{
                            :description=>"60 ml Sugar"}, {
                            :description=>"1 tblsp Allspice"}, {
                            :description=>"20 cl Rum"}, {
                            :description=>"90 ml Lime Juice"}, {
                            :description=>"6 cl Champagne"}, {
                            :description=>"Garnish with Orange spiral"}],
                          :name=>"Spice 75",
                          :steps=>"Gently warm 60g golden caster sugar in a pan with 30ml water and 1 tbsp allspice. Cook gently until the sugar has dissolved, then leave the mixture to cool. Strain through a sieve lined with a coffee filter (or a double layer of kitchen paper).\r\n\r\nPour 60ml of the spiced syrup into a cocktail shaker along with 200ml rum and 90ml lime juice. Shake with ice and strain between six flute glasses. Top up with 600ml champagne and garnish each with an orange twist."}, {
                            :id=>"17197",
                            :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/hrxfbl1606773109.jpg",
                            :ingredients=>[{
                              :description=>"1 1/2 oz  Gin"}, {
                              :description=>"2 tsp superfine  Sugar"}, {
                              :description=>"1 1/2 oz  Lemon juice"}, {
                              :description=>"4 oz Chilled  Champagne"}, {
                              :description=>"1  Orange"}, {
                              :description=>"1  Maraschino cherry"}],
                            :name=>"French 75", :steps=>"Combine gin, sugar, and lemon juice in a cocktail shaker filled with ice. Shake vigorously and strain into a chilled champagne glass. Top up with Champagne. Stir gently."}, {
                            :id=>"178318", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/i9suxb1582474926.jpg",
                            :ingredients=>[{
                              :description=>"1 oz Vodka"}, {
                              :description=>"1 oz Roses sweetened lime juice"}, {
                              :description=>"1 oz Cranberry Juice"}, {
                              :description=>"Top Sprite"}],
                            :name=>"747 Drink",
                            :steps=>"Fill a Collins glass with ice.\r\nPour in vodka, lime cordial, and cranberry juice.\r\nFill up with Sprite.\r\nGarnish with a Lime wheel or some cranberries"}, {
                            :id=>"14029",
                            :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/qyyvtu1468878544.jpg",
                            :ingredients=>[{
                              :description=>"1 oz white  Creme de Cacao"}, {
                              :description=>"1 oz  Vodka"}],
                            :name=>"57 Chevy with a White License Plate",
                            :steps=>"1. Fill a rocks glass with ice 2.add white creme de cacao and vodka 3.stir"}]}}

          post '/graphql', params: { query: query_w_number }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(result).to eq(expected)
          expect(response).to be_successful
      end

      it 'can return a response if an empty string is searched', :vcr do
          query_no_text = <<~GQL
            query {
              apiDrinks(query: "") {
                id
                name
                imgUrl
                steps
                ingredients {
                  description
                }
              }
            }
          GQL

          expected = {:data => {
                        :apiDrinks=>[{
                          :id=>"15997",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/vyxwut1468875960.jpg",
                          :ingredients=>[{
                            :description=>"2 1/2 shots  Galliano"}, {
                            :description=>" Ginger ale"}, {
                            :description=>" Ice"}],
                          :name=>"GG",
                          :steps=>"Pour the Galliano liqueur over ice. Fill the remainder of the glass with ginger ale and thats all there is to it. You now have a your very own GG."}, {:id=>"17222", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/2x8thr1504816928.jpg", :ingredients=>[{:description=>"1 3/4 shot  Gin"}, {:description=>"1 Shot  Grand Marnier"}, {:description=>"1/4 Shot Lemon Juice"}, {:description=>"1/8 Shot Grenadine"}], :name=>"A1", :steps=>"Pour all ingredients into a cocktail shaker, mix and serve over ice into a chilled glass."}, {
                          :id=>"13501",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/tqpvqp1472668328.jpg",
                          :ingredients=>[{
                            :description=>"1/3  Amaretto"}, {
                            :description=>"1/3  Baileys irish cream"}, {
                            :description=>"1/3  Cognac"}],
                          :name=>"ABC",
                          :steps=>"Layered in a shot glass."}, {
                          :id=>"17203",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/apneom1504370294.jpg",
                          :ingredients=>[{
                            :description=>"1 part  Creme de Cassis"}, {
                            :description=>"5 parts  Champagne"}],
                          :name=>"Kir",
                          :steps=>"Add the crème de cassis to the bottom of the glass, then top up with wine."}, {
                          :id=>"14229",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/xxsxqy1472668106.jpg",
                          :ingredients=>[{
                            :description=>"1/3 part  Kahlua"}, {
                            :description=>"1/3 part  Baileys irish cream"}, {
                            :description=>"1/3 part  Frangelico"}],
                          :name=>"747",
                          :steps=>"pour kaluha, then Baileys, then Frangelico not chilled and not layered -- SERVE!!!"}, {
                          :id=>"15288",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/rtpxqw1468877562.jpg",
                          :ingredients=>[{
                            :description=>"1/2 shot Bacardi  151 proof rum"}, {
                            :description=>"1/2 shot  Wild Turkey"}],
                          :name=>"252",
                          :steps=>"Add both ingredients to shot glass, shoot, and get drunk quick"}, {
                          :id=>"17225",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/l3cd7f1504818306.jpg",
                          :ingredients=>[{
                            :description=>"2 shots  Gin"}, {
                            :description=>"1/2 shot  Grenadine"}, {
                            :description=>"1/2 shot  Heavy cream"}, {
                            :description=>"1/2 shot Milk"}, {
                            :description=>"1/2 Fresh Egg White"}],
                          :name=>"Ace", :steps=>"Shake all the ingredients in a cocktail shaker and ice then strain in a cold glass."}, {
                          :id=>"17837", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/v0at4i1582478473.jpg",
                          :ingredients=>[{
                            :description=>"2 oz  Dark rum"}, {
                            :description=>"1 oz  Lemon juice"}, {
                            :description=>"1 tsp  Grenadine"}],
                          :name=>"Adam",
                          :steps=>"In a shaker half-filled with ice cubes, combine all of the ingredients. Shake well. Strain into a cocktail glass."}, {:id=>"13332", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/rwqxrv1461866023.jpg", :ingredients=>[{:description=>"1/3 shot  Kahlua"}, {:description=>"1/3 shot  Sambuca"}, {:description=>"1/3 shot  Grand Marnier"}], :name=>"B-53", :steps=>"Layer the Kahlua, Sambucca and Grand Marnier into a shot glas in that order. Better than B-52"}, {
                          :id=>"13938",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/rhhwmp1493067619.jpg",
                          :ingredients=>[{
                            :description=>"1 oz  Absolut Vodka"}, {
                            :description=>"1 oz  Gin"}, {
                            :description=>"4 oz  Tonic water"}],
                          :name=>"AT&T",
                          :steps=>"Pour Vodka and Gin over ice, add Tonic and Stir"}, {
                          :id=>"14610",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/xuxpxt1479209317.jpg",
                          :ingredients=>[{
                            :description=>"1 oz Bacardi  151 proof rum"}, {
                            :description=>"1 oz  Wild Turkey"}],
                          :name=>"ACID",
                          :steps=>"Poor in the 151 first followed by the 101 served with a Coke or Dr Pepper chaser."}, {
                          :id=>"15853",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/5a3vg61504372070.jpg",
                          :ingredients=>[{
                            :description=>"1/3  Baileys irish cream"}, {
                            :description=>"1/3  Grand Marnier"}, {
                            :description=>"1/4  Kahlua"}],
                          :name=>"B-52",
                          :steps=>"Layer ingredients into a shot glass. Serve with a stirrer."}, {
                          :id=>"16262",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/upusyu1472667977.jpg",
                          :ingredients=>[{
                            :description=>"4 cl  Whisky"}, {
                            :description=>"8 cl  Baileys irish cream"}, {
                            :description=>" Coffee"}],
                          :name=>"H.D.",
                          :steps=>"Mix the whisky and Baileys Cream in a beer-glass (at least 50 cl). Fill the rest of the glass with coffee."}, {
                          :id=>"17141",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/rx8k8e1504365812.jpg",
                          :ingredients=>[{
                            :description=>"1/3 part  Red wine"}, {
                            :description=>"1 shot  Peach schnapps"}, {
                            :description=>"1/3 part  Pepsi Cola"}, {
                            :description=>"1/3 part  Orange juice"}],
                          :name=>"Smut",
                          :steps=>"Throw it all together and serve real cold."}, {
                          :id=>"17208",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/8kxbvq1504371462.jpg",
                          :ingredients=>[{
                            :description=>"1/2 oz  Dry Vermouth"}, {
                            :description=>"1 oz  Gin"}, {
                            :description=>"1/2 oz  Apricot brandy"}, {
                            :description=>"1/2 tsp  Lemon juice"}, {
                            :description=>"1 tsp  Grenadine"}, {
                            :description=>" Powdered sugar"}],
                          :name=>"Rose",
                          :steps=>"Shake together in a cocktail shaker, then strain into chilled glass. Garnish and serve."}, {
                          :id=>"17833",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/l74qo91582480316.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Applejack"}, {
                            :description=>"1 oz  Grapefruit juice"}],
                          :name=>"A. J.",
                          :steps=>"Shake ingredients with ice, strain into a cocktail glass, and serve."}, {
                          :id=>"17187",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/52weey1606772672.jpg",
                          :ingredients=>[{
                            :description=>"6 cl gin"}, {
                            :description=>"2 dashes Peach Bitters"}, {
                            :description=>"2 Fresh leaves Mint"}],
                          :name=>"Derby",
                          :steps=>"Pour all ingredients into a mixing glass with ice. Stir. Strain into a cocktail glass. Garnish with a sprig of fresh mint in the drink."}, {:id=>"12764", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/808mxk1487602471.jpg", :ingredients=>[{:description=>"1 part  Coffee"}, {:description=>"2 parts  Grain alcohol"}], :name=>"Karsk", :steps=>"Put a copper coin in a coffe-cup and fill up with coffee until you no longer see the coin, then add alcohol until you see the coin. Norwegian speciality."}, {
                          :id=>"12776",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/xwtptq1441247579.jpg",
                          :ingredients=>[{
                            :description=>" Espresso"}, {
                            :description=>"Unsweetened  Honey"}, {
                            :description=>" Cocoa powder"}],
                          :name=>"Melya",
                          :steps=>"Brew espresso. In a coffee mug, place 1 teaspoon of unsweetened powdered cocoa, then cover a teaspoon with honey and drizzle it into the cup. Stir while the coffee brews, this is the fun part. The cocoa seems to coat the honey without mixing, so you get a dusty, sticky mass that looks as though it will never mix. Then all at once, presto! It looks like dark chocolate sauce. Pour hot espresso over the honey, stirring to dissolve. Serve with cream."}, {
                          :id=>"14598",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/wwpyvr1461919316.jpg",
                          :ingredients=>[{
                            :description=>"2 1/2 oz  Vanilla vodka"}, {
                            :description=>"1 splash  Grand Marnier"}, {
                            :description=>"Fill with  Orange juice"}],
                          :name=>"50/50",
                          :steps=>"fill glass with crushed ice. Add vodka. Add a splash of grand-marnier. Fill with o.j."}, {
                          :id=>"15328",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/kvvd4z1485621283.jpg",
                          :ingredients=>[{
                            :description=>"2 cl  Sambuca"}, {
                            :description=>"2 cl  Baileys irish cream"}, {
                            :description=>"2 cl  White Creme de Menthe"}],
                          :name=>"Zorro",
                          :steps=>"add all and pour black coffee and add whipped cream on top."}, {
                          :id=>"17254",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/rysb3r1513706985.jpg",
                          :ingredients=>[{
                            :description=>"1 dash Orange Bitters"}, {
                            :description=>"1 oz Green Chartreuse"}, {
                            :description=>"1 oz Gin"}, {
                            :description=>"1 oz Sweet Vermouth"}],
                          :name=>"Bijou",
                          :steps=>"Stir in mixing glass with ice and strain\r\n"}, {
                          :id=>"17839",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/h5za6y1582477994.jpg",
                          :ingredients=>[{
                            :description=>"2 oz  Strawberry schnapps"}, {
                            :description=>"2 oz  Orange juice"}, {
                            :description=>"2 oz  Cranberry juice"}, {
                            :description=>" Club soda"}],
                          :name=>"Affair",
                          :steps=>"Pour schnapps, orange juice, and cranberry juice over ice in a highball glass. Top with club soda and serve."}, {
                          :id=>"11149",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/pwgtpa1504366376.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Gin"}, {
                            :description=>"1 oz  Triple sec"}, {
                            :description=>"1 tsp  Lemon juice"}, {
                            :description=>"1/2 tsp  Grenadine"}, {
                            :description=>"1  Egg white"}],
                          :name=>"Boxcar",
                          :steps=>"In a shaker half-filled with ice cubes, combine all of the ingredients. Shake well. Strain into a sour glass."}, {
                          :id=>"11872", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/vr6kle1504886114.jpg",
                          :ingredients=>[{
                            :description=>"1/2 oz white  Creme de Cacao"}, {
                            :description=>"1/2 oz  Amaretto"}, {
                            :description=>"1/2 oz  Triple sec"}, {
                            :description=>"1/2 oz  Vodka"}, {
                            :description=>"1 oz  Light cream"}],
                          :name=>"Orgasm",
                          :steps=>"Shake all ingredients with ice, strain into a chilled cocktail glass, and serve."}]}}

          post '/graphql', params: { query: query_no_text }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(result).to eq(expected)
          expect(response).to be_successful

      end

      it 'can return a response if multiple fields are quried', :vcr do
          query_multi = <<~GQL
            query {
              apiDrinks(query: "daiquiri") {
                id
                id
                name
                name
                imgUrl
                steps
                steps
                ingredients {
                  description
                }
              }
            }
          GQL

          expected = {:data => {
                        :apiDrinks=>[{
                          :id=>"11006",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/mrz9091589574515.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Light rum"}, {
                            :description=>"Juice of 1/2  Lime"}, {
                            :description=>"1 tsp  Powdered sugar"}],
                          :name=>"Daiquiri",
                          :steps=>"Pour all ingredients into shaker with ice cubes. Shake well. Strain in chilled cocktail glass."}, {
                          :id=>"11064",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/k1xatq1504389300.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Light rum"}, {
                            :description=>"1 tblsp  Triple sec"}, {
                            :description=>"1  Banana"}, {
                            :description=>"1 1/2 oz  Lime juice"}, {
                            :description=>"1 tsp  Sugar"}, {
                            :description=>"1  Cherry"}],
                          :name=>"Banana Daiquiri",
                          :steps=>"Pour all ingredients into shaker with ice cubes. Shake well. Strain in chilled cocktail glass."}, {
                          :id=>"11387", :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/7oyrj91504884412.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Light rum"}, {
                            :description=>"1 tblsp  Triple sec"}, {
                            :description=>"1 1/2 oz  Lime juice"}, {
                            :description=>"1 tsp  Sugar"}, {
                            :description=>"1  Cherry"}, {
                            :description=>"1 cup crushed  Ice"}],
                          :name=>"Frozen Daiquiri",
                          :steps=>"Combine all ingredients (except for the cherry) in an electric blender and blend at a low speed for five seconds, then blend at a high speed until firm. Pour contents into a champagne flute, top with the cherry, and serve."}, {
                          :id=>"12316",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/deu59m1504736135.jpg",
                          :ingredients=>[{
                            :description=>"1/2 oz  Strawberry schnapps"}, {
                            :description=>"1 oz  Light rum"}, {
                            :description=>"1 oz  Lime juice"}, {
                            :description=>"1 tsp  Powdered sugar"}, {
                            :description=>"1 oz  Strawberries"}],
                          :name=>"Strawberry Daiquiri",
                          :steps=>"Pour all ingredients into shaker with ice cubes. Shake well. Strain in chilled cocktail glass."}, {
                          :id=>"11390",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/jrhn1q1504884469.jpg",
                          :ingredients=>[{
                            :description=>"2 oz  Light rum"}, {
                            :description=>"1 tblsp  Lime juice"}, {
                            :description=>"6  Mint"}, {
                            :description=>"1 tsp  Sugar"}],
                          :name=>"Frozen Mint Daiquiri",
                          :steps=>"Combine all ingredients with 1 cup of crushed ice in an electric blender. Blend at a low speed for a short length of time. Pour into an old-fashioned glass and serve."}, {
                          :id=>"11391",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/k3aecd1582481679.jpg",
                          :ingredients=>[{
                            :description=>"1 1/2 oz  Light rum"}, {
                            :description=>"4 chunks  Pineapple"}, {
                            :description=>"1 tblsp  Lime juice"}, {
                            :description=>"1/2 tsp  Sugar"}],
                          :name=>"Frozen Pineapple Daiquiri",
                          :steps=>"Combine all ingredients with 1 cup of crushed ice in an electric blender. Blend at a low speed for a short length of time. Pour into a cocktail glass and serve."}, {
                          :id=>"12658",
                          :imgUrl=>"https://www.thecocktaildb.com/images/media/drink/uvypss1472720581.jpg",
                          :ingredients=>[{
                            :description=>"1/2 lb frozen  Strawberries"}, {
                            :description=>"1 frozen  Banana"}, {
                            :description=>"2 cups fresh  Apple juice"}],
                          :name=>"Banana Strawberry Shake Daiquiri",
                          :steps=>"Blend all together in a blender until smooth."}]},}

          post '/graphql', params: { query: query_multi }
          result = JSON.parse(response.body, symbolize_names: true)

          expect(result).to eq(expected)
          expect(response).to be_successful

      end

    end

  end
end
