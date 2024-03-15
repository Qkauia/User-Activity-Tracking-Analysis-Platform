class RenameLogTypeToType < ActiveRecord::Migration[7.1]
  def change
    rename_column :logs, :log_type, :type
  end
end
