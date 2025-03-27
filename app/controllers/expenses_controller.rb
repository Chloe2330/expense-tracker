class ExpensesController < ApplicationController
  before_action :set_expense, only: %i[ show edit update destroy ]

  def index
    @expenses = Expense.all
    if params[:sort].present?
      @expenses = @expenses.order(expense_date: params[:sort] == "asc" ? :asc : :desc)
    else
      @expenses = @expenses.order(:id)
    end
  end

  def show
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path, notice: "Expense was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to @expense
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path
  end

  def report
    @categories = Category.all

    # Base SQL query
    sql = "SELECT * FROM expenses WHERE 1=1"
    query_params = []

    # Filtering logic with prepared statements
    if params[:start_date].present?
      sql += " AND expense_date >= ?"
      query_params << params[:start_date]
    end

    if params[:end_date].present?
      sql += " AND expense_date <= ?"
      query_params << params[:end_date]
    end

    if params[:category_id].present?
      sql += " AND category_id = ?"
      query_params << params[:category_id]
    end

    # Execute the query
    @expenses = Expense.find_by_sql([ sql, *query_params ])

    # Calculate statistics using raw SQL
    total_expenses = Expense.find_by_sql([ "SELECT SUM(amount) AS total_expenses FROM expenses WHERE 1=1" + build_conditions(query_params), *query_params ]).first.total_expenses
    average_expense = Expense.find_by_sql([ "SELECT AVG(amount) AS average_expense FROM expenses WHERE 1=1" + build_conditions(query_params), *query_params ]).first.average_expense || 0
    total_count = Expense.find_by_sql([ "SELECT COUNT(*) AS total_count FROM expenses WHERE 1=1" + build_conditions(query_params), *query_params ]).first.total_count

    @stats = {
      total_expenses: total_expenses,
      average_expense: average_expense,
      total_count: total_count
    }
  end

  # Helper method to build condition string for the statistics queries
  def build_conditions(query_params)
    conditions = []
    conditions << " AND expense_date >= ?" if params[:start_date].present?
    conditions << " AND expense_date <= ?" if params[:end_date].present?
    conditions << " AND category_id = ?" if params[:category_id].present?
    conditions.join(" ")
  end

  private
    def set_expense
      @expense = Expense.find(params[:id])
    end

  private
    def expense_params
      params.require(:expense).permit(:description, :amount, :expense_date, :category_id)
    end
end
