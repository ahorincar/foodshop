class CreateIngredients < ActiveRecord::Migration[5.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false
      t.float :quantity
      t.string :metric
      t.integer :shopping_list_id, null: false

      t.timestamps
    end
  end
end
