FactoryBot.define do
  factory :ingredient do
    description { Faker::Dessert.topping } #+ Faker::Food.measurement
  end
end
