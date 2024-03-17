FactoryBot.define do
  factory :log do
    user
    activity
    booking
    type { "訪問頁面" }
  end
end
