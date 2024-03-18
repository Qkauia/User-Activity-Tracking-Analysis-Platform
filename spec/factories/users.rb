FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    admin { false }
    sequence(:name) { |n| "艸先生#{n}" } 
    password { "111111" } 
  end
end


