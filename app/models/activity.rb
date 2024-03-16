# frozen_string_literal: true

class Activity < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :bookings
  has_many :logs
  

  validates :title, :description, :start_time, :end_time, :location, :organizer, presence: true
  validates :max_participants, presence: true, numericality: { greater_than: 5, only_integer: true }
  validate :end_time_greater_than_start_time

  private

  def end_time_greater_than_start_time
    return if end_time.blank? || start_time.blank?

    return unless end_time <= start_time

    errors.add(:end_time, '必須晚於開始時間')
  end  
  
end
