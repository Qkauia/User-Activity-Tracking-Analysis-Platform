# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :title
      t.text :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.integer :max_participants
      t.string :organizer
      t.string :status

      t.timestamps
    end
  end
end
