class CategoriesController < ApplicationController
    before_action :set_category, only: %i[ show ]

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

    private
    def set_category
      @category = Category.find(params[:id])
    end

    private
    def category_params
      params.require(:category).permit(:name, :description)
    end
end
