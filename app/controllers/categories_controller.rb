class CategoriesController < ApplicationController
    before_action :set_category, only: %i[ show edit update destroy ]

    def index
      @categories = Category.all
    end
    
    def show
    end

    def new
      @category = Category.new
    end

    def create
        @category = Category.new(category_params)
        if @category.save
          redirect_to expenses_path, notice: "Category was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
    end
  
    def update
      if @category.update(category_params)
        redirect_to @category
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        @category.destroy
        redirect_to categories_path, notice: 'Category was successfully deleted.'
      rescue ActiveRecord::InvalidForeignKey
        redirect_to categories_path, alert: 'Category cannot be deleted because it is referenced by an expense.'
      end
    end

    private
    def set_category
      @category = Category.find(params[:id])
    end

    private
    def category_params
      params.require(:category).permit(:name, :description)
    end
end
