# frozen_string_literal: true

class Activity < ApplicationRecord
  has_many :bookings
  has_many :logs
end
