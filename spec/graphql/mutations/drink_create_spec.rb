require 'rails_helper'

RSpec.describe Mutations::DrinkCreate, type: :request do
  describe 'happy path' do
    it 'can add a drink with ingredients to a bar' do

      bar = create(:bar)

      drink_json = <<~JSON
        {
          "name":"Negroni",
          "steps":"Stir into glass over ice, garnish and serve.",
          "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
          "barId":#{bar.id},
          "ingredients": [
            {
              "description":"1 oz Gin"
            },
            {
              "description":"1 oz Campari"
            },
            {
              "description":"1 oz Sweet Vermouth"
            }
          ]
        }
      JSON

      gql_vars = <<~JSON
        {
          "input":{
            "drinkInput":#{drink_json}
          }
        }
      JSON

      mutation = <<~GQL
        mutation($input: DrinkCreateInput!){
          drinkCreate(input: $input){
            drink{
              id
              name
              steps
              imgUrl
              createdAt
              updatedAt
              ingredients{
                id
                description
              }
            }
          }
        }
      GQL

      post '/graphql', params: {query: mutation, variables: gql_vars}

      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      created_drink = Drink.last

      expect(created_drink.bar).to eq(bar)

      expect(created_drink.name).to eq("Negroni")
      expect(created_drink.img_url).to eq("https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg")
      expect(created_drink.steps).to eq("Stir into glass over ice, garnish and serve.")
      expect(created_drink.name).to eq("Negroni")

      expect(created_drink.ingredients[0].description).to eq("1 oz Gin")

      expect(created_drink.ingredients[1].description).to eq("1 oz Campari")

      expect(created_drink.ingredients[2].description).to eq("1 oz Sweet Vermouth")

      expected_result = {
        data: {
          drinkCreate: {
            drink: {
              id: created_drink.id.to_s,
              name: created_drink.name,
              steps: created_drink.steps,
              imgUrl: created_drink.img_url,
              createdAt: created_drink.created_at.iso8601,
              updatedAt: created_drink.updated_at.iso8601,
              ingredients: [
                {
                  id: created_drink.ingredients[0].id.to_s,
                  description: created_drink.ingredients[0].description
                },
                {
                  id: created_drink.ingredients[1].id.to_s,
                  description: created_drink.ingredients[1].description
                },
                {
                  id: created_drink.ingredients[2].id.to_s,
                  description: created_drink.ingredients[2].description
                }
              ]
            }
          }
        }
      }

      expect(result).to eq(expected_result)
    end
  end

  describe 'edge case' do
    it 'can successfully add a drink with ingredients to a bar even when errently using duplicate fields' do

      bar = create(:bar)

      drink_dup_fields_json = <<~JSON
        {
          "name":"Negroni",
          "name":"Negroni",
          "steps":"Stir into glass over ice, garnish and serve.",
          "steps":"Stir into glass over ice, garnish and serve.",
          "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
          "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
          "barId":#{bar.id},
          "barId":#{bar.id},
          "ingredients": [
            {
              "description":"1 oz Gin",
              "description":"1 oz Gin"
            },
            {
              "description":"1 oz Campari",
              "description":"1 oz Campari"
            },
            {
              "description":"1 oz Sweet Vermouth",
              "description":"1 oz Sweet Vermouth"
            }
          ]
        }
      JSON

      gql_vars = <<~JSON
        {
          "input":{
            "drinkInput":#{drink_dup_fields_json}
          }
        }
      JSON

      mutation_dup_fields = <<~GQL
        mutation($input: DrinkCreateInput!){
          drinkCreate(input: $input){
            drink{
              id
              id
              name
              name
              steps
              steps
              imgUrl
              imgUrl
              createdAt
              createdAt
              updatedAt
              updatedAt
              ingredients{
                id
                id
                description
                description
              }
            }
          }
        }
      GQL

      post '/graphql', params: {query: mutation_dup_fields, variables: gql_vars}
      expect(response).to be_successful

      result = JSON.parse(response.body, symbolize_names: true)
      created_drink = Drink.last

      expect(created_drink.bar).to eq(bar)

      expect(created_drink.name).to eq("Negroni")
      expect(created_drink.img_url).to eq("https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg")
      expect(created_drink.steps).to eq("Stir into glass over ice, garnish and serve.")
      expect(created_drink.name).to eq("Negroni")

      expect(created_drink.ingredients[0].description).to eq("1 oz Gin")

      expect(created_drink.ingredients[1].description).to eq("1 oz Campari")

      expect(created_drink.ingredients[2].description).to eq("1 oz Sweet Vermouth")

      expected_result = {
        data: {
          drinkCreate: {
            drink: {
              id: created_drink.id.to_s,
              name: created_drink.name,
              steps: created_drink.steps,
              imgUrl: created_drink.img_url,
              createdAt: created_drink.created_at.iso8601,
              updatedAt: created_drink.updated_at.iso8601,
              ingredients: [
                {
                  id: created_drink.ingredients[0].id.to_s,
                  description: created_drink.ingredients[0].description
                },
                {
                  id: created_drink.ingredients[1].id.to_s,
                  description: created_drink.ingredients[1].description
                },
                {
                  id: created_drink.ingredients[2].id.to_s,
                  description: created_drink.ingredients[2].description
                }
              ]
            }
          }
        }
      }

      expect(result).to eq(expected_result)
    end

    describe 'sad path' do
      let!(:bar){ create(:bar) }

      let!(:mutation) {
        <<~GQL
          mutation($input: DrinkCreateInput!){
            drinkCreate(input: $input){
              drink{
                id
                name
                steps
                imgUrl
                createdAt
                updatedAt
                ingredients{
                  id
                  description
                }
              }
            }
          }
        GQL
      }

      it 'cannot create a drink without a name or steps' do

        drink_json = <<~JSON
          {
            "name":"",
            "steps":"",
            "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "barId":#{bar.id},
            "ingredients": [
              {
                "description":"1 oz Gin"
              },
              {
                "description":"1 oz Campari"
              },
              {
                "description":"1 oz Sweet Vermouth"
              }
            ]
          }
        JSON

        gql_vars = <<~JSON
          {
            "input":{
              "drinkInput":#{drink_json}
            }
          }
        JSON

        post '/graphql', params: {query: mutation, variables: gql_vars}
        expect(response).to be_successful
        
        result = JSON.parse(response.body, symbolize_names: true)
        expected = {:data=>{:drinkCreate=>nil}, :errors=>[{:message=>"Error creating drink", :locations=>[{:line=>2, :column=>3}], :path=>["drinkCreate"], :extensions=>{:name=>["can't be blank"], :steps=>["can't be blank"]}}]}

        expect(result).to eq(expected)
      end


      it 'cannot create a drink without ingredients' do
        drink_json = <<~JSON
          {
            "name":"Water",
            "steps":"Stir into glass over ice, garnish and serve.",
            "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "barId":#{bar.id},
            "ingredients": []
          }
        JSON

        gql_vars = <<~JSON
          {
            "input":{
              "drinkInput":#{drink_json}
            }
          }
        JSON

        post '/graphql', params: {query: mutation, variables: gql_vars}
        expect(response).to be_successful
        
        result = JSON.parse(response.body, symbolize_names: true)
        expected = {:data=>{:drinkCreate=>nil}, :errors=>[{:message=>"Error creating drink", :locations=>[{:line=>2, :column=>3}], :path=>["drinkCreate"], :extensions=>{ :ingredients=>["can't be blank"]}}]}

        expect(result).to eq(expected)
      end

      it 'cannot create a drink without a valid bar id' do
        drink_json = <<~JSON
          {
            "name":"Negroni",
            "steps":"Stir into glass over ice, garnish and serve.",
            "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "barId":#{bar.id + 1},
            "ingredients": [
              {
                "description":"1 oz Gin"
              },
              {
                "description":"1 oz Campari"
              },
              {
                "description":"1 oz Sweet Vermouth"
              }
            ]
          }
        JSON

        gql_vars = <<~JSON
          {
            "input":{
              "drinkInput":#{drink_json}
            }
          }
        JSON

        post '/graphql', params: {query: mutation, variables: gql_vars}
        expect(response).to be_successful
        
        result = JSON.parse(response.body, symbolize_names: true)
        expected = {:data=>{:drinkCreate=>nil}, :errors=>[{:message=>"Error creating drink", :locations=>[{:line=>2, :column=>3}], :path=>["drinkCreate"], :extensions=>{:bar=>["must exist"]}}]}

        expect(result).to eq(expected)
      end

      it 'cant create a drink without a bar id provided' do
        drink_json = <<~JSON
          {
            "name":"Negroni",
            "steps":"Stir into glass over ice, garnish and serve.",
            "imgUrl":"https://www.thecocktaildb.com/images/media/drink/qgdu971561574065.jpg",
            "ingredients": [
              {
                "description":"1 oz Gin"
              },
              {
                "description":"1 oz Campari"
              },
              {
                "description":"1 oz Sweet Vermouth"
              }
            ]
          }
        JSON

        gql_vars = <<~JSON
          {
            "input":{
              "drinkInput":#{drink_json}
            }
          }
        JSON

        post '/graphql', params: {query: mutation, variables: gql_vars}
        expect(response).to be_successful
        
        result = JSON.parse(response.body, symbolize_names: true)
        expected = {:data=>{:drinkCreate=>nil}, :errors=>[{:message=>"Error creating drink", :locations=>[{:line=>2, :column=>3}], :path=>["drinkCreate"], :extensions=>{:bar=>["must exist"]}}]}

        expect(result).to eq(expected)
      end
    end
  end
end
