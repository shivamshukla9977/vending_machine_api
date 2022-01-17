require 'faker'

FactoryBot.define do
  sequence :email do |n|
    "test#{n}@example.com"
  end

  factory :user do
    email { generate :email }
    username { Faker::Name.unique.name }
    password { "12345678" }
    password_confirmation { "12345678" }
    role { :seller }
  end
end
