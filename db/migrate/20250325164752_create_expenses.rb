class CreateExpenses < ActiveRecord::Migration[8.0]
  def change
    create_table :expenses do |t|
      t.string :description
      t.decimal :amount, precision: 10, scale: 2
      t.date :expense_date
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
