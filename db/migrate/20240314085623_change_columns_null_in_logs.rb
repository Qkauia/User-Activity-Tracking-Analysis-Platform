# frozen_string_literal: true

class ChangeColumnsNullInLogs < ActiveRecord::Migration[7.1]
  def change
    change_column_null :logs, :activity_id, true
    change_column_null :logs, :booking_id, true
  end
end
