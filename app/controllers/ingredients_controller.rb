class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :destroy]

  def import
    @url = params[:url]
    unless @url.blank?
      # If the ingredients could be extracted, then populate them in the list of
      # ingredients. Otherwise display an error message.
      if Ingredient.extract_ingredients_from_url(@url)
        @ingredients = ShoppingList.get_or_create_first.ingredients.sorted
        @message = "The ingredients were added to your shopping list."
        respond_to do |format|
          format.js
        end
      else
        @message = "The URL provided could not be accessed."
        respond_to do |format|
          format.js { render :import_message }
        end
      end
    else
      @message = "Please enter a URL."
      respond_to do |format|
        format.js { render :import_message }
      end
    end
  end

  def new
    @ingredient = Ingredient.new

    respond_to do |format|
      format.js
    end
  end

  def edit
    @ingredient = Ingredient.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def create
    # Ensure the ingredient has a shopping_list_id set.
    shopping_list = ShoppingList.get_or_create_first
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.shopping_list_id = shopping_list.id
    @ingredients = shopping_list.ingredients.sorted

    respond_to do |format|
      if @ingredient.save
        @message = "A new ingredient was added to your shopping list."
        format.js
      else
        format.js { render :new }
      end
    end
  end

  def update
    shopping_list = ShoppingList.find(@ingredient.shopping_list_id)
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        @message = "The ingredient has been updated."
        format.js   do
          @ingredients = shopping_list.ingredients.sorted
          render :create
        end
      else
        format.js { render :edit }
      end
    end
  end

  def destroy
    @ingredients = ShoppingList.get_or_create_first.ingredients.sorted
    @ingredient.destroy
    @message = "The ingredient has been deleted."
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ingredient
      @ingredient = Ingredient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ingredient_params
      params.require(:ingredient).permit(:name, :quantity, :metric)
    end
end
