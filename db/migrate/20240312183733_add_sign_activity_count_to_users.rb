# frozen_string_literal: true

class AddSignActivityCountToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :sign_out_count, :integer, default: 0, null: false
    add_column :users, :registration_count, :integer, default: 0, null: false
    add_column :users, :reset_password_count, :integer, default: 0, null: false
  end
end
