# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  validates :name, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :logs
  has_many :bookings
  has_many :activities

  def already_booked?(activity)
    bookings.where(activity_id: activity.id).exists?
  end
end
