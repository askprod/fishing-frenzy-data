class AddEventToCookingRecipes < ActiveRecord::Migration[8.0]
  def change
    add_reference :cooking_recipes, :event, foreign_key: true
    add_column :cooking_recipes, :available, :boolean
  end
end
