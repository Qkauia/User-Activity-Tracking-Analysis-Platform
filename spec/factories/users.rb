FactoryBot.define do
  factory :user do
    email { |n| "user#{n}@example.com" }
    admin { false }
    name { "艸先生" }
    password { "111111" }
  end
end


