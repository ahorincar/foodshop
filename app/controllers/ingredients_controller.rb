class IngredientsController < ApplicationController
  before_action :set_ingredient, only: [:edit, :update, :destroy]

  def import
    @url = params[:url]
    unless @url.blank?
      success = Ingredient.extract_ingredients_from_url(@url)
      if success
        @ingredients = ShoppingList.get_or_create_first.ingredients
        respond_to do |format|
          format.js
        end
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
        format.html { redirect_to shopping_list_path, notice: 'Ingredient was successfully created.' }
        format.json { render :show, status: :created, location: @ingredient }
        format.js
      else
        format.html { render :new }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
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
        format.html { redirect_to shopping_list, notice: 'Ingredient was successfully updated.' }
        format.json { render :show, status: :ok, location: @ingredient }
        format.js   do
          @ingredients = shopping_list.ingredients
          render :create
        end
      else
        format.html { render :edit }
        format.json { render json: @ingredient.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /ingredients/1
  # DELETE /ingredients/1.json
  def destroy
    @ingredient.destroy
    respond_to do |format|
      format.html { redirect_to shopping_list_path, notice: 'Ingredient was successfully destroyed.' }
      format.json { head :no_content }
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
