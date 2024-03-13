class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  has_many :logs
end
