FactoryBot.define do
  factory :ingredient do
    name { Faker::Dessert.topping }
    drink
    quantity { Faker::Food.measurement }
  end
end
