# frozen_string_literal: true

FactoryBot.define do
  factory :log do
    user
    activity
    booking
    type { '預訂送出' }
    # after(:create) do |log|
    #   users = create_list(:user, 10)
    #   activity = create(:activity, user: users.first)
    #   booking = create(:booking, user: users.second, activity: activity)
    #   create(:log, booking: booking, type: "預訂送出")
    # end
  end
end
