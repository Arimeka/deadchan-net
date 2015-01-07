# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ban_type do
    sequence(:type) { |n| "ban_type-#{n}"}
  end
end
