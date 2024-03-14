# frozen_string_literal: true

class AddDeletedAtToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :deleted_at, :datetime
    add_index :activities, :deleted_at
  end
end
