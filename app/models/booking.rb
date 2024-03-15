# frozen_string_literal: true

class Booking < ApplicationRecord
  acts_as_paranoid
  has_many :logs
  belongs_to :user
  belongs_to :activity

  validates :booker_name, presence: true
  validates :booker_email, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'E-Mail格式輸入錯誤' }, presence: true
  validates :user_id, uniqueness: { scope: :activity_id, message: '你已經參加了！' }

  scope :booking, -> { where(deleted_at: nil) }
end
