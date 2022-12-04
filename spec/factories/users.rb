FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    location { "#{Faker::Address.city}, #{Faker::Address.state}" }
    email { Faker::Internet.email }
  end
end
