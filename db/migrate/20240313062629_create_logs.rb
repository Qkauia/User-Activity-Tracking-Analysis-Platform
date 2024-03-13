class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :activity, null: false, foreign_key: true
      t.references :booking, null: false, foreign_key: true
      t.string :log_type
      t.datetime :timestamp

      t.timestamps
    end
  end
end
