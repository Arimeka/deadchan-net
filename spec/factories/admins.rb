# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :admin do
    email { Faker::Internet.email }
    password 'foobarfoo'
    password_confirmation 'foobarfoo'
  end
end
