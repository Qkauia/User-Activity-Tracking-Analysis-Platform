class Log < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  belongs_to :booking
end
