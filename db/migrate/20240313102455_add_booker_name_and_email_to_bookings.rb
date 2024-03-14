# frozen_string_literal: true

class AddBookerNameAndEmailToBookings < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :booker_name, :string
    add_column :bookings, :booker_email, :string
  end
end
