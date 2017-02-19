class ShoppingListsController < ApplicationController
  def index
    @shopping_list = ShoppingList.get_or_create_first
  end
end
