FactoryBot.define do
  factory :drink do
    name { Faker::Dessert.topping }
    img_url { Faker::Internet.url }
    bar
    steps { Faker::Lorem.sentence(word_count: 10) }
  end
end
