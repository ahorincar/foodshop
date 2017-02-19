class ShoppingList < ApplicationRecord
  before_save :add_title_if_not_provided
  has_many :ingredients

  TITLE_CONST = "Shopping List"

  def add_title_if_not_provided
    if self.title.nil?
      self.title = TITLE_CONST
    end
  end

  def self.get_or_create_first
    shopping_list = ShoppingList.first

    if shopping_list.nil?
      shopping_list = ShoppingList.create(title: TITLE_CONST)
    end

    shopping_list
  end
end
