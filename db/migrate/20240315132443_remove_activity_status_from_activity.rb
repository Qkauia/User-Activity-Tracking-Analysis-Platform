class RemoveActivityStatusFromActivity < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :status
  end
end
