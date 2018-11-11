require 'spec_helper'

RSpec.describe "Ingredients", type: :feature, js: true do

  describe "managing ingredients" do
    it "adds a new ingredient" do
      milk = build(:ingredient)
      visit '/shopping_list'
      click_link 'New Ingredient'

      fill_in('Name', with: milk.name)
      fill_in('Quantity', with: milk.quantity)
      fill_in('Metric', with: milk.metric)
      click_button('Save')

      expect(page).to have_content 'A new ingredient was added to your shopping list.'

      milk_saved = Ingredient.first

      expect("#ingredient-#{milk_saved.id}").to have_content milk.name
      expect("#ingredient-#{milk_saved.id}").to have_content milk.quantity.to_s + " " + milk.metric
    end

    it "edits an ingredient" do
      milk = build(:ingredient)
      juice = create(:ingredient, name: "orange juice")

      visit '/shopping_list'
      click_link "edit-ingredient-btn_#{juice.id}"

      expect(page).to have_content 'Edit Ingredient'

      fill_in('Name', with: milk.name)
      fill_in('Quantity', with: milk.quantity)
      fill_in('Metric', with: milk.metric)
      click_button('Save')

      expect(page).to have_content 'The ingredient has been updated.'
      expect("#ingredient-#{juice.id}").to have_content milk.name
      expect("#ingredient-#{juice.id}").to have_content milk.quantity.to_s + " " + milk.metric
    end

    it "deletes an ingredient" do
      chocolate = create(:ingredient, name: "chocolate", quantity: "", metric: "")

      visit '/shopping_list'

      find("label[for='checkbox_#{chocolate.id}']").click

      expect(page).to have_content 'The ingredient has been deleted.'
      expect(page).to have_no_css("#ingredient-#{chocolate.id}")
    end
  end
end
