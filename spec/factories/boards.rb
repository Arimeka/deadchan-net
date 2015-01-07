# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :board do
    title { Faker::Lorem.characters(25) }
    abbr  { Faker::Lorem.characters(3) }
  end
end
