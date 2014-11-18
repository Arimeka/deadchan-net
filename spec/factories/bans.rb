# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ban do
    reason "MyString"
    ban_type_id "MyString"
  end
end
