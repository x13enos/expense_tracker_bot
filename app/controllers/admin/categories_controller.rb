class Admin::CategoriesController < Admin::BaseController
  before_action :find_category, :only => [:edit, :update, :destroy]
  def index
    @categories = Category.order('created_at DESC')
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_attributes)
    if @category.save
      redirect_to admin_categories_path, :notice => "Category was created"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @category.update(category_attributes)
      redirect_to admin_categories_path, :notice => "Category was updated"
    else
      render :edit
    end
  end

  def destroy
    if @category.delete
      redirect_to admin_categories_path, :notice => "Category was deleted"
    else
      redirect_to admin_categories_path, :alert => "Category wasn't deleted"
    end
  end

  private

  def find_category
    @category = Category.find(params[:id])
  end

  def category_attributes
    params.require(:category).permit(:name, :financial_type)
  end
end
