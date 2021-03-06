require 'rails_helper'

RSpec.describe ShoppingList, type: :model do
  it "must have name" do
    shopping_list = ShoppingList.create!();
    expect(shopping_list.title).to eq("Shopping List")
  end

  it "creates first if it doesn't exist" do
    shopping_list = ShoppingList.get_or_create_first
    expect(ShoppingList.first).to eq(shopping_list)
  end

  it "gets first if exists" do
    first_shopping_list = ShoppingList.create!(title: "Shopping List")
    shopping_list = ShoppingList.get_or_create_first

    expect(shopping_list).to eq(first_shopping_list)
    expect(ShoppingList.first).to eq(first_shopping_list)
  end
end
