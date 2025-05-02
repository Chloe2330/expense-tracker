# Expense Tracker 

A simple Rails application for tracking personal expenses.

## Features
- Add, edit, delete expenses
- Categorize expenses
- Filter and report by date range and category
- View summary statistics (total, average, count)

## Indexes
- Primary key index on `expenses.id` and `categories.id`
- Index on `expenses.category_id` (foreign key)
- Index on `expenses.expense_date` for date-range filtering

## Usage
```bash
bundle install
rails db:setup
rails server
