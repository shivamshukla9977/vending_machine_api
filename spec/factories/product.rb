require 'faker'

FactoryBot.define do
  factory :product do
    amount_available { Faker::Number.within(range: 1..1000) }
    cost { Faker::Number.within(range: 1..10) }
    product_name { Faker::Name.unique.name }
    seller_id { create(:user, role: :seller).id }
  end
end
