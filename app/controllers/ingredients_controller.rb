class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :destroy]

  def import
    @url = params[:url]
    unless @url.blank?
      success = Ingredient.extract_ingredients_from_url(@url)
      if success
        @ingredients = ShoppingList.get_or_create_first.ingredients
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

  # GET /ingredients/1/edit
  def edit
    @ingredient = Ingredient.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  # POST /ingredients
  # POST /ingredients.json
  def create
    # Ensure the ingredient has a shopping_list_id set.
    shopping_list = ShoppingList.get_or_create_first
    @ingredient = Ingredient.new(ingredient_params)
    @ingredient.shopping_list_id = shopping_list.id
    @ingredients = shopping_list.ingredients

    respond_to do |format|
      if @ingredient.save
        @message = "A new ingredient was added to your shopping list."
        format.js
      else
        format.js { render :new }
      end
    end
  end

  # PATCH/PUT /ingredients/1
  # PATCH/PUT /ingredients/1.json
  def update
    shopping_list = ShoppingList.find(@ingredient.shopping_list_id)
    respond_to do |format|
      if @ingredient.update(ingredient_params)
        @message = "The ingredient has been updated."
        format.js   do
          @ingredients = shopping_list.ingredients
          render :create
        end
      else
        format.js { render :edit }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredients = ShoppingList.get_or_create_first.ingredients
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
