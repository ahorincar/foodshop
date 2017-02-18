class ShoppingList < ApplicationRecord
  def self.get_or_create_shopping_first
    shopping_list = ShoppingList.first

    if shopping_list.nil?
      shopping_list = ShoppingList.create(title: "Shopping List")
    end

    shopping_list
  end
end
