# frozen_string_literal: true

class RemoveTimestampFromLog < ActiveRecord::Migration[7.1]
  def change
    remove_column :logs, :timestamp
  end
end
