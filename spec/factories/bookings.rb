# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    user
    activity
    booker_name { '花女士' }
    booker_email { 'test@test.com' }
    deleted_at { nil }
  end
end
