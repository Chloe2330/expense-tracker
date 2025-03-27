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

    # Filtering logic
    @expenses = Expense.all
    @expenses = @expenses.where("expense_date >= ?", params[:start_date]) if params[:start_date].present?
    @expenses = @expenses.where("expense_date <= ?", params[:end_date]) if params[:end_date].present?
    @expenses = @expenses.where(category_id: params[:category_id]) if params[:category_id].present?

    # Calculate statistics
    total_expenses = @expenses.sum(:amount)
    average_expense = @expenses.average(:amount) || 0
    total_count = @expenses.count

    @stats = {
      total_expenses: total_expenses,
      average_expense: average_expense,
      total_count: total_count
    }
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
