class Expense < ApplicationRecord
  belongs_to :category
  validates :description, presence: true 
  validates :amount, presence: true
  validates :expense_date, presence: true
  validates :category_id, presence: true 
end
