# frozen_string_literal: true

class AddUserToActivities < ActiveRecord::Migration[7.1]
  def change
    add_reference :activities, :user, foreign_key: true
  end
end
