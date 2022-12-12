FactoryBot.define do
  factory :drink do
    name { Faker::Dessert.topping }
    img_url { Faker::Internet.url }
    bar
    steps { Faker::Lorem.sentence(word_count: 10) }
    ingredients_attributes { attributes_for_list(:ingredient, 3) }
  end
end
