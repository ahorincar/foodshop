json.extract! ingredient, :id, :name, :quantity, :metric, :shopping_list_id, :created_at, :updated_at
json.url ingredient_url(ingredient, format: :json)