require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it "should not save an ingredient without a name" do
    ingredient = Ingredient.new(shopping_list_id: "1", quantity: 1, metric: "tbsp")

    expect(ingredient.save).to be false
  end

  it "should not save an ingredient without a shopping list id" do
    ingredient = Ingredient.new(name: "milk", quantity: "1", metric: "l")

    expect(ingredient.save).to be false
  end

  it "should not save an ingredient without a quantity if metric is present" do
    ingredient = Ingredient.new(name: "milk", quantity: "", metric: "l")

    expect(ingredient.save).to be false
  end

  it "should not save an ingredient with a quantity that is not a number" do
    ingredient = Ingredient.new(name: "milk", quantity: "not_number")

    expect(ingredient.save).to be false
  end

  it "should extract HTML text when ingredient CSS class is present" do
    html = IO.read(Rails.root.join("spec", "fixtures", "recipe1.html"))

    expect(Ingredient.extract_ingredients_from_html(html).map { |e| e.text }).to eq([
      "250g pack slightly salted butter, softened",
      "750g icing sugar",
      "3 tbsp powdered malt drink",
      "1 tsp vanilla extract",
      "280g tub full-fat cream cheese",
    ])
  end
  #
  # it "should extract ingredient name from HTML text" do
  # end
  #
  # it "should extract tbsp and tsp from HTML text" do
  # end
  #
  # it "should extract g, kg, l and ml from HTML text" do
  # end
  #
  # it "should extract quantity from HTML text that does not have a metric" do
  # end
  #
  # it "should create ingredients based on extracted text" do
  # end
end
