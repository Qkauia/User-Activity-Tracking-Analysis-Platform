# frozen_string_literal: true

class Booking < ApplicationRecord
  has_many :logs
  belongs_to :user
  belongs_to :activity

  validates :booker_name, presence: true
  validates :booker_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'E-Mail格式輸入錯誤' }, presence: true
  validates :user_id, uniqueness: { scope: :activity_id, message: '你已經參加了！' }
end
