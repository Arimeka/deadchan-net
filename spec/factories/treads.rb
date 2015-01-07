# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :tread do
    title { Faker::Lorem.characters(25) }
    content { Faker::Lorem.paragraph }
    board
  end
end
