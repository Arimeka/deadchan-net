# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ban do
    reason { Faker::Lorem.paragraph }
    self.until { Time.now + 1.day }
    request_ip { Faker::Internet.ip_v4_address }
    ban_type
  end
end
