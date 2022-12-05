FactoryBot.define do
  factory :bar do
    name { Faker::Restaurant.name } 
  end
end
