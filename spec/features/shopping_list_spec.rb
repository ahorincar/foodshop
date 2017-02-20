require 'spec_helper'

RSpec.describe "Shopping List", type: :feature, js: true do
  describe "importing ingredients" do
    it "imports ingredients from external URL" do
      # check if toaster is present
      # check if shopping list was updated with the generated ingredients
    end

    it "shows toaster if URL is blank" do
      visit '/shopping_list'

      click_button("import-ingredients-btn")

      expect(page).to have_content 'Please enter a URL.'
    end

    it "shows toaster if URL could not be reached" do
      visit '/shopping_list'

      fill_in("url", with: "dummy_url")
      click_button("import-ingredients-btn")

      expect(page).to have_content 'The URL provided could not be accessed.'
    end
  end

  describe "viewing the shopping list" do
    it "shows a message if the shopping list is empty" do
      visit '/shopping_list'

      expect(page).to have_content 'Your shopping list is empty.'
    end

    it "shows the ingredients on the shopping list" do
      milk = create(:ingredient)
      juice = create(:ingredient, name: "orange juice", metric: "")
      chocolate = create(:ingredient, name: "chocolate", quantity: "", metric: "")

      visit '/shopping_list'

      expect("#ingredient-#{milk.id}").to have_content milk.name
      expect("#ingredient-#{milk.id}").to have_content milk.quantity.to_s + " " + milk.metric
      expect("#ingredient-#{juice.id}").to have_content juice.name
      expect("#ingredient-#{juice.id}").to have_content juice.quantity.to_s
      expect("#ingredient-#{chocolate.id}").to have_content chocolate.name
    end
  end
end
