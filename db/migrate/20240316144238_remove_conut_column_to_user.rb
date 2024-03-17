# frozen_string_literal: true

class RemoveConutColumnToUser < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :sign_in_count
    remove_column :users, :sign_out_count
    remove_column :users, :reset_password_count
    remove_column :users, :registration_count
  end
end
