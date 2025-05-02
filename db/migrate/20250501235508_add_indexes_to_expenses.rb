class AddIndexesToExpenses < ActiveRecord::Migration[8.0]
  def change
    add_index :expenses, :expense_date
  end
end
