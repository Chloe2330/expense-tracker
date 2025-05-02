class AddLockVersionToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_column :expenses, :lock_version, :integer, default: 0, null: false
  end
end
