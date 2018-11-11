FactoryGirl.define do
  factory :ingredient do
    name "milk"
    quantity  1
    metric "l"
    shopping_list { ShoppingList.get_or_create_first }
  end
end
