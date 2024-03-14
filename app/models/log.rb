# frozen_string_literal: true

class Log < ApplicationRecord
  belongs_to :user
  belongs_to :activity, optional: true
  belongs_to :booking, optional: true
end
